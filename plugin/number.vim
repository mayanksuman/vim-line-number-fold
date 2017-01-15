if exists('g:vim_number_fold_loaded') || &cp || v:version < 703
  finish
endif

let g:vim_number_fold_loaded=1

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

" " Automatically switch to absolute numbers when focus is lost and
" switch back
" " when the focus is regained.
autocmd FocusLost * :call UpdateNumberByFocus(0)
autocmd FocusGained * :call UpdateNumberByFocus(1)
autocmd WinLeave * :call UpdateNumberByFocus(0)
autocmd WinEnter * :call UpdateNumberByFocus(1)
"
" " Switch to absolute line numbers when entering insert mode and switch
" back to
" " relative line numbers when switching back to normal mode.
autocmd InsertEnter * :call UpdateNumberByMode(1)
autocmd InsertLeave * :call UpdateNumberByMode(0)
