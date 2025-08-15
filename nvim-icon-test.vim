" Test file to check icon display in Neovim
" Run with: nvim -u nvim-icon-test.vim

set encoding=utf-8
set termguicolors

" Create a new buffer with icon tests
enew
put ='=== Icon Display Test in Neovim ==='
put =''
put ='Error icon:       '
put ='Warning icon:     '
put ='Info icon:        '
put ='Hint icon:        '
put ='Folder closed:    '
put ='Folder open:      '
put ='Git branch:       '
put =''
put ='Box drawing: ├── └── │'
put =''
put ='If you see boxes above, icons are not working.'
put ='If you see actual icons, they are working!'

" Move cursor to top
normal gg