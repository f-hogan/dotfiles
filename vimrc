" =======================================================================
" .vimrc for Amal
" This was heavily inspired by https://github.com/junegunn/dotfiles/blob/master/vimrc
" =======================================================================


call plug#begin('~/.vim/plugged')
" Auto completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


" Automatic quote and bracket completion
Plug 'jiangmiao/auto-pairs'

" Comment
Plug 'scrooloose/nerdcommenter'

" Code auto-formating
Plug 'Chiel92/vim-autoformat'

" Only used for go-to definition
Plug 'davidhalter/jedi-vim'

" NerdTree
Plug 'scrooloose/nerdtree'
augroup nerd_loader
	autocmd!
	autocmd VimEnter * silent! autocmd! FileExplorer
	autocmd BufEnter,BufNew *
				\  if isdirectory(expand('<amatch>'))
				\|   call plug#load('nerdtree')
				\|   execute 'autocmd! nerd_loader'
				\| endif
augroup END

" Syntax checker/Lint
Plug 'dense-analysis/ale'

" Multi-cursor edit
" Plug 'terryma/vim-multiple-cursors'

" Folding
Plug 'tmhedberg/SimpylFold'

" Color
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'altercation/solarized'

" Git integration
Plug 'tpope/vim-fugitive'

  nmap <Leader>g :Gstatus<CR>gg<c-n>
  nnoremap <Leader>d :Gdiff<CR>
" browse git commits
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-signify'

" Snippets
"Plug 'sirver/ultisnips'

" Fuzzy search
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

call plug#end()


" ========================================================================
" Basic Settings
" ========================================================================

let mapleader      = ' '
let maplocalleader = ' '

if has('gui_running')
	set background=light
else
	set background=dark
endif
colorscheme gruvbox

set nu
set autoindent
set cindent
set shiftwidth=2
set expandtab
set clipboard=unnamedplus
set $
UpdateRemoteP
lugins


" Mouse
set mouse=a

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
	set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline

" =======================================================================
" Basic Mappings
" =======================================================================
" Open new line below and above current line
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" Save
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>w :update<cr>

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" Last inserted text
nnoremap g. :normal! `[v`]<cr><left>

" Zoom
function! s:zoom()
	if winnr('$') > 1
		tab split
	elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
				\ 'index(v:val, '.bufnr('').') >= 0')) > 1
		tabclose
	endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>

" ----------------------------------------------------------------------------
" nvim
" ----------------------------------------------------------------------------
if has('nvim')
	tnoremap <a-a> <esc>a
	tnoremap <a-b> <esc>b
	tnoremap <a-d> <esc>d
	tnoremap <a-f> <esc>f
endif

" ----------------------------------------------------------------------------
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" ----------------------------------------------------------------------------
" tmux
" ----------------------------------------------------------------------------
function! s:tmux_send(content, dest) range
	let dest = empty(a:dest) ? input('To which pane? ') : a:dest
	let tempfile = tempname()
	call writefile(split(a:content, "\n", 1), tempfile, 'b')
	call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
				\ shellescape(tempfile), shellescape(dest)))
	call delete(tempfile)
endfunction

function! s:tmux_map(key, dest)
	execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
	execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction

call s:tmux_map('<leader>tt', '')
call s:tmux_map('<leader>th', '.left')
call s:tmux_map('<leader>tj', '.bottom')
call s:tmux_map('<leader>tk', '.top')
call s:tmux_map('<leader>tl', '.right')
call s:tmux_map('<leader>ty', '.top-left')
call s:tmux_map('<leader>to', '.top-right')
call s:tmux_map('<leader>tn', '.bottom-left')
call s:tmux_map('<leader>t.', '.bottom-right')



" ========================================================================
" Deoplete
" ========================================================================
let g:deoplete#enable_at_startup = 1
" close preview window automatically
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" navigate auto-completion using tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" ========================================================================
" Airline
" ========================================================================
let g:airline_theme='onedark'
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
let g:Powerline_sybols = 'unicode'
" unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type= 2
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buffers_label = 'BUFFERS'
let g:airline#extensions#tabline#tabs_label = 'TABS'
let g:airline#extensions#ale#enabled = 1


" ========================================================================
" Vim auto-format
" ========================================================================
" noremap <F3> :Autoformat<CR>
" au BufWrite * :Autoformat
noremap <F2> :RemoveTrailingSpaces

" ========================================================================
" jedi-vim
" ========================================================================
" disable autocompletion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"

" ========================================================================
" Nerd Tree
" ========================================================================
nnoremap <leader>t :NERDTreeToggle<cr>


" ----------------------------------------------------------------------------
" ALE
" ----------------------------------------------------------------------------
let g:ale_linters = {'python': ['pylint', 'flake8']}
let g:ale_fixers = {'python': ['autopep8'], '*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0
let g:ale_lint_delay = 750
let g:airline#extensions#ale#enabled = 1
highlight link ALEErrorSign GruvboxRedSign
highlight link ALEWarningSign GruvboxYellowSign

" Navigation between error messages
nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)
nmap ]d <Plug>(ale_go_to_definition)



