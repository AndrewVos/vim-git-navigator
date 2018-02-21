if !empty(glob(".git"))
  let s:modifiedFilesCommand  = "git status --untracked --porcelain | grep -v '^ D ' | awk '{print ( $(NF) )}'"
  let s:lsFilesCommand = "git ls-files --cached --modified \| sort \| uniq"
  let s:filesChangedOnCurrentBranch  = "git diff --name-only --diff-filter AM master... "

  function! s:grepCommand(pattern, command)
    if len(a:pattern) > 0
      return split(system(a:command . "\| grep --ignore-case " . a:pattern), "\n")
    else
      return split(system(a:command), "\n")
    endif
  endfunction

  function! GitFilesChangedOnCurrentBranch(A,L,P)
    let pattern = a:A
    return s:grepCommand(pattern, s:filesChangedOnCurrentBranch)
  endfunction
  command! -complete=customlist,GitFilesChangedOnCurrentBranch -nargs=1 B :edit <args>

  function! GitLsFiles(A,L,P)
    let pattern = a:A
    return s:grepCommand(pattern, s:lsFilesCommand)
  endfunction
  command! -complete=customlist,GitLsFiles -nargs=1 Z :edit <args>

  function! GitGotoModifiedFile(previousOrNext)
    let files = s:grepCommand('', s:modifiedFilesCommand)
    let index = index(files, @%)

    if index == -1
      return
    endif

    if a:previousOrNext == "previous"
      let index = index - 1
    elseif a:previousOrNext == "next"
      let index = index + 1
    endif

    if index == -1
      echo "there is no previous file"
      return
    elseif index == len(files)
      echo "there is no next file"
      return
    endif

    execute "edit " . get(files, index)
  endfunction

  function! GitNextModifiedFile()
    call GitGotoModifiedFile("next")
  endfunction
  :nnoremap <silent> ]g :call GitNextModifiedFile()<cr>

  function! GitPreviousModifiedFile()
    call GitGotoModifiedFile("previous")
  endfunction
  :nnoremap <silent> [g :call GitPreviousModifiedFile()<cr>

  function! GitLsFilesModified(A,L,P)
    let pattern = a:A
    return s:grepCommand(pattern, s:modifiedFilesCommand)
  endfunction
  command! -complete=customlist,GitLsFilesModified -nargs=1 G :edit <args>
endif

" vim: nowrap sw=2 sts=2 ts=8 noet:
