"vim-general {
    "开启文件类型侦测
    filetype on
    "根据侦测到的不同类型加载对应的插件
    filetype plugin on
    "去掉vi的一致性
    set nocompatible
    "显示行号
    set number
    "隐藏滚动条
    set guioptions-=r
    set guioptions-=L
    set guioptions-=b
    "隐藏顶部标签栏
    set showtabline=0
    "设置字体
    set guifont=Source\ Code\ Pro\ for\ Powerline:h15
    "开启语法高亮功能
    syntax enable
    "允许用指定语法高亮配色方案替换默认方案
    syntax on
    "solarized主题设置在终端下的设置
    "let g:solarized_termcolors=256
    "设置背景色
    set background=dark
    colorscheme Spacedust
    "设置不折行
    set nowrap
    "设置以unix的格式保存文件
    set fileformat=unix
    "设置C样式的缩进格式
    set cindent
    "显示匹配的括号
    set showmatch
    "距离顶部和底部5行
    set scrolloff=5
    "命令行为两行
    set laststatus=2
    "文件编码
    set fenc=utf-8
    set backspace=2
    "启用鼠标
    set mouse=a
    set selection=exclusive
    set selectmode=mouse,key
    set matchtime=5
    "忽略大小写
    set ignorecase
    set incsearch
    "高亮搜索项"
    set hlsearch
    "不允许扩展table
    "set noexpandtab
    set expandtab
    "自动缩进尺寸为 4 个空格
    set sw=4
    "Tab 宽度为 4 个字符
    set ts=4
    "编辑时将所有 Tab 替换为空格
    set et
    "delete 可以删除 4 个空格
    set smarttab
    set whichwrap+=<,>,h,l
    set autoread
    "突出显示当前行
    set cursorline
    "突出显示当前列"
    set cursorcolumn
    " 定义快捷键的前缀，即<Leader>
    let mapleader=";"
"}

"vim-Vundle {
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'L9'
    Plugin 'dyng/ctrlsf.vim' "全局搜索
    Plugin 'ctrlpvim/ctrlp.vim' "文件内搜索
    Plugin 'tpope/vim-surround'
    Plugin 'Yggdroot/indentLine'
    Plugin 'Raimondi/delimitMate'
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'majutsushi/tagbar'
    Plugin 'scrooloose/nerdtree'
    Plugin 'tpope/vim-fugitive'
    Plugin 'mattn/emmet-vim'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'scrooloose/syntastic'
    Plugin 'vim-airline/vim-airline'
    Plugin 'easymotion/vim-easymotion'
    Plugin 'terryma/vim-multiple-cursors'
    Plugin 'vim-airline/vim-airline-themes'
    call vundle#end()
    filetype plugin indent on
"}

"vim-YouCompleteMe {
    "=====================
    "dependencies:
    "brew install CMake
    "=====================
    "默认配置文件路径
    let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
    "打开vim时不再询问是否加载ycm_extra_conf.py配置"
    let g:ycm_confirm_extra_conf=0

    set completeopt=longest,menu
    "python解释器路径"
    let g:ycm_path_to_python_interpreter='/usr/local/Cellar/python/2.7.12_1/bin/python2.7'
    "let g:ycm_path_to_python_interpreter='/usr/bin/python'
    "是否开启语义补全"
    let g:ycm_seed_identifiers_with_syntax=1
    "是否在注释中也开启补全"
    let g:ycm_complete_in_comments=1
    let g:ycm_collect_identifiers_from_comments_and_strings = 0
    "开始补全的字符数"
    let g:ycm_min_num_of_chars_for_completion=2
    "补全后自动关机预览窗口"
    let g:ycm_autoclose_preview_window_after_completion=1
    " 禁止缓存匹配项,每次都重新生成匹配项"
    let g:ycm_cache_omnifunc=0
    "字符串中也开启补全"
    let g:ycm_complete_in_strings = 1
    "离开插入模式后自动关闭预览窗口"
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif
    "回车即选中当前项"
    inoremap <expr> <CR>       pumvisible() ? '<C-y>' : '<CR>'
"}

" vim-Airline {
    "=====================
    "dependencies:
    "Powerline-Fonts URL:https://github.com/powerline/fonts
    "Menlo for Powerline URL:https://github.com/abertsch/Menlo-for-Powerline
    "=====================
    "Set configuration options for the statusline plugin vim-airline.
    "Use the powerline theme and optionally enable powerline symbols.
    "To use the symbols , , , , , , and .in the statusline
    "segments add the following to your .vimrc.before.local file:
    let g:airline_powerline_fonts=1
    "If the previous symbols do not render for you then install a
    "powerline enabled font.
    let g:airline_theme = 'qwq'
    "let g:airline_theme = 'papercolor'
    "See `:echo g:airline_theme_map` for some more choices
    "Default in terminal vim is 'dark'
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
"}

"tagbar {
    "=====================
    "dependencies:
    "brew install ctags
    "=====================
    nmap <F8> :TagbarToggle<CR>
"}

"vim-indentLine {
    let g:indentLine_char='┆'
    let g:indentLine_enabled=1
"}

"vim-easymotion {
    "=====================
    "vim 熟练后安装下面插件提高效率
    "https://github.com/haya14busa/vim-easyoperator-line
    "https://github.com/haya14busa/vim-easyoperator-phrase
    "=====================
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
"}

"vim-mappings {
    "Ctrl+Shift+上下移动当前行
    nnoremap <silent><C-j> :m .+1<CR>==
    nnoremap <silent><C-k> :m .-2<CR>==
    inoremap <silent><C-j> <Esc>:m .+1<CR>==gi
    inoremap <silent><C-k> <Esc>:m .-2<CR>==gi
    "上下移动选中的行
    vnoremap <silent><C-j> :m '>+1<CR>gv=gv
    vnoremap <silent><C-k> :m '<-2<CR>gv=gv
    " Use tab for indenting in visual mode
    xnoremap <Tab> >gv|
    xnoremap <S-Tab> <gv
    nnoremap > >>_
    nnoremap < <<_
"}

"vim-emment {
    "===============
    "emment usage
    "https://raw.githubusercontent.com/mattn/emmet-vim/master/TUTORIAL
    "===============
"}

"vim-CtrlP {
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip
    let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll|jpg|png|jpeg)$',
      \ }
"}

"vim-syntastic {
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    "set error or warning signs
    let g:syntastic_error_symbol = '✗'
    let g:syntastic_warning_symbol = '⚠'

    let g:syntastic_enable_highlighting = 0
    "let g:syntastic_python_checker='flake8,pyflakes,pep8,pylint'
    "let g:syntastic_python_checkers=['pyflakes']
    let g:syntastic_css_checker='csslint'
    let g:syntastic_css_checkers= ['csslint']
    let g:syntastic_javascript_checker='jshint,jslint'
    "jslint 作为候选
    let g:syntastic_javascript_checkers = ['jshint','jslint']
    "highlight SyntasticErrorSign guifg=white guibg=black
    let g:syntastic_cpp_include_dirs = ['/usr/include/']
    let g:syntastic_cpp_remove_include_errors = 1
    let g:syntastic_cpp_check_header = 1
    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
    let g:syntastic_enable_balloons = 1	"whether to show balloons

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0

    let g:syntastic_debug = 1

"}

"vim-multiple-cursor {
    let g:multi_cursor_use_default_mapping=0
    " Default mapping
    let g:multi_cursor_next_key='<C-m>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'
"}


"NERDTree {
    "NERDTree 子窗口中不显示冗余帮助信息
    let NERDTreeMinimalUI=1
    "打开新的buffer时自动定位到编辑窗口
    autocmd VimEnter * wincmd p
    "replace icon
    let g:NERDTreeDirArrowExpandable = '▶'
    let g:NERDTreeDirArrowCollapsible = '▼'
    "F2 toggle NERDTree
    map <F2> :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&b:NERDTreeType == "primary") | q | endif
"}

"vim-fugitive {
    "enable/disable fugitive/lawrencium integration
    let g:airline#extensions#branch#enabled = 1
    "truncate long branch names to a fixed length
    let g:airline#extensions#branch#displayed_head_limit = 10
    "to only show the tail, e.g. a branch 'feature/foo' becomes 'foo', use
    "let g:airline#extensions#branch#format = 1
    "enable/disable syntastic integration
    let g:airline#extensions#syntastic#enabled = 1
"}

"vim-function {
    "Automatically removing all trailing whitespace
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
"}

