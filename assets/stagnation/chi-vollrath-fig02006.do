 twoway (bar Dgdppc year if countrycode=="USA", xtitle("Year") ytitle("Growth in real GDP per capita (relative to US in 2000)") ylabel(,angle(0) format(%7.0f) nogrid) xlabel(1950(10)2010 2014, angle(45)) ) (bar Dgdppc year if countrycode=="CHN", lwidth(narrow) legend(label(1 "United States") label(2 "China")) ) 