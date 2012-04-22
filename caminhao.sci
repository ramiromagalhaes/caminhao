function err = eval_err(val, expected)
    err = abs((val - expected)/expected)
endfunction