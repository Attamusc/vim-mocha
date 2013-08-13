let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:mocha_command")
  let s:cmd = "mocha {spec}"

  if has("gui_running") && has("gui_macvim")
    let g:mocha_command = "silent !" . s:plugin_path . "/bin/send_to_term '" . s:cmd . "'"
  else
    let g:mocha_command = "!echo " . s:cmd . " && " . s:cmd
  endif
endif

function! mocha#RunAllSpecs()
  if isdirectory('spec')
    let l:spec = "spec"
  else
    let l:spec = "test"
  endif

  call mocha#SetLastSpecCommand(l:spec)
  call mocha#RunSpecs(l:spec)
endfunction

function! mocha#RunCurrentSpecFile()
  if mocha#InSpecFile()
    let l:spec = @%
    call mocha#SetLastSpecCommand(l:spec)
    call mocha#RunSpecs(l:spec)
  else
    call mocha#RunLastSpec()
  endif
endfunction

function! mocha#RunLastSpec()
  if exists("s:last_spec_command")
    call mocha#RunSpecs(s:last_spec_command)
  endif
endfunction

function! mocha#InSpecFile()
  return match(expand("%"), "^test/") != -1 || match(expand("%"), "^spec/") != -1
endfunction

function! mocha#SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! mocha#RunSpecs(spec)
  write
  execute substitute(g:mocha_command, "{spec}", a:spec, "g")
endfunction
