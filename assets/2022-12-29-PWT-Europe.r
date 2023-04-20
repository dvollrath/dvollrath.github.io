# Do growth accounting and prepare figures of results

#########################################################################
# Housekeeping
#########################################################################
# Necessary packages, you may have to install
library(pwt10)
library(plotly)
library(htmlwidgets)
library(dplyr)

#########################################################################
# Pick an elasticity of GDP w.r.t. capital
#########################################################################
alpha <- 0.3 # look, there is no perfectly right answer here
lags <- 10 # how many years to look backwards at growth rates

#########################################################################
# Pull PWT into dataframe
#########################################################################
data("pwt10.0") # extracts PWT data into an object called pwt10.0
p <- pwt10.0 # copy PWT data for manipulation

#########################################################################
# Set up function to calculation growth rates at arbitrary lags for countries
# - Takes as given that you pass a PWT object with an isocode
#########################################################################
f.grate <- function(data,name,lags){
  data$v <- data[[name]] # data series to do growth rate on
  data$vlag <- lag(data$v,lags) # lag the data series
  data$g <- (data$v/data$vlag)^(1/lags) - 1 # calculate the growth rate
  data$isolag <- lag(data$isocode,lags) # lag the isocode
  data$g[data$isocode != data$isolag] <- NA # replace with NA if eval goes x country
  return(data$g)
}

p$y <- p$rgdpna/p$pop # create log GDP per capita
p$KY <- p$rnna/p$rgdpna # create K/Y ratio
p$LN <- p$emp/p$pop # create employee (L) to pop (N) ratio

p$gy <- f.grate(p,"y",lags) # GDP per capita
p$gKY <- f.grate(p,"KY",lags) # capital/output ratio
p$gLN <- f.grate(p,"LN",lags) # emp/pop ratio
p$gavh <- f.grate(p,"avh",lags) # average hours worked
p$ged <- f.grate(p,"hc",lags) # this is actually just education
p$gA <- round(p$gy - (alpha/(1-alpha))*p$gKY - p$gLN - p$gavh - p$ged,digits=4) # productivity growth
p$gcap <- round((alpha/(1-alpha))*p$gKY,digits=4) # net capital term
p$ghc <- round(p$gLN + p$gavh + p$ged,digits=4) # sum of all HC terms

#########################################################################
# Subset data for Europe and accounting terms
#########################################################################
europe <- p[which(p$isocode %in% c("USA","JPN","FRA","GBR","DEU")),]
france <- p[which(p$isocode %in% c("USA","FRA")),]

fig_france <- plot_ly(france, x = ~year, y = ~gy, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_france <- layout(fig_france, title = list(text = '10-year growth rate of GDP per capita', x=0), 
                     xaxis = list(title = 'Year'),
                     yaxis = list (title = '10-year growth rate', range=c(-.01,.08)),
                     hovermode="x unified")

fig_europe <- plot_ly(europe, x = ~year, y = ~gy, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_europe <- layout(fig_europe, title = list(text = '10-year growth rate of GDP per capita', x=0), 
              xaxis = list(title = 'Year'),
              yaxis = list (title = '10-year growth rate', range=c(-.01,.10)),
              hovermode="x unified")

fig_cap <- plot_ly(europe, x = ~year, y = ~gcap, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_cap <- layout(fig_cap, title = list(text = '10-year growth rate of capital/output', x=0), 
                   xaxis = list(title = 'Year'),
                   yaxis = list (title = '10-year growth rate', range=c(-.01,.08)),
                   hovermode="x unified")

fig_hc <- plot_ly(europe, x = ~year, y = ~ghc, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_hc <- layout(fig_hc, title = list(text = '10-year growth rate of human capital', x=0), 
                  xaxis = list(title = 'Year'),
                  yaxis = list (title = '10-year growth rate', range=c(-.03,.06)),
                  hovermode="x unified")

fig_prod <- plot_ly(europe, x = ~year, y = ~gA, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_prod <- layout(fig_prod, title = list(text = '10-year growth rate of productivity', x=0), 
              xaxis = list(title = 'Year'),
              yaxis = list (title = '10-year growth rate', range=c(-.03,.08)),
              hovermode="x unified")

fig_ed <- plot_ly(europe, x = ~year, y = ~ged, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_ed <- layout(fig_ed, title = list(text = '10-year growth rate of education', x=0), 
                 xaxis = list(title = 'Year'),
                 yaxis = list (title = '10-year growth rate', range=c(-.01,.04)),
                 hovermode="x unified")

fig_LN <- plot_ly(europe, x = ~year, y = ~gLN, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_LN <- layout(fig_LN, title = list(text = '10-year growth rate of employ/pop', x=0), 
                 xaxis = list(title = 'Year'),
                 yaxis = list (title = '10-year growth rate', range=c(-.03,.04)),
                 hovermode="x unified")

fig_avh <- plot_ly(europe, x = ~year, y = ~gavh, linetype = ~isocode, type = 'scatter', mode = 'lines')
fig_avh <- layout(fig_avh, title = list(text = '10-year growth rate of average hours', x=0), 
                 xaxis = list(title = 'Year'),
                 yaxis = list (title = '10-year growth rate', range=c(-.03,.06)),
                 hovermode="x unified")

# The following commands bundle up each figure so I can self-host them on my site.
# You can safely comment these out if you just want to work with the figures themselves
# If you leave this, it will probably fail unless you have a folder called "plotly" created
#saveWidget(partial_bundle(fig_europe), "./plotly/fig_europe.html",selfcontained = F, libdir = "lib")
#saveWidget(partial_bundle(fig_france), "./plotly/fig_france.html",selfcontained = F, libdir = "lib")

#saveWidget(partial_bundle(fig_cap), "./plotly/fig_europe_cap.html",selfcontained = F, libdir = "lib")
#saveWidget(partial_bundle(fig_hc), "./plotly/fig_europe_hc.html",selfcontained = F, libdir = "lib")
#saveWidget(partial_bundle(fig_prod), "./plotly/fig_europe_prod.html",selfcontained = F, libdir = "lib")
#
#saveWidget(partial_bundle(fig_ed), "./plotly/fig_europe_ed.html",selfcontained = F, libdir = "lib")
#saveWidget(partial_bundle(fig_LN), "./plotly/fig_europe_LN.html",selfcontained = F, libdir = "lib")
#saveWidget(partial_bundle(fig_avh), "./plotly/fig_europe_avh.html",selfcontained = F, libdir = "lib")
