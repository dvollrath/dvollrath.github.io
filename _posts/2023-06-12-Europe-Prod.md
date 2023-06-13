---
layout: post
title: Productivity growth in the European slowdown
published: false
category: feed
tags: slowdown
---

### Catching back up
I'm doing a basic breakdown of growth in GDP per capita according to the following

$$
g_y = g_{Cap} + g_{Human} + g_{Prod},
$$

where $g_y$ is the growth rate of GDP per capita, $g_{Cap}$ is the contribution of physical capital accumulation, $g_{Human}$ the contribution of human capital, and $g_{Prod}$ the contribution of productivity. I talked in a prior post about human capital, and the first post established that the growth rate of capital wasn't terribly interesting. This post is about the slowdown in productivity growth.

There are a number of ways to look at why productivity growth in Europe slowed down. I want to limit myself here to just thinking about some basic accounting. Overall productivity growth, $g_{Prod}$, is a weighted sum of the produtivity growth in all the different industries in a country. The weights in that weighted sum are the industry's value-added as a share of GDP (which is total value-added of all industries). If an industry doesn't account for much of economic activity, then intuitively any productivity change in that industry doesn't mean much for overall productivity, and vice versa. 

In terms of slower productivity growth, then, this gives us a few options. One is that productivity growth in all industries became slower, which could certainly be the case. A second more nuanced option is that productivity growth became slower in industries that make up a large fraction of GDP, which lowered overall productivity growth even if productivity growth in some small-ish industries went up. This second case can help explain why you can read news regarding some fantastic technological innovation (battery tech or something) while also reading a story about how overall productivity growth is slowing down. 

There are some other options involving changes in the weights. I'll touch on that later in the post.

### Slow growth everywhere
It looks a lot like we've got option number one; slower productivity growth across all industries. I tried to come up with a relatively simple way to display or document this. I think the following figure accomplishes that. 

This is based on KLEMS data for the same set of countries I've been looking at so far (US for comparison, UK, France, Germany, Italy, Spain, and the Netherlands). KLEMS lets me calculate labor productivity (real output divided by employed persons) for each of 17 large industries (e.g. "Manufacturing", "Finance", etc.) in those countries from 1995 through 2019 (I threw out 2020 for obvious reasons). 

I'm using labor productivity because I want this to be easy, and because I could write a whole boring post about how I'm squeamish about how KLEMS does total factor productivity calculations. It is hard to come up with a great argument that somehow the story I'll tell about labor productivity is not broadly true for total factor productivity as well. 

Overall labor productivity growth is going to be a weighted sum of the labor productivity growth in each of the industries, with the weights depending on the share of economic activity accounted for by that industry. In the figure below I've plotted two different types of data. The first is this overall labor productivity growth, by year, across the seven countries. The blue dots are thus the average of overall labor productivity growth across the seven countries, and the blue line is just the trend in that overall productivity growth rate over time. As you can see, it trends down (duh, otherwise why write all this) and drops from about 1% per year in 1995 to about 0.6% per year in 2019. 

![KLEMS breakdown](./figures/2022-06-08-KLEMS-Account.png)

The second set of points is the *unweighted* average productivity growth across all industries (and across all countries) for each year. These red dots ignore the fact that some industries are large and some are small, and is just showing the raw growth rate of labor productivity in all these industries, regardless of size. You can get a few pieces of information from the red dots and the red trendline, which also slopes down over time.

First, the unweighted growth of labor productivity across industries in these countries is declining over time at roughly the same magnitude as the overall labor productivity decline. This unweighted data tells us that, in general, labor productivity growth is declining across all industries. This indicates that option one is in play. It sure looks like there is just a general slowdown in productivity growth in these countries, regardless of industry. 

When I started working on this data and post, I was pretty sure there was going to be a common European-wide story. And the figure here seems to indicate that there is a common trend downward in labor productivity growth across all industries. In playing around with this, however, I think the figure I just showed you isn't going to do justice to what's happening. The much more complicated answer is that "it depends". If you make the figure above for each country individually, things break up into a few different stories. 

I'm going to take those individual country stories in new post, as that started to get out of hand. The short version to tease things goes like this. France, Netherlands, and the UK have a broad based decline in labor productivity that looks a lot like the figure above. Germany doesn't really have a slowdown in labor productivity growth? If anything unweighted average productivity growth rose across industries. Italy doesn't have much of a slowdown, but just has really low productivity growth the whole time period. Spain's labor produtivity went *up* over time. Trying to be lazy, like me, and come up with a common European story just doesn't appear tenable. 

### Your consolation prize
So while I keep working on some country-specific analysis, you are stuck with some remaining broad-based thoughts that I hope will keep you satisfied in the meantime.

Start by going back to the first figure. A second thing to note is that the unweighted average is *below* the overall labor productivity growth rate in general, as indicated by the fact that the red trendline is everywhere below the blue one. This means that, in general, larger industries tend to have higher growth rates of labor productivity. That's good for productivity growth. Better to have your larger industries with strong productivity growth rather than your small ones, if you have to pick. 

