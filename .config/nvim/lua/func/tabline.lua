vim.cmd([[
set showtabline=2
set tabline=%!TabLineNumbered()

function! TabLineNumbered()
  let s = ''
  let wn = ''
  let t = tabpagenr()
  let i = 1
  while i <= tabpagenr('$')
    let buflist = tabpagebuflist(i)
    let buf = buflist[tabpagewinnr(i) - 1]
    let file = fnamemodify(bufname(buf), ':t')
    if i == t
      let s .= '%' . i . 'T'
      let s .= '%#TabLineSel#'
      let wn .= '%' . i . 'T'
      let wn .= '%#TabLineSel#'
    else
      let s .= '%' . i . 'T'
      let s .= '%#TabLine#'
      let wn .= '%' . i . 'T'
      let wn .= '%#TabLine#'
    endif

    let s .= ' ' . i . ' '
    let wn .= ' ' . i . ' '

    " Truncate the file name if it's too long
    if len(file) > 20
      let file = strpart(file, 0, 20) . '..'
    endif
    let s .= file . ' '
    let wn .= file . ' '
    let s .= '%T'
    let wn .= '%T'
    let s .= '%#TabLine#|'
    let wn .= '%#TabLine#|'
    let i += 1
  endwhile
  return s
endfunction
]])
