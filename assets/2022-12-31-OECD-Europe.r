# Do growth accounting and prepare figures of results

#########################################################################
# Housekeeping
#########################################################################
# Necessary packages, you may have to install
library(pwt10)
library(plotly)
library(htmlwidgets)
library(dplyr)

setwd("~/dropbox/GrowthBlog/dvollrath.github.io/assets/plotly") # obv change to wherever you store things

#########################################################################
# Set parameters
#########################################################################
alpha <- 0.3 # look, there is no perfectly right answer here

#########################################################################
# Pull PWT and OECD into dataframe
#########################################################################
# there is an OECD package to read data, but it is SLOOOOOWWWWWW. 
o <- read.csv("../data/OECD_pop.csv", header=TRUE)
o <- o[which(o$LOCATION %in% c("USA","FRA","GBR","ESP","NLD","ITA","DEU")),] # select countries
o <- o[which(o$SEX %in% c("TT")),] # both sexes
o <- o[which(o$AGE %in% c("D1TTR5T2")),] # number of 20-64 year olds
o$WN <- 1/(1 + o$Value/100) # calculate 20-64 y.o (W) as percent of population (N)
o <- rename(o,c("isocode"="LOCATION")) # for merging
o <- rename(o,c("year"="Time")) # for merging

data("pwt10.0") # extracts PWT data into an object called pwt10.0
p <- pwt10.0 # copy PWT data for manipulation

p <- merge(o,p,by=c("isocode","year")) # merge with OECD age data

p$LN <- p$emp/p$pop # create employee (L) to pop (N) ratio
p$LW <- p$LN/p$WN # create employee (L) to working-age population (W) ratio

p <- p[with(p, order(isocode, year)), ] # sort 

p$y <- p$rgdpna/p$pop # create log GDP per capita
p$KY <- p$rnna/p$rgdpna # create K/Y ratio
p$LN <- p$emp/p$pop # create employee (L) to pop (N) ratio

#########################################################################
# Set up function to calculation growth rates at arbitrary lags for countries
# - Takes as given that you pass a PWT object with an isocode
#########################################################################
f.grate <- function(data,name,lags){
  data$v <- data[[name]] # data series to do growth rate on
  data$vlag <- dplyr::lag(data$v,lags) # lag the data series
  data$g <- (data$v/data$vlag)^(1/lags) - 1 # calculate the growth rate
  data$isolag <- lag(data$isocode,lags) # lag the isocode
  data$g[data$isocode != data$isolag] <- NA # replace with NA if eval goes x country
  return(round(data$g,digits=4))
}

#########################################################################
# Do basic accounting on 20-year windows for summarizing
#########################################################################
lags <- 20 # how many years to look backwards at growth rates

p$gy <- f.grate(p,"y",lags) # GDP per capita
p$gKY <- f.grate(p,"KY",lags) # capital/output ratio
p$gLN <- f.grate(p,"LN",lags) # emp/pop ratio
p$gLW <- f.grate(p,"LW",lags) # employee/working age ratio
p$gWN <- f.grate(p,"WN",lags) # working age/pop ratio
p$gavh <- f.grate(p,"avh",lags) # average hours worked
p$ged <- f.grate(p,"hc",lags) # this is actually just education
p$gA <- round(p$gy - (alpha/(1-alpha))*p$gKY - p$gLN - p$gavh - p$ged,digits=4) # productivity growth
p$gcap <- round((alpha/(1-alpha))*p$gKY,digits=4) # net capital term
p$ghc <- round(p$gLW + p$gWN + p$gavh + p$ged,digits=4) # sum of all HC terms

# Create difference terms for table
p$gydiff <- p$gy - dplyr::lag(p$gy,lags) # GDP per capita
p$gcapdiff <- p$gcap - dplyr::lag(p$gcap,lags) # net capital
p$gAdiff <- p$gA - dplyr::lag(p$gA,lags) # productivity
p$gLWdiff <- p$gLW - dplyr::lag(p$gLW,lags) # employee/working age
p$gWNdiff <- p$gWN - dplyr::lag(p$gWN,lags) # working age/pop
p$gavhdiff <- p$gavh - dplyr::lag(p$gavh,lags) # average hours
p$geddiff <- p$ged - dplyr::lag(p$ged,lags) # education

