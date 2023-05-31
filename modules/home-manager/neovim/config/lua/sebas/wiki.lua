local fs = require 'sebas.utils.fs'

-- TODO use common config taken from  nvim-orgmode
vim.g.wiki_root = '~/Documents/org'
vim.g.wiki_filetypes = { 'org' }

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
  let l:resp = json_decode(system('curl --no-progress-meter https://api.quotable.io/random'))

  let l:quote = "#+begin_quote
  \\n" . l:resp.content .
  \"\n---" . l:resp.author .
  \"\n#+end_quote"

  return l:quote
endfunction
]=]

vim.g.wiki_templates = {
  {
    match_func = function(ctx)
      return ctx.path:sub(-4) == '.org' and not ctx.path:find 'journal/'
    end,
    source_filename = fs.join(vim.fn.stdpath 'data', 'templates', 'default.org'),
  },
  {
    match_func = function(ctx)
      return ctx.path:sub(-4) == '.org' and ctx.path:find 'journal/'
    end,
    source_filename = fs.join(vim.fn.stdpath 'data', 'templates', 'journal.org'),
  },
}

local g = vim.api.nvim_create_augroup('init_wiki', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = g,
  pattern = 'WikiLinkFollowed',
  desc = 'Wiki: Center view on link follow',
  command = [[ normal! zz ]],
})
vim.api.nvim_create_autocmd('User', {
  group = g,
  pattern = 'WikiBufferInitialized',
  desc = 'Wiki: add mapping for gf',
  command = [[ nmap <buffer> gf <plug>(wiki-link-follow) ]],
})
