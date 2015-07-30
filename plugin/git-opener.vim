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
  function! GitChangedFiles()
    let gitCommand = "git status --untracked --porcelain | awk '{print ( $(NF) )}'"
    return split(system(gitCommand), "\n")
  endfunction

  function! GitGotoModifiedFile(previousOrNext)
    let files = GitChangedFiles()
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
    let files = GitChangedFiles()
    if len(pattern) > 0
      let matched = []
      for file in files
        if file =~ pattern
          call add(matched, file)
        endif
      endfor
      return matched
    end
    return files
  endfunction
  command! -complete=customlist,GitLsFilesModified -nargs=1 G :edit <args>
endif

" vim: nowrap sw=2 sts=2 ts=8 noet:
