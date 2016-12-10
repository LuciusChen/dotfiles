" vim-general {{{
" 'zi' 打开折叠
" 'zm' 关闭折叠
set fdm=marker
set nocompatible
set number
" 隐藏滚动条
set guioptions-=r
set guioptions-=L
set guioptions-=b
" 隐藏顶部标签栏
set showtabline=0
" 设置字体
set guifont=Source\ Code\ Pro\ for\ Powerline:h15
" 开启语法高亮功能
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on
" solarized主题设置在终端下的设置
let g:solarized_termcolors=256
" 设置背景色
set background=dark
colorscheme solarized
" 设置不折行
set nowrap
" 设置以unix的格式保存文件
set fileformat=unix
" 设置C样式的缩进格式
set cindent
" 显示匹配的括号
set showmatch
" 距离顶部和底部5行
set scrolloff=5
" 命令行为两行
set laststatus=2
" 文件编码
set fenc=utf-8
set backspace=2
" 启用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key
set matchtime=5
" 忽略大小写
set ignorecase
set incsearch
" 高亮搜索项"
set hlsearch
" 不允许扩展table
"set noexpandtab
" 编辑时将所有 Tab 替换为空格
set expandtab
" 自动缩进尺寸为 4 个空格
set shiftwidth=4
" Tab 宽度为 4 个字符
set tabstop=4
set smarttab
set whichwrap+=<,>,h,l
set autoread
" 突出显示当前行
set cursorline
" 突出显示当前列"
set cursorcolumn
" 定义快捷键的前缀，即<Leader>
let mapleader=";"
" }}}

" vim-Vundle {{{
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'L9'
" The tabular plugin must come before vim-markdown.
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" auxiliar markdown
Plugin 'jszakmeister/markdown2ctags'
Plugin 'suan/vim-instant-markdown'
"Plugin 'mzlogin/vim-markdown-toc'
" 全局搜索
Plugin 'dyng/ctrlsf.vim'
" 文件内搜索
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'Yggdroot/indentLine'
Plugin 'Raimondi/delimitMate'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
"Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Shougo/neocomplete.vim'
Plugin 'scrooloose/syntastic'
Plugin 'vim-airline/vim-airline'
Plugin 'easymotion/vim-easymotion'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'elzr/vim-json'
Plugin 'klen/python-mode'
Plugin 'davidhalter/jedi-vim'
call vundle#end()
filetype plugin indent on
" }}}

" jedi-vim {{{
" 解决提示不能消失，覆盖代码。
" https://github.com/davidhalter/jedi-vim/pull/412
let g:jedi#show_call_signatures = 2
" 和 python-mode 冲突
let g:jedi#rename_command = '<leader>re'
"let g:jedi#auto_initialization = 0
" }}}

" python-mode {{{
" Python-mode
" Activate rope
" Keys:
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 0

" Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

let g:pymode_python = 'python3'
" }}}

" vim-json {{{
let g:vim_json_syntax_conceal = 0
" }}}

" vim-markdown {{{
" URL: https://github.com/plasticboy/vim-markdown
" This option only controls Vim Markdown
" specific folding configuration.
let g:vim_markdown_folding_disabled = 1
" To fold in a style like python-mode
let g:vim_markdown_folding_style_pythonic = 1
" Allow for the TOC window to auto-fit
" when it's possible for it to shrink
let g:vim_markdown_toc_autofit = 1
" To disable conceal regardless of conceallevel setting
let g:vim_markdown_conceal = 0
" vim-instant-markdown {
" =====================
" dependencies:
" `npm -g install instant-markdown-d`
" =====================
" close auto preview
let g:instant_markdown_autostart = 0
nmap <F10> :InstantMarkdownPreview<CR>
" }
" }}}

" neocomplete {{{
" Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
" `brew install macvim --with-cscope --with-lua`
" `brew linkapps macvim`
" `brew install vim --with-lua`
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}

" vim-Airline {{{
" =====================
" dependencies:
" Powerline-Fonts URL:https://github.com/powerline/fonts
" Menlo for Powerline URL:https://github.com/abertsch/Menlo-for-Powerline
" =====================
" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline
" segments add the following to your .vimrc.before.local file:
let g:airline_powerline_fonts=1
" If the previous symbols do not render for you then install a
" powerline enabled font.
" qwq.vim https://github.com/LuciusChen/vim-airline-theme-qwq
let g:airline_theme = 'qwq'
" See `:echo g:airline_theme_map` for some more choices
" Default in terminal vim is 'dark'
if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
    if !exists('g:airline_theme')
        let g:airline_theme = 'solarized'
    endif
    if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
        let g:airline_left_sep='»'  " Slightly fancier than '>'
        let g:airline_right_sep='«' " Slightly fancier than '<'
    endif
endif
" the default value matches filetypes typically used for documentation
" such as markdown and help files.
" (default: markdown,rst,org,help,text)
"let g:airline#extensions#wordcount#filetypes =
" }}}

" tagbar {{{
" =====================
" dependencies:
" brew install ctags
"
" Support for additional filetypes
" https://github.com/majutsushi/tagbar/wiki
" =====================
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
" tags are sorted according to their order in the source file
let g:tagbar_sort = 0
function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    let colour = a:current ? '%#StatusLine#' : '%#StatusLineNC#'
    let flagstr = join(flags, '')
    if flagstr != ''
        let flagstr = '[' . flagstr . '] '
    endif
    return colour . '[' . sort . '] ' . flagstr . fname
