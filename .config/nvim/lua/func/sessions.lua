vim.cmd([[
let g:session_dir = expand('~/.cache/nvim/sessions/')
if !isdirectory(g:session_dir)
    call mkdir(g:session_dir, "p")
endif

command! SaveSession call SaveSession()
function! SaveSession()
    let session_file = g:session_dir . GetRepositoryName() . '_' . GetCurrentGitBranch() . '.vim'
    execute 'mksession! ' . session_file
    echo "Session saved to " . session_file
endfunction

command! LoadSession call LoadSession()
function! LoadSession()
    let session_file = g:session_dir . GetRepositoryName() . '_' . GetCurrentGitBranch() . '.vim'
    if filereadable(session_file)
        execute 'source ' . session_file
        echo "Session loaded from " . session_file
    else
        echo "No session found for the current Git branch in the repository"
    endif
endfunction

nnoremap <silent> <Leader>ss :SaveSession<CR>
nnoremap <silent> <Leader>sl :LoadSession<CR>
]])
