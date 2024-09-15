local fs = require 'sebas.utils.fs'

-- TODO: migrate this to lua
vim.cmd [=[
function! GetUserName(ctx) abort
  return expand("$USER")
endfunction

function! GetHostName(ctx) abort
  return system("echo -n $HOST")
endfunction

function! GetOriginLink(ctx, prefix) abort
  if empty(a:ctx.origin)
    return ''
  endif

  let l:page = wiki#paths#shorten_relative(a:ctx.origin.file)
  let l:page = fnamemodify(l:page, ':r')
  let l:label = wiki#template#case_title(a:ctx, l:page)

  return a:prefix . ': [[' . l:page . '][' . l:label . ']]'
endfunction


function! GetQOD(ctx) abort
  let l:resp = json_decode(system('curl --no-progress-meter https://zenquotes.io/api/random'))

  let l:quote = "#+begin_quote
  \\n" . l:resp[0].q .
  \"\n---" . l:resp[0].a.
  \"\n#+end_quote"

  return l:quote
endfunction
]=]

vim.g.wiki_templates = {
  {
    match_func = function(ctx)
      return ctx.path:sub(-4) == '.org' and not ctx.path:find 'journal/'
    end,
    source_filename = fs.join(vim.fn.stdpath 'data', 'templates', 'org', 'default.org'),
  },
  {
    match_func = function(ctx)
      return ctx.path:sub(-4) == '.org' and ctx.path:find 'journal/'
    end,
    source_filename = fs.join(vim.fn.stdpath 'data', 'templates', 'org', 'journal.org'),
  },
}