p$gydiff_alt_bad <- p$gcapdiff + p$gAdiff + p$geddiff + p$gWNdiff
p$gydiff_alt_good <- p$gcapdiff + p$geddiff + p$gavhdiff + p$gLWdiff

#########################################################################
# Create table showing diff in 20-year growth rates
#########################################################################
ptable <- p[which(p$year %in% c("2019")),] # just use 2019
ptable$gydiff <- sprintf("%.2f", ptable$gydiff*100)
ptable$gcapdiff <- sprintf("%.2f", ptable$gcapdiff*100)
ptable$gAdiff <- sprintf("%.2f", ptable$gAdiff*100)
ptable$geddiff <- sprintf("%.2f", ptable$geddiff*100)
ptable$gavhdiff <- sprintf("%.2f", ptable$gavhdiff*100)
ptable$gLWdiff <- sprintf("%.2f", ptable$gLWdiff*100)
ptable$gWNdiff <- sprintf("%.2f", ptable$gWNdiff*100)
ptable$gydiff_alt_bad <- sprintf("%.2f", ptable$gydiff_alt_bad*100)
ptable$gydiff_alt_good <- sprintf("%.2f", ptable$gydiff_alt_good*100)

tab <- plot_ly(type = 'table',
               header = list(
                 values = c("Country","GDP p.c.", "Capital", "Prod","Educ","Hours","LFP","Aging"),
                 #align = c("center", "center", "center", "center"),
                 line = list(width = 1, color = 'black'),
                 fill = list(color = c("grey", "grey")),
                 font = list(family = "Arial", size = 14, color = "white")
               ),
               cells = list(
                 values = rbind(ptable$isocode, ptable$gydiff, ptable$gcapdiff, ptable$gAdiff, ptable$geddiff, ptable$gavhdiff, ptable$gLWdiff, ptable$gWNdiff),
                 #align = c("center", "center", "center", "center"),
                 line = list(color = "black", width = 1),
                 font = list(family = "Arial", size = 12, color = c("black"))
               )
               )

saveWidget(partial_bundle(tab), "tab_europe.html",selfcontained = F, libdir = "lib")

alt <- plot_ly(type = 'table',
               header = list(
                 values = c("Country","Actual", "Worst case", "Best case"),
                 #align = c("center", "center", "center", "center"),
                 line = list(width = 1, color = 'black'),
                 fill = list(color = c("grey", "grey")),
                 font = list(family = "Arial", size = 14, color = "white")
               ),
               cells = list(
                 values = rbind(ptable$isocode, ptable$gydiff, ptable$gydiff_alt_bad,ptable$gydiff_alt_good),
                 #align = c("center", "center", "center", "center"),
                 line = list(color = "black", width = 1),
                 font = list(family = "Arial", size = 12, color = c("black"))
               )
)
saveWidget(partial_bundle(alt), "tab_alt_europe.html",selfcontained = F, libdir = "lib")

#########################################################################
# Do basic accounting on 10-year windows for figures
#########################################################################
lags <- 10 # how many years to look backwards at growth rates

p$gy <- f.grate(p,"y",lags) # GDP per capita
p$gKY <- f.grate(p,"KY",lags) # capital/output ratio
p$gLN <- f.grate(p,"LN",lags) # emp/pop ratio
p$gLW <- f.grate(p,"LW",lags) # employee/working age ratio
p$gWN <- f.grate(p,"WN",lags) # working age/pop ratio
p$gavh <- f.grate(p,"avh",lags) # average hours worked
p$ged <- f.grate(p,"hc",lags) # this is actually just education
p$gA <- round(p$gy - (alpha/(1-alpha))*p$gKY - p$gLN - p$gavh - p$ged,digits=4) # productivity growth
p$gcap <- round((alpha/(1-alpha))*p$gKY,digits=4) # net capital term
p$ghc <- round(p$gLW + p$gWN + p$gavh + p$ged,digits=4) # sum of all HC terms

