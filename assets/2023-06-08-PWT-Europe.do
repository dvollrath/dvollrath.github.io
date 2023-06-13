/*
KLEMS growth accounting for Europe
*/

cd "~/dropbox/GrowthBlog/dvollrath.github.io/assets"

import delimited "./data/PWT_calcs_Europe.csv", clear

destring y ky ln lw wn avh hc, force replace

egen id = group(isocode)
xtset id year

foreach v in y ky ln lw wn avh hc {
	gen g`v'5 = (ln(`v') - ln(L5.`v'))/5
}
gen ga5 = gy5 - (.3/.7)*gky5 - gln5 - gavh5 - ghc5
gen difflw5 = lw - L5.lw

binscatter ga5 glw5 if isocode~="USA" & year>1960, nq(50) reportreg ///
	xtitle("Growth rate of working age pop as share of total") ytitle("Growth rate of productivity") ///
	xlabel(-.04(.01).04) ///
	text(.017 -.03 "1980s Spain")
graph export "./figures/2023-06-13-PWT-Europe-glw5.pdf", replace as(pdf)	
	
	
binscatter ga5 difflw5 if isocode~="USA" & year>1960, nq(50) ///
	xtitle("Difference in working age pop as share of total") ytitle("Growth rate of productivity") 
graph export "./figures/2023-06-13-PWT-Europe-difflw5.pdf", replace as(pdf)		

reg ga5 glw5 if isocode=="DEU" & year>1960
reg ga5 glw5 if isocode=="FRA" & year>1960
reg ga5 glw5 if isocode=="GBR" & year>1960
reg ga5 glw5 if isocode=="NLD" & year>1960
reg ga5 glw5 if isocode=="ITA" & year>1960
reg ga5 glw5 if isocode=="ESP" & year>1960

binscatter glw5 year if isocode~="USA" & year>1960, discrete ///
	xtitle("Year") ytitle("Difference in labor force participation") ///
	xlabel(1960(5)2020)
graph export "./figures/2023-06-13-PWT-Europe-trend.pdf", replace as(pdf)		

scatter ga5 glw5 if isocode=="USA" & year>1960 || lfit ga5 glw5 if isocode=="USA" & year>1960, legend(off) ///
	xtitle("Growth rate of working age pop as share of total") ytitle("Growth rate of productivity") ///
	title("US Only")
graph export "./figures/2023-06-13-PWT-US-glw5.pdf", replace as(pdf)			
