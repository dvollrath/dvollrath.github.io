cd ~/Dropbox/Work
use FRED-Annual-2018-Oct-16.dta, clear

gen ln_gdp_pc = ln(gdp_pc)

keep if inrange(year,1948,2020) // only use post-war data

reg ln_gdp_pc year if inrange(year,1948,1983) // exponential growth
predict fit_ln_gdp_pc, xb // get fitted path
gen fit_exp_gdp_pc = exp(fit_ln_gdp_pc) // put fitted log values into levels

reg gdp_pc year if inrange(year,1948,1983) // additive growth
predict fit_add_gdp_pc, xb // fitted path

label variable gdp_pc "GDP per capita"
label variable fit_exp_gdp_pc "Model G"
label variable fit_add_gdp_pc "Model D"

line gdp_pc year, lcolor(black) ///
	|| line fit_add_gdp_pc year, lpattern(dash) lcolor(orange) ///
	|| line fit_exp_gdp_pc year, lpattern(shortdash) lcolor(blue) ///
	xlabel(1950(10)2010 2016) ylabel(,nogrid) ///
	xtitle("Year") ytitle("GDP per capita") ///
	graphregion(color(white)) ///
	legend(col(3))
graph export "~/Dropbox/GrowthBlog/dvollrath.github.io/assets/philcomparison.jpg", as(jpg) replace
	
