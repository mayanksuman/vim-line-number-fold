""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Vim- Line-Number-Fold
"" Vim Plugin for line number support in
"" Normal, Insert and Folded Code
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin can not be loaded twice or in compatibility mode
" Plugin cannot be loaded in vim version <7.3
if exists('g:vim_number_fold_loaded') || &cp || v:version < 703
  finish
endif

let g:vim_number_fold_loaded=1

" Numbering function to be used in Normal and Insert Mode
function! EnableRelativeNumber()
	set number
	set relativenumber
endfunc

function! DisableRelativeNumber()
	set number
	set norelativenumber
endfunc

function! ToggleNumber()
	set number
	if (&relativenumber==1)
		set norelativenumber
	else
		set relativenumber
	endif
endfunc

function UpdateNumberByMode(curr_mode)
	if (a:curr_mode==0)
		" Normal Mode
		let g:is_insert_mode=0
		let g:is_normal_mode=1
		call EnableRelativeNumber()
	elseif (a:curr_mode==1)
		" Insert Mode
		let g:is_insert_mode=1
		let g:is_normal_mode=0
		call DisableRelativeNumber()
	endif
endfunction

function UpdateNumberByFocus(curr_focus)
	if (a:curr_focus==0)
		call UpdateNumberByMode(1)
	else
		" When focus is gained: It is always a Normal mode
		call UpdateNumberByMode(0)
	endif
endfunction

" Automatically set relative line numbers when opening a new document
autocmd BufNewFile * :call UpdateNumberByMode(0)
autocmd BufReadPost * :call UpdateNumberByMode(0)
autocmd FilterReadPost * :call UpdateNumberByMode(0)
autocmd FileReadPost * :call UpdateNumberByMode(0)

" Automatically switch to absolute numbers when focus is lost and
" switch back when the focus is regained.
autocmd FocusLost * :call UpdateNumberByFocus(0)
autocmd FocusGained * :call UpdateNumberByFocus(1)
autocmd WinLeave * :call UpdateNumberByFocus(0)
autocmd WinEnter * :call UpdateNumberByFocus(1)
autocmd CmdwinLeave * :call UpdateNumberByFocus(0)
autocmd CmdwinEnter * :call UpdateNumberByFocus(1)

" Switch to absolute line numbers when entering insert mode and switch
" back to relative line numbers when switching back to normal mode.
autocmd InsertEnter * :call UpdateNumberByMode(1)
autocmd InsertLeave * :call UpdateNumberByMode(0)


" ---------------
" Better Folded line number
" http://dhruvasagar.com/2013/03/28/vim-better-foldtext
" ---------------
function! NeatFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

set foldtext=NeatFoldText()
