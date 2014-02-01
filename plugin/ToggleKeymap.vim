" ToggleKeymap.vim
"
" Hacky plugin to set 'keymap' switching mappings
"
" The nifty thing is that you can define a mapping to switch to
" the previous 'keymap' and back again!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Commands with a corresponding autoload function
" 

com! -nargs=1 SetKeymap        :call ToggleKeymap#SetKeymap(<f-args>)
com! -nargs=0 ToggleKeymap     :call ToggleKeymap#ToggleKeymap()
com! -nargs=1 MapToggleKeymap  :call ToggleKeymap#MapToggleKeymap(<f-args>)
com! -nargs=+ MapSetKeymap     :call ToggleKeymap#MapSetKeymap(<f-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Commands without a corresponding autoload function
"
" These exist because you can't call a command with an empty string
" argument!

com! -nargs=0 NoKeymap     :call ToggleKeymap#SetKeymap("")
com! -nargs=1 MapNoKeymap  :call ToggleKeymap#MapSetKeymap(<f-args>, "")

