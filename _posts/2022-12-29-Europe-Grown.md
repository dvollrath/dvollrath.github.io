---
layout: post
title: Fully Grown - European Vacation!
published: true
category: feed
tags: slowdown
---

Before jumping into the proper post, some housekeeping. Thanks to a combination of Twitter's situation and not missing Twitter while I took a hiatus this year, I really have no stake in staying over there. My account is still up, and for the time being I'll keep the automated service that tweets out a link to my blog posts. 

However, my main online interactions will be via Mastodon at [@DietzVollrath@econtwitter.net](https://econtwitter.net/@DietzVollrath), where the local econo-sphere has coalesced enough to make things worth following. I'll link to any new blog posts over there as well.

Does that mean I'm going to blog more regularly? As always, that's the plan. By which I mean, "probably not". But hope springs eternal.

On with the show!

### Growth slowdowns
This post is something I've been thinking about for quite a while. In short, I want to do the same basic accounting for the growth slowdown in Europe that I did for the United States in my book, [Fully Grown](https://amzn.to/3C5J4Ry). You, of course, already own multiple copies. But feel free to hit the Amazon page to get a "rescue present" for those friends of yours that assumed you *were* on gift-giving terms, even though you thought you were *not*. You can blame Amazon fulfillment and smooth over the whole awkward moment.

Anyway, back to growth slowdowns. For the United States I delineated between a relatively fast-growth 20th century and a slow-growth 21st century. GDP per capita in the US grew at about 2.25% per year in the 20th, and about 1% per year in the 21st. This slowdown appeared to predate the financial crisis, starting some time around the year 2000. 

Does this look the same for Europe? Basically, yes. But Europe has a little more muck to wade through to get there. To start, let's look at the US and France. In the figure below I've plotted the 10-year backward-looking annualized growth rate in each year. For example, in 2000 it plots the annual growth rate from 1990 to 2000. The US is just above 2% throughout the 20th century, with a bulge of growth around the late 1960s and early 1970s, but then the slowdown starts in earnest in the 1998-2008 window. There is an uptick in growth in 2009-2019, partly because the start date there is in the midst of the financial crisis. 

<iframe frameborder="0"
             width="900" height="600"
             scrolling="no"
             src="/assets/plotly/fig_france.html"
             frameborder="0">
</iframe>

How about France? The plot looks slightly different in the early years. Between 1960 and 1980 the growth rate was generally higher than in the US, at closer to 4%. And remember this is the growth rate of GDP per capita, so the growth rate of GDP was even higher. After 1980 France looks a lot like the US, trending along at (not quite) 2% until the early 2000s and then it experiences a growth slowdown of similar proportions. 

Before moving on, a few technical notes. First, assuming I've done this correctly, the figure should be interactive in the sense that you can hover over points and see the precise measurement. You can also use the buttons at the top right to zoom or capture a snapshot of the figure. The data is from the Penn World Tables and the code to generate the figure is linked in the last section of this post.

### Convergence versus slowdown
Back to France. There are really two different slowdowns in the figure. There is the 1970 to 1980 slowdown, and then there is the 2000 to 2010 slowdown. As in Fully Grown, I'm only concerned with the latter slowdown. The earlier slowdown is basically a function of France converging back to its balanced growth path after World War II. This earlier slowdown in growth is, to me, almost entirely explicable in terms of simple Solow model dynamics. This is "catch-up" growth, equivalent to running a little faster than the pack for a while because you had to stop and tie your shoe. As you catch up with your group you naturally slow down to their steady pace. 

<iframe frameborder="0"
             width="900" height="600"
             scrolling="no"
             src="/assets/plotly/fig_europe.html"
             frameborder="0">
</iframe>

For Europe in general we get the same story. This second figure is the same as the first, only with additional countries added. The choice of countries is somewhat arbitrary, but in poking around in the data I didn't find any substantial deviations from this figure. There is a general period of rapid growth early on (1960 to 1980) reflecting convergence, steady growth at around 2% per year (ish) from 1980 to 2000, and then the notable growth slowdown that this post is all about. 

One more technical note. If you double click on a country code in the legend it will display only that country's growth rate. You can then single click on another country code to add that to the plot. Double click on a country code to add all countries back to the plot. 

If you play around in the figure, you'll find a few variations on the France theme.

- The United Kingdom doesn't have the same "catch-up" growth rate from 1960 to 1980. It looks like the US in having about 2%-ish growth from 1960 to 2000. 
- Germany and Italy don't have a distinct period of steady growth from 1980 to 2000. They both start with relatively high growth around 1960, and then this declines continuously from then until the early 2000s. Italy has a distinct drop in the growth rate, similar to France, but Germany just kind of drifts into the slowdown. My working assumption is that Germany and Italy aren't fundamentally different than the others, but that they just don't have the same distinct levelling off of growth in the late 20th century. 
- Spain and the Netherlands both have distinct rebounds around 1980 in their growth rates, growing in the high 2.7-3% per year rate for much of the 1990s prior to their own slowdowns in the early 2000s. Again, I'm not assuming this reflects a truly different mechanism. But they will show up with some interesting differences in the accounting. 

### Break it down
Alright, much of western Europe experienced a growth slowdown similar to the US some time around the early 2000s. As I did in Fully Grown, I want to account for the sources of this growth slowdown across the following categories: physical capital accumulation, human capital accumulation, and productivity growth. 

To refresh your memory, what I found in Fully Grown for the US was that the vast majority - if not all - of the slowdown could be attributed to a slowdown in human capital growth. That, in turn, was the result of a burst of human capital growth in the 20th century as Boomers entered the labor force, and a drag on human capital growth in the 21st century as Boomers started their exit from the labor force. One way of seeing the US experience is that 20th century growth was abnormally *high* because the employment to population ratio rose quickly due to Boomers, and the slowdown is a natural reaction to that temporary boost working its way out of the system.

Can we do the same thing for Europe? Sure. I break down the growth rate of GDP per capita, $g_y$, as follows:

$$
g_y = g_{Cap} + g_{Human} + g_{Prod}.
$$

The last section of the post gives you all the math about how I got here. For now you're just going to trust me. $g_{Cap}$ is the contribution of the growth rate of the capital/output ratio. For the growth nerds, this $g_{Cap}$ term includes the elasticity adjustment, and you can see the final section for the full math. 

$g_{Human}$ is the growth rate of human capital. This combines growth in average education, growth in average hours worked per week (which may be negative), and growth in the employment/population ratio (which could be due to demographics or policy). Why does that employment/population ratio matter? Because we're looking at growth in GDP *per capita*, or per person, and so it matters how many of those persons are actually working. 

The last term is $g_{Prod}$, the growth rate of productivity. Like all measures of productivity growth it is just whatever it has to be to make this equation work out. It's a residual measure, although we might be able to say some smart things about it once we do some extra work. And there is nothing different about "productivity" from "total factor productivity" or "multi-factor productivity". I'm just too lazy to write those longer phrases out. 

What does the data say? This first figure gives you the combined effect of physical capital on the growth rate of GDP per capita. I deliberately made the scale of the y-axis the same as in the prior figures on GDP per capita growth so you can get make a comparison. It is pretty obvious that the contribution of $g_{Cap}$ is small throughout, and small for all countries. 

<iframe frameborder="0"
             width="900" height="600"
             scrolling="no"
             src="/assets/plotly/fig_europe_cap.html"
             frameborder="0">
</iframe>

There is a subtle dynamic at work here if you look closely. In the 1960-1980 period the growth rate is slightly positive, contributing to growth in living standards. From 1980 to about 2000 it tends to be negative or close to zero. After 2000 it is slightly positive again. If anything, the slight uptick in physical capital growth is offsetting other forces pushing down on the growth rate. And one last note here is that this figure doesn't indicate a lack of growth in physical capital. It indicates that physical capital did not grow fast *relative to GDP*. Because new capital is itself part of GDP, you want to measure the contribution of capital relative to GDP. I explained this in more detail in, you guessed it, my book.

On to human capital. In the figure below I plot $g_{Human}$. Here I had to tweak the axis scale because there are several cases where $g_{Human}$ becomes quite negative. Regardless, there are a few stories here that stand out to me.

<iframe frameborder="0"
             width="900" height="600"
             scrolling="no"
             src="/assets/plotly/fig_europe_hc.html"
             frameborder="0">
</iframe>

First, the United States is weird. If you select just the US you'll see the rough story I outlined above. Relatively high growth in human capital during the middle of the 20th century (adding about 1.5-2% per year to growth) and then distinct negatives in the 21st century, with only a recent uptick (again, probably an artefact of the financial crisis). No other European country, though, looks like this.

Germany has *negative* human capital growth throughout the 20th century that became positive around 2000, *offsetting* the growth slowdown. France also had negative growth around 1960, and then human capital growth tracks right around zero from there forward. The UK kinda-sorta looks like the German situation. The Netherlands experiences significant human capital growth into the 1990s and then a slow decline afterwards.

Italy has a massive burst of human capital growth in the late 20th century, and then it cratered later in the 21st century. Spain has a huge wave of human capital growth in the late 20th century which then drops off a cliff into the early 21st, providing at least some of the explanation for their slowdown. These two are probably the most similar to the US, but the scale and timing is not that close. In the US you can see a slow decline in human capital growth prior to 2000, consistent with aging, while in Italy and Spain the drop appears more sudden and the timing is such that it looks more like a response to the financial crisis than anything else. 

Last, how about productivity growth? The figure below shows that relative to the US, a decline in productivity growth is more apparent for Europe around the time of the slowdown. If you look at the US, productivity growth rises up until about 2005, and then starts to abate. But if you look at the UK or France, as examples, their productivity growth just sort of tracks 2% up until about 2006, and then it drops down close to zero percent per year, and at times is negative. That's a far more dramatic drop in productivity growth than the US.

<iframe frameborder="0"
             width="900" height="600"
             scrolling="no"
             src="/assets/plotly/fig_europe_prod.html"
             frameborder="0">
</iframe>

From all these figures, I come up with a few tentative conclusions.

1. Changes in the accumulation of physical capital were not important for Europe's growth slowdown.
2. Changes in human capital growth were important for Europe's growth slowdown, but that effect varies by country. This also doesn't tell me whether it was demographics (as in the US) or some other factor in human capital, like changes in education or working hours. 
3. A significant source of the growth slowdown in Europe is due to a drop in productivity growth, pretty much universally. This drop is larger than in the US.

This doesn't actually tell us a whole lot, I know. What I see this post as doing as establishing the basic facts that have to be looked at to explain Europe's slowdown. I know I'm terrible about keeping up with posts, but I also feel leaving it open-ended like this provides me with more motivation to do the follow up posts. What I have in mind going forward is a couple of additional topics. One is likely to be breaking down the human capital term and asking how much can be accounted for by demographics in each country. My gut reaction is that this will be less important for Europe as a whole than the US, but there will probably be a few examples where it is relevant.

A second will be on the productivity decline, and how much of that could be attributed to structural factors like shifts into services. My gut reaction here is that this kind of structural shift will be less important than in the US, as it is hard to slow-moving structural shifts with the dramatic drop in productivity growth that occurred. 

That's the plan, at least. I'm sure this means the productivity post will come out in 2026 or something. But for now I'm forging ahead!

### Technical stuff
The data all comes from the [Penn World Tables](https://www.rug.nl/ggdc/productivity/pwt/?lang=en) version 10.0, as this provides consistent data across countries. The GDP data are in constant *national* prices (not PPP) because I only do within-country accounting of the growth rates. I'm not comparing levels of GDP per capita across countries.

I did all the analysis in R, which has a nice package called "pwt10" that automatically pulls the PWT data into a dataframe. You can download the script [here](/assets/2022-12-29-PWT-Europe.r). The plots in the post are all built using Plotly and then hosted on my own site. All the necessary packages are listed in the script, and it *should* be self-contained so that you can run "as-is". 

To do the accounting, I start with a Cobb-Douglas production function

$$
Y = K^{\alpha}(AH)^{1-\alpha}
$$

where $K$ is physical capital, $A$ is productivity, and $H$ is the aggregate amount of human capital used (it combines number of workers, their education, and the time they spend working). In what is a fairly standard technique in any growth textbook (like [this one](https://amzn.to/3hWmsMG)) you can divide both sides by $Y^{\alpha}$ and re-arrange to get

$$
Y = \left(\frac{K}{Y} \right)^{\frac{\alpha}{1-\alpha}} A H
$$

and then divide through by $N$, the population, to get GDP per capita, $y$:

$$
y = \left(\frac{K}{Y} \right)^{\frac{\alpha}{1-\alpha}} A h
$$

where $h = H/N$ is the amount of human capital per person in the economy.

To get this in growth rates, take the log of both sides, and then the time derivative to get

$$
g_y = \frac{\alpha}{1-\alpha} g_{KY} + g_A + g_h
$$

In the post, I call $g_{Cap} = \alpha/(1-\alpha)g_{KY}$, which is the growth rate of the capital/output ratio scaled by a term involving the elasticity of output with respect to capital, $\alpha$. How big is $\alpha$? Well, that's a great question that would require a lot of time to answer definitively. For the purposes of this post I set it to 0.3. Why 0.3? Well, you should go read [my paper](https://growthecon.com/wp/2021/04/01/paper-Elasticity.html) on this.

The growth rate of human capital is $g_{Human} = g_h$, and the growth rate of productivity is $g_{Prod} = g_A$. In the future posts I'll be more specific about how $g_h$ breaks down.

