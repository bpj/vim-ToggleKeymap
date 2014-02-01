" ToggleKeymap.vim
"
" Hacky plugin to set 'keymap' switching mappings
"
" The nifty thing is that you can define a mapping to switch to
" the previous 'keymap' and back again!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   SetKeymap
"
" The main action: stash the old value of 'keymap' and set the new value

fun! s:SetKeymap(mapname)
    let b:prevkeymap = &l:keymap
    exe 'setl keymap='.a:mapname
    redraw | echom "Keymap '".b:prevkeymap."' -> '".&l:keymap."'"
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   ToggleKeymap
"
" Calls SetKeymap() with the stashed previous 'keymap' value as
" argument.
"
" If there is no stashed value it sets the stash variable to an empty
" string first!

fun! s:ToggleKeymap()
    if empty(b:prevkeymap)
        let b:prevkeymap = ""
    endif
    call <SID>SetKeymap(b:prevkeymap)
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   MapToggleKeymap
"
" Generate :nnor and :inor mappings to call ToggleKeymap()

fun! MapToggleKeymap(key)
    exe ':nnor '.a:key.' :call <SID>ToggleKeymap()<CR>'
    exe ':inor '.a:key.' :call <C-O><SID>ToggleKeymap()<CR>'
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   MapSetKeymap
"
" Generate :nnor and :inor mappings to call SetKeymap()
"
" If g:stashmapkeymap is set to a true value it will also
" stash the `key : name` pair in g:mapkeymap.

fun! s:MapSetKeymap(key, name)
    if exists("g:stashmapkeymap") && g:stashmapkeymap
        if exists("g:mapkeymap")
            if type(g:mapkeymap) != 4   " If it is not a dict
                :echoerr "MapSetKeymap error: variable g:mapkeymap exists but is not a Dictionary"
            else
                let g:mapkeymap[a:key] = a:name
            endif
        else
            let g:mapkeymap = { a:key : a:name }
        endif
    endif
    if !exists("g:keymapprefix")
        let g:keymapprefix = ""
    endif
    exe ':nnor '.g:keymapprefix.a:key.' :call <SID>SetKeymap("'.a:name.'")<CR>'
    exe ':inor '.g:keymapprefix.a:key.' <C-O>:call <SID>SetKeymap("'.a:name.'")<CR>'
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   MapSetKeymapFromDict
"
" This one calls MapSetKeymap() for every `key : value` pair in
" its argument, which must be a dictionary.

fun! MapSetKeymapFromDict(dict)
    if type(a:dict) != 4   " If it is not a dict
        :echoerr "MapSetKeymapFromDict error: argument is not a Dictionary"
    else
        for [key, name] in items(a:dict)
            call <SID>MapSetKeymap(g:keymapprefix.key, name)
        endfor
    endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Commands with a corresponding function
" 

com! -nargs=1 SetKeymap        :call <SID>SetKeymap(<f-args>)
com! -nargs=0 ToggleKeymap     :call <SID>ToggleKeymap()
com! -nargs=1 MapToggleKeymap  :call <SID>MapToggleKeymap(<f-args>)
com! -nargs=+ MapSetKeymap     :call <SID>MapSetKeymap(<f-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Commands without a corresponding function
"
" These exist because you can't call a command with an empty string
" argument!

com! -nargs=0 NoKeymap     :call <SID>SetKeymap("")
com! -nargs=1 MapNoKeymap  :call <SID>MapSetKeymap(<f-args>, "")

