local M = {}

local function week_number_to_date(week_number, year)
  local first_week_of_year = os.time { year = year, month = 1, day = 1 }

  while tonumber(os.date([[%w]], first_week_of_year)) ~= 1 do
    first_week_of_year = first_week_of_year + 86400
  end
  return first_week_of_year + ((week_number * 7) * 84600)
end

local function week_number(time)
  time = time or os.time()
  local week = tonumber(os.date([[%W]], time)) or -1

  -- corner case, e.g., 2024/01/01 return "0"
  -- it's because week 1 starts on Jan 2
  -- return previous week number
  if week == 0 then
    return week_number(time - (7 * 84600))
  else
    return week
  end
end

M.buffer_has_contents = function(bufid)
  local content = vim.api.nvim_buf_get_lines(bufid, 0, -1, false)
  return not (#content > 1 or content[1] ~= '')
end

M.daily_file_tree_week_number = function(raw, offset)
  local pattern = [[^.*/journal/(%d%d%d%d)/(%d%d)/(%d%d).norg$]]
  offset = offset or 0

  local year, month, day = string.match(raw, pattern)
  if year == nil or month == nil or day == nil then
    vim.notify(string.format("'%s': invalid path", raw), vim.log.levels.WARN)
    return 0, 0
  end

  local current_date = os.time { year = year, month = month, day = day }

  return year, week_number(current_date + ((offset * 7) * 84600))
end

M.weekly_file_tree_week_number = function(raw, offset)
  local pattern = [[^.*/journal/(%d%d%d%d)/W.(%d%d).norg$]]
  offset = offset or 0

  local year, week = string.match(raw, pattern)
  if year == nil or week == nil then
    vim.notify(string.format("'%s': invalid path", raw), vim.log.levels.WARN)
    return 0, 0
  end

  local time = week_number_to_date(week, year) + ((offset * 7) * 84600)

  local number = week_number(time)
  year = os.date('%Y', time)

  return year, number
end
return M