But if you squint, you'll also see that the two lines are getting closer together. In 1996 the gap was about 0.004, or overall labor productivity growth was about 0.4% higher every year than the unweighted average across industries. By 2019 that gap was only 0.002, or 0.2% difference in growth rate. The advantage of having large industries with higher labor productivity growth was shrinking. Given that labor productivity growth was only, at best, around 1% per year, losing 0.2% in growth is nothing to sneeze at.

What's going on? We know that labor productivity growth fell across all industries. What must be happening is that the weights on each industry were shifting such that there was more weight on low-growth industries and less weight on high-growth industries. Industries with relatively low productivity growth were getting larger relative to high-growth industries. 

We can see this in the same KLEMS dataset. For each industry/country I calculated a five-year growth rate in labor productivity (e.g. from 1995 to 2000). To make comparison across all the countries possible, these growth rates are then centered, meaning what you're going to see in the figure is labor productivity growth *relative* to overall productivity growth in that country in that period. 

The other thing I want to measure is the share of GDP accounted for by each industry, and in particular how that share *changed* over time. For each industry I calculated the five-year change in it's share of GDP looking foward (e.g. from 2000 to 2005). The idea is that I want to see whether the productivity growth implied by the change in labor productivity from 1995 to 2000 (say) is associated with an increase or decrease in the share of economic activity after that period, from 2000 to 2005 (say). There is nothing magic about using 5-year windows to do this, I just wanted something that smoothed out some annual fluctuations. 

![Shares and growth](./figures/2022-06-08-KLEMS-Account.png)

For each country I have 17 industries, and I have data from 1995 through 2019 (24 years). Because of the windows I'm using for the calculations (past five years for labor productivity and forward five years for share of GDP) I am left with a total of 1,965 data points (each data point is a country/industry/year observation). This gets too hard to see anything with in a figure. I used the ["binscatter"](https://michaelstepner.com/binscatter/) command to produce the above figure, which groups the data together into 100 subsets and plots their averages for me, which retains the overall relationship but allows you to see what is going on.

On the x-axis is the five-year change in relative labor productivity. Anything above zero means that country/industry in that five-year window saw labor productivity increase *more* than average, and anything less than zero *less* than average. 

On the y-axis is the five-year (looking forward) change in share of GDP. This has the natural interpretation. Observations above zero mean the industry expanded in those five years as a share of GDP, while negatives mean it shrunk. Those aren't statements about the absolute growth in value-added of that industry, by the way. This is still a relative comparison. An industry could expand production but lose share of GDP because other industries expand more. 

The pattern in the data is pretty clearly negative. Most of the data lies in the upper left quadrant, with slow productivity growth but a *rising* share of GDP, or in the lower right quadrant, with rapid productivity growth but a *falling* share of GDP. Rather than shifting economic activity into fast(er)-growing industries, on average countries were shifting economic activity into slow(er)-growing industries. This is consistent with the red line and blue line above getting closer together. The advantage of having large industries with high productivity growth is shrinking; those industries are getting smaller. 

Why would this occur? The simplest answer is that these industries are effectively complements to one another. On net, when productivity goes up in an industry, its price relative to other industries falls. People buy *more* of the product from that industry, yes. But not enough to match the price decline, meaning that total spending on that industry goes down, and so its weight in GDP falls. Let's say that you normally spend $100 buying 20 beers at $5 each. There is a revolution in beer production that lowers the price to $3 per beer. You rejoice! You now buy 25 beers at $3 each, spending ... $75. You now spend less on beer than you did before. More important, you now have $25 that you were spending on beer. If you go out and use that to buy an extra pizza, then what's happened to the split of spending between pizza and beer? Pizza now accounts for more of your expenditure, and beer less. The weight on beer has *fallen*, even though beer was the product that experienced the big produtivity increase. This occurs because pizza and beer are (in this example) complementary products. You like to consume them together (because you are a sane person) and therefore you "spend" some of the productivity increase in beer on buying extra pizza. 

That appears to be what is going on in this data more broadly. And over time, it chips away at the weight on the high-productivity-growth industries, and increases the weight on relatively low-productivity-growth industries. The advantage that appeared to exist in 1995 in the first figure is getting eroded by this phenomenon. Perhaps most worrisome, one could easily imagine this continuing and pushing these countries into the position where overall labor productivity growth is *below* the average growth rate across industries. When I look at individual countries in a future post, you'll see that several of them are already in this situation. 

### Your kinda-sorta answer
This leaves us having taken only one tiny step forward in understanding the European slowdown. In general labor productivity growth has declined across industries (the unweighted average growth rate fell). So there is something broad-based going on, but there are some interesting country-level variations I'll get to in the future. What we do know is that overall productivity growth is *also* getting dragged down by the erosion of the (relative) size of fast-growing industries and the (relative) increase in size of slow-growing industries, which is consistent with industries being complements. 