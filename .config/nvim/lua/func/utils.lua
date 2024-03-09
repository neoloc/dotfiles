vim.cmd([[
function! GetRepositoryName()
    let repo_path = system("git -C " . getcwd() . " rev-parse --show-toplevel")
    let repo_name = fnamemodify(trim(repo_path), ':t')
    let repo_name_clean = substitute(repo_name, '[\/\-\s]', '_', 'g')
    return repo_name_clean
endfunction

function! GetCurrentGitBranch()
    let l:branch = system("git -C " . getcwd() . " branch --show-current")
    let l:branch_clean = substitute(trim(l:branch), '[\/\-\s]', '_', 'g')
    return l:branch_clean
endfunction
]])
