if !empty(glob(".git"))
  let s:modifiedFilesCommand  = "git status --untracked --porcelain | grep -v '^ D ' | awk '{print ( $(NF) )}'"
  let s:lsFilesCommand = "git ls-files --cached --modified \| sort \| uniq"
  let s:filesChangedOnCurrentBranch  = "git diff --name-only --diff-filter AM master... "

  function! s:search(command, pattern)
    if !exists('g:loaded_haystack')
      return ["vim-haystack must be installed to do fuzzy matching"]
    endif

    let files = split(system(a:command), "\n")

    if len(a:pattern) > 0
      return haystack#filter(files, a:pattern)
    end

    return files
  endfunction

  function! GitFilesChangedOnCurrentBranch(A,L,P)
    let pattern = a:A
    return s:search(s:filesChangedOnCurrentBranch, pattern)
  endfunction
  command! -complete=customlist,GitFilesChangedOnCurrentBranch -nargs=1 B :edit <args>

  function! GitLsFiles(A,L,P)
    let pattern = a:A
    return s:search(s:lsFilesCommand, pattern)
  endfunction
  command! -complete=customlist,GitLsFiles -nargs=1 Z :edit <args>

  function! GitNextModifiedFile()
    let files = s:search(s:modifiedFilesCommand, '')
    let currentIndex = index(files, @%)

    if currentIndex == -1
      return
    endif

    let index = currentIndex + 1

    if index == len(files)
      echo "there is no next file"
      return
    endif

    execute "edit " . get(files, index)
  endfunction
  :nnoremap <silent> ]g :call GitNextModifiedFile()<cr>

  function! GitPreviousModifiedFile()
    let files = s:search(s:modifiedFilesCommand, '')
    let currentIndex = index(files, @%)

    if currentIndex == -1
      return
    endif

    let index = currentIndex - 1

    if index == -1
      echo "there is no previous file"
      return
    endif

    execute "edit " . get(files, index)
  endfunction
  :nnoremap <silent> [g :call GitPreviousModifiedFile()<cr>

  function! GitLsFilesModified(A,L,P)
    let pattern = a:A
    return s:search(s:modifiedFilesCommand, pattern)
  endfunction
  command! -complete=customlist,GitLsFilesModified -nargs=1 G :edit <args>
endif

" vim: nowrap sw=2 sts=2 ts=8 noet:
