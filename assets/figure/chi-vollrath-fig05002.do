 twoway scatter value str_age if time==1960, connect(line) lwidth(medthick) || scatter value str_age if time==1990, connect(line) lpattern(dash) lwidth(medthick) || scatter value str_age if time==2020, connect(line) lwidth(medthick) xtitle("Minimum age in bin") ytitle("Millions of people") xlabel(0(5)85) legend(label(1 "1960") label(2 "1990") label(3 "2020")) scheme(vollrath) 