endfunction
let g:tagbar_status_func = 'TagbarStatusFunc'
" markdown2ctags {
" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
            \ 'ctagstype': 'markdown',
            \ 'ctagsbin' : '~/.vim/bundle/markdown2ctags/markdown2ctags.py',
            \ 'ctagsargs' : '-f - --sort=yes',
            \ 'kinds' : [
            \ 's:sections',
            \ 'i:images'
            \ ],
            \ 'sro' : '|',
            \ 'kind2scope' : {
            \ 's' : 'section',
            \ },
            \ 'sort': 0,
            \ }
" }
" }}}

" indentLine {{{
let g:indentLine_enabled=1
let g:indentLine_char='┆'
" }}}

" vim-easymotion {{{
" =====================
" vim 熟练后安装下面插件提高效率
" https://github.com/haya14busa/vim-easyoperator-line
" https://github.com/haya14busa/vim-easyoperator-phrase
" =====================
map <Leader> <Plug>(easymotion-prefix)
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap <Leader>s <Plug>(easymotion-overwin-f2)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
" }}}

" emmet-vim {{{
" ===============
" emment usage
" https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
" ===============
" }}}

" ctrlP {{{
"let g:ctrlp_working_path_mode = 0
let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
" }}}

" syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" set error or warning signs
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'

let g:syntastic_enable_highlighting = 0
let g:syntastic_python_checker='flake8,pyflakes,pep8,pylint'
" 'pip3 install pyflakes' for python3.x
" 'pip2 install pyflakes' for python2.x
let g:syntastic_python_checkers=['pyflakes']
let g:syntastic_css_checker='csslint'
let g:syntastic_css_checkers= ['csslint']
let g:syntastic_javascript_checker='jshint,jslint'
" jslint 作为候选
let g:syntastic_javascript_checkers = ['jshint']
" highlight SyntasticErrorSign guifg=white guibg=black
let g:syntastic_cpp_include_dirs = ['/usr/include/']
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
let g:syntastic_enable_balloons = 1	" whether to show balloons

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" debug
"let g:syntastic_debug = 1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]
" }}}

" vim-multiple-cursor {{{
let g:multi_cursor_use_default_mapping=0
" Default mapping
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
" }}}

" NERDTree {{{
" NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 打开新的buffer时自动定位到编辑窗口
autocmd VimEnter * wincmd p
" replace icon
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
" F2 toggle NERDTree
map <F2> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
" }}}

" vim-fugitive {{{
" enable/disable fugitive/lawrencium integration
let g:airline#extensions#branch#enabled = 1
" truncate long branch names to a fixed length
let g:airline#extensions#branch#displayed_head_limit = 10
" to only show the tail, e.g. a branch 'feature/foo' becomes 'foo', use
"let g:airline#extensions#branch#format = 1
" enable/disable syntastic integration
let g:airline#extensions#syntastic#enabled = 1
" }}}

" nerdcommenter {{{

" ==================================
" <leader>cc 注释当前行
" <leader>cm 只用一组符号来注释
" <leader>cy 注释并复制
" <leader>cs 优美的注释
" <leader>cu 取消注释
" ==================================

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
"let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" }}}

" vim-function {{{
" Automatically removing all trailing whitespace
function! StripTrailingWhitespace()
    normal mZ
    let l:chars = col("$")
    %s/\s\+$//e
    if (line("'Z") != line(".")) || (l:chars != col("$"))
        echo "Trailing whitespace stripped\n"
    endif
    normal `Z
endfunction

autocmd BufWritePre * call StripTrailingWhitespace()

" 精准替换
" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)
    wa
    let flag = ''
    if a:confirm
        let flag .= 'gec'
    else
        let flag .= 'ge'
    endif
    let search = ''
    if a:wholeword
        let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    else
        let search .= expand('<cword>')
    endif
    let replace = escape(a:replace, '/\&~')
    execute 'argdo %s/' . search . '/' . replace . '/' . flag . '| update'
endfunction
" 不确认、非整词
nnoremap <Leader>R :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 不确认、整词
nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap <Leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、整词
nnoremap <Leader>rcw :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
nnoremap <Leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" }}}

" vim-mappings {{{
" Ctrl+Shift+上下移动当前行
nnoremap <silent><C-j> :m .+1<CR>==
nnoremap <silent><C-k> :m .-2<CR>==
inoremap <silent><C-j> <Esc>:m .+1<CR>==gi
inoremap <silent><C-k> <Esc>:m .-2<CR>==gi
" 上下移动选中的行
vnoremap <silent><C-j> :m '>+1<CR>gv=gv
vnoremap <silent><C-k> :m '<-2<CR>gv=gv
" Use tab for indenting in visual mode
xnoremap <Tab> >gv|
xnoremap <S-Tab> <gv
nnoremap > >>_
nnoremap < <<_
" press <F7> whenever you want to format
" your file(re-indent your entire file)
map <F7> mzgg=G`z
" run python2/3 code
nnoremap <F9> :echo system('python2 "' . expand('%') . '"')<cr>
nnoremap <F10> :echo system('python3 "' . expand('%') . '"')<cr>
" }}}