" -----------------------------------------------------------------------------
"  Markdown
"  ----------------------------------------------------------------------------

nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

"------------------------------------------------------------------------------
" Markdown Preview
" -----------------------------------------------------------------------------

let g:mkdp_refresh_slow=1
let g:mkdp_markdown_css="/home/amalferiani/afdotfiles/github-markdown.css"


" -----------------------------------------------------------------------------
"  Run script
"  ----------------------------------------------------------------------------
"
function! s:run_this_script(output)
  let head   = getline(1)
  let pos    = stridx(head, '#!')
  let file   = expand('%:p')
  let ofile  = tempname()
  let rdr    = " 2>&1 | tee ".ofile
  let win    = winnr()
  let prefix = a:output ? 'silent !' : '!'
  " Shebang found
  if pos != -1
    execute prefix.strpart(head, pos + 2).' '.file.rdr
  " Shebang not found but executable
  elseif executable(file)
    execute prefix.file.rdr
  elseif &filetype == 'python'
    " execute prefix.'/usr/bin/python3 '.file.rdr
    execute '!python % '.file.rdr
  elseif &filetype == 'tex'
    execute prefix.'latex '.file. '; [ $? -eq 0 ] && xdvi '. expand('%:r').rdr
  elseif &filetype == 'dot'
    let svg = expand('%:r') . '.svg'
    let png = expand('%:r') . '.png'
    " librsvg >> imagemagick + ghostscript
    execute 'silent !dot -Tsvg '.file.' -o '.svg.' && '
          \ 'rsvg-convert -z 2 '.svg.' > '.png.' && open '.png.rdr
  else
    return
  end
  redraw!
  if !a:output | return | endif

  " Scratch buffer
  if exists('s:vim_exec_buf') && bufexists(s:vim_exec_buf)
    execute bufwinnr(s:vim_exec_buf).'wincmd w'
    %d
  else
    silent!  bdelete [vim-exec-output]
    silent!  vertical botright split new
    silent!  file [vim-exec-output]
    setlocal buftype=nofile bufhidden=wipe noswapfile
    let      s:vim_exec_buf = winnr()
  endif
  execute 'silent! read' ofile
  normal! gg"_dd
  execute win.'wincmd w'
endfunction

nnoremap <silent> <F5> :call <SID>run_this_script(0)<cr>
nnoremap <silent> <F6> :call <SID>run_this_script(1)<cr>


" }}}
" ============================================================================
" FZF {{{
" ============================================================================

if has('nvim') || has('gui_running')
	let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif


" All files
command! -nargs=? -complete=dir AF
			\ call fzf#run(fzf#wrap(fzf#vim#with_preview({
			\   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
			\ })))

let g:fzf_colors =
			\ { 'fg':      ['fg', 'Normal'],
			\ 'bg':      ['bg', 'Normal'],
			\ 'hl':      ['fg', 'Comment'],
			\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
			\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
			\ 'hl+':     ['fg', 'Statement'],
			\ 'info':    ['fg', 'PreProc'],
			\ 'border':  ['fg', 'Ignore'],
			\ 'prompt':  ['fg', 'Conditional'],
			\ 'pointer': ['fg', 'Exception'],
			\ 'marker':  ['fg', 'Keyword'],
			\ 'spinner': ['fg', 'Label'],
			\ 'header':  ['fg', 'Comment'] }

" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

if has('nvim') && exists('&winblend') && &termguicolors
	set winblend=10

	hi NormalFloat guibg=None
	if exists('g:fzf_colors.bg')
		call remove(g:fzf_colors, 'bg')
	endif

	if stridx($FZF_DEFAULT_OPTS, '--border') == -1
		let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'
	endif

	function! FloatingFZF()
		let width = float2nr(&columns * 0.9)
		let height = float2nr(&lines * 0.6)
		let opts = { 'relative': 'editor',
					\ 'row': (&lines - height) / 2,
					\ 'col': (&columns - width) / 2,
					\ 'width': width,
					\ 'height': height }

		call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
	endfunction

	let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>L        :Lines<CR>
command! -bang -nargs=* Ag
			\ call fzf#vim#ag(<q-args>,
			\                 <bang>0 ? fzf#vim#with_preview('up:60%')
			\                         : fzf#vim#with_preview('right:50%:hidden', '?'),
			\                 <bang>0)
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
nnoremap <silent> <Leader>`        :Marks<CR>
" nnoremap <silent> q: :History:<CR>
" nnoremap <silent> q/ :History/<CR>

inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

function! s:plug_help_sink(line)
	let dir = g:plugs[a:line].dir
	for pat in ['doc/*.txt', 'README.md']
		let match = get(split(globpath(dir, pat), "\n"), 0, '')
		if len(match)
			execute 'tabedit' match
			return
		endif
	endfor
	tabnew
	execute 'Explore' dir
endfunction

command! PlugHelp call fzf#run(fzf#wrap({
			\ 'source': sort(keys(g:plugs)),
			\ 'sink':   function('s:plug_help_sink')}))

" }}}
