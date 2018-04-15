" The MIT License (MIT)
"
" Copyright (c) 2018 Urbain Vaes
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

let s:default_precedence = 'tpane'
let s:default_mode = 'winonly'
let s:default_boundary = 'reflect'

function! s:get_tmux_cmd(wincmd)
  if $TMUX == ""
    return ""
  elseif s:tmux_cmd == ""
    let argument = a:wincmd . " dry"
    let script = $WINTAB_ROOT . "/sh/tmux-wintabcmd"
    let s:tmux_cmd=system('sh '.script." ".a:wincmd." dry")
  endif
  return s:tmux_cmd
endfunction

function! wintab#wintab(wincmd)

  let precedence = get(g:, 'wintab_precedence', s:default_precedence)
  let mode = get(g:, 'wintab_mode', s:default_mode)
  let boundary = get(g:, 'wintab_boundary', s:default_boundary)
  let s:tmux_cmd=""

  if precedence == 'vtab'
    let order = ['vwin', 'vtab', 'tpane', 'twin']
  else
    let order = ['vwin', 'tpane', 'vtab', 'twin']
  endif

  for elem in order

    " Vim window
    if elem == 'vwin'
      let winnum = winnr()
      execute 'wincmd' a:wincmd
      if winnum != winnr()
        return
      endif

    " Tmux pane
    elseif elem == 'tpane' && s:get_tmux_cmd(a:wincmd) =~ "select-pane"
      call system(s:tmux_cmd) | return

    " Vim tab
    elseif mode == 'wintab' && elem == 'vtab'
      if tabpagenr() > 1 && a:wincmd == 'h'
        tabprevious | return
      elseif tabpagenr() < tabpagenr('$') && a:wincmd == 'l'
        tabnext | return
      endif

    " Tmux window
    elseif elem == 'twin' && s:get_tmux_cmd(a:wincmd) =~ "select-window"
      call system(s:tmux_cmd) | return
    endif

  endfor

  if mode == 'winonly'
    if a:wincmd == 'h'
      topleft vnew
    elseif a:wincmd == 'j'
      botright new
    elseif a:wincmd == 'k'
      topleft new
    elseif a:wincmd == 'l'
      botright vnew
    endif
  elseif mode == 'wintab'
    if boundary == 'create'
      tabnew
      if a:wincmd == 'h'
        tabmove 0
      endif
    elseif boundary == 'reflect'
      if a:wincmd == 'h'
        tabprevious
      elseif a:wincmd == 'l'
        tabnext
      endif
    endif
  endif

endfunction

" vim: sw=2
