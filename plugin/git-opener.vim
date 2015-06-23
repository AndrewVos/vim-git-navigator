
if !empty(glob(".git"))
  function! GitLsFiles(A,L,P)
    let pattern = a:A
    if len(pattern) > 0
      return split(system("git ls-files --cached --modified --others \| grep " . pattern), "\n")
    else
      return split(system("git ls-files --cached --modified --others"), "\n")
    endif
  endfunction
  command! -complete=customlist,GitLsFiles -nargs=1 Z :edit <args>
endif

if !empty(glob(".git"))
  function! GitLsFilesModified(A,L,P)
    let pattern = a:A
    let gitCommand = "git status --untracked --porcelain | awk '{print ( $(NF) )}'"
    if len(pattern) > 0
      return split(system(gitCommand . " \| grep " . pattern), "\n")
    else
      return split(system(gitCommand), "\n")
    endif
  endfunction
  command! -complete=customlist,GitLsFilesModified -nargs=1 G :edit <args>
endif

" vim: nowrap sw=2 sts=2 ts=8 noet:
