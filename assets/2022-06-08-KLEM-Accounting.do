/*
KLEMS growth accounting for Europe
*/

cd "~/dropbox/GrowthBlog/dvollrath.github.io/assets"

use "./data/KLEMSnational19952020.dta", clear


destring year, replace
drop if year==2020 // duh

keep if inlist(geo_code,"US","FR","UK","ES","NL","IT","DE")

rename geo_code country
rename nace_r2_code code

gen keep_industry = 0
replace keep_industry=1 if inlist(code,"A","B","C","D","E","F","G")
replace keep_industry=1 if inlist(code,"H","I","J","K")
replace keep_industry=1 if inlist(code,"M","N","O","P","Q","R","S")
replace keep_industry=1 if code=="L"

/*
replace keep_industry=1 if inlist(code,"A","B","D","E","F","I","K","L")
replace keep_industry=1 if inlist(code,"M","N","O","P","R","S","T")
replace keep_industry=1 if inlist(code,"C10-C12","C13-C15","C16-C18","C19","C20","C21","C22-C23","C24-C25")
replace keep_industry=1 if inlist(code,"C26","C27","C28","C29-C30","C31-C33","G45","G46","G47")
replace keep_industry=1 if inlist(code,"H49","H50","H51","H52","H53","J58-J60","J61","J62-J63")
replace keep_industry=1 if inlist(code,"L68A","Q86","Q87-Q88")
*/

keep if keep_industry==1
drop keep_industry

rename VA_Q valueVA_Q
rename VA_PI valueVA_PI
rename EMP valueEMP
rename VA_CP valueVA_CP

//reshape wide value, i(country year code) j(var) string

egen code_id = group(code)
egen country_id = group(country)

gen valueLP_Q = valueVA_Q/valueEMP
gen ln_value_LP_Q = ln(valueLP_Q)

bysort country year: egen valueVA_Q_total = sum(valueVA_Q)
bysort country year: egen valueEMP_total = sum(valueEMP)
bysort country year: egen valueVA_total = sum(valueVA_CP)

gen valueEMP_share = valueEMP/valueEMP_total
gen valueVA_share = valueVA_CP/valueVA_total

bysort country year: egen valueEMP_share_mean = mean(valueEMP_share)
bysort country year: egen valueLP_Q_mean = mean(valueLP_Q)
bysort country year: egen valueVA_share_mean = mean(valueVA_share)

egen country_code_id = group(country code)
xtset country_code_id year

gen diff_valueEMP_share = valueEMP_share - L.valueEMP_share
gen diff_valueLP_Q = ln(valueLP_Q) - ln(L.valueLP_Q)
gen diff5_valueLP_Q = ln(valueLP_Q) - ln(L5.valueLP_Q)

gen for1_valueEMP_share = F.valueEMP_share - valueEMP_share
gen for5_valueEMP_share = F5.valueEMP_share - valueEMP_share

gen diff_valueVA_PI = ln(valueVA_PI) - ln(L.valueVA_PI)
gen diff5_valueVA_PI = ln(valueVA_PI) - ln(L5.valueVA_PI)
gen for5_valueVA_PI = ln(F5.valueVA_PI) - ln(valueVA_PI)

gen diff_valueVA_Q = ln(valueVA_Q) - ln(L.valueVA_Q)
gen diff5_valueVA_Q = ln(valueVA_Q) - ln(L5.valueVA_Q)
gen for5_valueVA_Q = ln(F5.valueVA_Q) - ln(valueVA_Q)

gen diff_valueVA_share = valueVA_share - L.valueVA_share
gen for1_valueVA_share = F.valueVA_share - valueVA_share
gen for5_valueVA_share = F5.valueVA_share - valueVA_share

bysort country year: egen diff_valueLP_Q_mean = mean(diff_valueLP_Q)
gen covar_term = (valueVA_share-valueVA_share_mean)*(diff_valueLP_Q-diff_valueLP_Q_mean)
bysort country year: egen covariance = sum(covar_term)

gen diff_valueLP_Q_all = diff_valueLP_Q_mean + covariance

binscatter for5_valueVA_share diff5_valueLP_Q, nq(100)absorb(country) msymbol(O) line(none) noaddmean xline(0) yline(0) ///
	xtitle("Trailing 5-year labor prod. change") ytitle("Forward 5-year change in share of GDP") 
graph export "./figures/2022-06-08-KLEMS-Account.png", replace as(png)

label variable diff_valueLP_Q_all "Overall labor prod."
label variable diff_valueLP_Q "Industry labor prod."
binscatter diff_valueLP_Q_all diff_valueLP_Q year, discrete ///
	ytitle("Growth rate of labor productivity") xtitle("Year") ///
	legend(pos(7) ring(0) order(1 "Overall labor prod. (wtd by industry size)" 2 "Industry labor prod. (unweighted)")) ///
	mcolors(blue red) colors(blue red)
graph export "./figures/2022-06-08-KLEMS-Compare.png", replace as(png)	

reg diff_valueLP_Q_all year
predict diff_valueLP_Q_all_pred, xb 

reg diff_valueLP_Q year
predict diff_valueLP_Q_pred, xb 

summ diff_valueLP_Q_all_pred diff_valueLP_Q_pred if year==1996
summ diff_valueLP_Q_all_pred diff_valueLP_Q_pred if year==2019