#########################################################################
# Figures for various human capital measures
#########################################################################
figWN <- plot_ly(p, x = ~year, y = ~gWN, linetype = ~isocode, type = 'scatter', mode = 'lines')
figWN <- layout(figWN, title = list(text = 'Growth contribution of working age pop (20-64) as share of total', x=0),
                 xaxis = list(title = 'Year'),
                 yaxis = list (title = '10-year avg. gr. rate in working age pop/pop', range=c(-.03,.03)),
                 hovermode="x unified")

figLW <- plot_ly(p, x = ~year, y = ~gLW, linetype = ~isocode, type = 'scatter', mode = 'lines')
figLW <- layout(figLW, title = list(text = 'Growth contribution of employees as share of working age pop (20-64)', x=0),
                  xaxis = list(title = 'Year'),
                  yaxis = list (title = '10-year avg. gr. rate in working age pop/pop', range=c(-.03,.03)),
                  hovermode="x unified")

figLN <- plot_ly(p, x = ~year, y = ~gLN, linetype = ~isocode, type = 'scatter', mode = 'lines')
figLN <- layout(figLN, title = list(text = 'Growth contribution of employees as share of total pop ', x=0),
                xaxis = list(title = 'Year'),
                yaxis = list (title = '10-year avg. gr. rate in employee/pop', range=c(-.03,.03)),
                hovermode="x unified")

figLWlevel <- plot_ly(p, x = ~year, y = ~LW, linetype = ~isocode, type = 'scatter', mode = 'lines')
figLWlevel <- layout(figLWlevel, title = list(text = 'Employees as share of working-age pop.', x=0),
                xaxis = list(title = 'Year'),
                yaxis = list (title = 'Employees / working-age pop.', range=c(0,1)),
                hovermode="x unified")

figWNlevel <- plot_ly(p, x = ~year, y = ~WN, linetype = ~isocode, type = 'scatter', mode = 'lines')
figWNlevel <- layout(figWNlevel, title = list(text = 'Working-age as a share of total pop.', x=0),
                     xaxis = list(title = 'Year'),
                     yaxis = list (title = 'Working-age / Total pop.', range=c(0,1)),
                     hovermode="x unified")

figavhlevel <- plot_ly(p, x = ~year, y = ~avh, linetype = ~isocode, type = 'scatter', mode = 'lines')
figavhlevel <- layout(figavhlevel, title = list(text = 'Average hours worked', x=0),
                     xaxis = list(title = 'Year'),
                     yaxis = list (title = 'Average hours worked', range=c(1000,2500)),
                     hovermode="x unified")
# The following commands bundle up each figure so I can self-host them on my site.
# You can safely comment these out if you just want to work with the figures themselves
# If you leave this, it will probably fail unless you have a folder called "plotly" created
saveWidget(partial_bundle(figWN), "fig_europe_WN.html",selfcontained = F, libdir = "lib")
saveWidget(partial_bundle(figLW), "fig_europe_LW.html",selfcontained = F, libdir = "lib")
saveWidget(partial_bundle(figLN), "fig_europe_LN.html",selfcontained = F, libdir = "lib")
saveWidget(partial_bundle(figLWlevel), "fig_europe_LWlevel.html",selfcontained = F, libdir = "lib")
saveWidget(partial_bundle(figWNlevel), "fig_europe_WNlevel.html",selfcontained = F, libdir = "lib")
saveWidget(partial_bundle(figavhlevel), "fig_europe_avhlevel.html",selfcontained = F, libdir = "lib")

write.csv(p, "../data/PWT_calcs_Europe.csv", row.names=FALSE)