---
layout: post
title: Productivity growth and the European slowdown
published: true
category: feed
tags: slowdown
---

Well, better late than never, I guess? About six months ago I started playing around with some posts on the slowdown in European economic growth. [The first](https://growthecon.com/feed/2022/12/29/Europe-Grown.html) did some basic accounting to establish the role of physical capital, human capital, and productivity. [The second](https://growthecon.com/feed/2023/01/09/Europe-HC.html) dove into the composition of human capital, finding that the European slowdown was quite unlike that in the US. In particular, the slowdown in Europe featured (a) more dramatic declines in the growth rate of productivity and (b) an interesting relationship of slower productivity growth with higher labor force participation.

Here I'm going to keep talking about that change in productivity growth and the relationship with labor force participation. 

Before I do that, I'll offer this "heads up" to any readers. I'm planning on taking this blog over to Substack in the near future. What I will likely do is re-post this series of European growth to "seed" the Substack. I'll also put up a post on the blog itself directing you to the new Substack link to get signed up. To be clear, my plan on Substack is to post for free. I can't make the commitment to posting that a paid subscription would require. All I'm doing is shifting publishing over there, as I think there is a good conversation happening there (and on their Notes feed). Details will follow. 

### Catching back up
I'm doing a basic breakdown of growth in GDP per capita according to the following

$$
g_y = g_{Cap} + g_{Human} + g_{Prod},
$$

where $g_y$ is the growth rate of GDP per capita, $g_{Cap}$ is the contribution of physical capital accumulation, $g_{Human}$ the contribution of human capital, and $g_{Prod}$ the contribution of productivity. I talked in a prior post about human capital, and the first post established that the growth rate of capital wasn't terribly interesting. This post is about the slowdown in productivity growth.

In the prior post on human capital I showed this table, which compared the growth rate in 1999-2019 to the growth rate in 1979-1999. As mentioned in the prior post, that cutoff was arbitrary but gets the rough timeframe of the slowdown right. 

<iframe frameborder="0"
             width="800" height="300"
             scrolling="no"
             src="/assets/plotly/tab_europe.html"
             frameborder="0">
</iframe>

The entries in the table are the *change* in the growth rate of each element from 1979-1999 to 1999-2019. In Germany (DEU), for example, the annual growth rate of GDP per capita fell by -0.67 percentage points from the earlier period to the later period. That is the slowdown we're trying to understand. 

The remaining columns are the breakdown of that drop in the growth rate of GDP per capita into different parts. For example, in Germany the a fall in the growth rate of productivity subtracted 1.32 percentage points from the growth rate of GDP per capita, and changes in education subtracted 0.43 percentage points. In contrast, changes in hours worked *added* 0.5 percentage points to the growth rate, and increases in labor force participation *added* 1.38 percentage points. Those latter things helped offset all the other negatives, making the slowdown not as bad as it could have been. 

I noted in the prior post that the massive decline in European productivity growth rates were offset to a large extent by massive increases in the growth rate coming from labor force participation. This was something that set Europe apart from the US. In the US the produtivity growth rate fell by only a little, while the labor force participation rate (and aging) were big negatives.

### Learning to trust yourself
I also said that I was a little wary of the European numbers because they were such large changes. That always makes me nervous, like I've calculated something wrong. Here, I'm going to completely ignore those doubts and take these numbers seriously. I want to look a little more closely at the possibility that the drop in productivity growth and the rise in labor force participation rates in Europe have some meaningful relationship. 

To do that I want to start by establishing that this kind of weird relationship in the above table holds more broadly, and isn't just a figment of the time periods I chose. To do that I calculated the annualized five-year growth rate of productivity (e.g. from 1980 to 1985, from 1981 to 1986, etc..) for each country, and then calculated the annualized five-year growth rate of labor force participation. 

This generates a lot of observations across Europe (six countries times and up to 65 observtions each). This gets hard to visualize. To give a better sense of what is happening I used the ["binscatter"](https://michaelstepner.com/binscatter/) command to produce the following figure, which bins the data together into 50 subsets and plots averages within each bin. It retains the overall relationship but allows you to see it more clearly. The line is the simple OLS regression of growth rate of productivity on growth rate of labor force participation. 

![Productivity and LFP](/assets/figures/2023-06-13-PWT-Europe-glw5.pdf)

One thing to point out. This figure uses data only from 1955 forward (meaning the first five-year window is 1955-1960). You get some crazy outliers in the early 1950s for labor force participation and for productivity growth in post-war economies like Germany and France. Those didn't seem terribly relevant to this discussion of the more general slowdown later in the 20th century.

In general, across these six European countries, when labor force participation growth was higher during a five-year period, productivity growth was lower. The correlation here is pretty sizable. A 1 percentage point increase in the growth rate of labor force participation is associated with about a 0.5 percentage point decline in the growth rate of productivity. There is a clutch of outliers in the far left, which are observations from 1980s Spain that have big declines in labor force participation without a big jump in the growth rate of productivity. But other than that, the general pattern is pretty robust. 

This figure just slaps all six countries into the same figure. Is this negative relationship present in all of them? Yes, with variation in the strength of the association. In Germany a 1 percentage point increase in labor force participation growth was associated with a drop of 0.94 percentage points in productivity growth. France, 0.65 pp drop. The UK, 0.10 pp drop. Netherlands, 0.27 pp drop. Italy, 1.44 pp drop. Spain, 0.27 pp drop. Negative in each case, with Germany having the most severe relationship and the UK the least. 

Since labor force participation is confined to a range of 0 to 1, it can be weird to think about the growth rate of that. The following figure is identical in structure, but the x-axis plots the absolute change in labor force particiption in a five year period, not the growth rate. So a value of 0.05 means the labor force participation rate went up by 5 percentage points (e.g. from 0.70 to 0.75) in a five-year period.

![Productivity and LFP](/assets/figures/2023-06-13-PWT-Europe-difflw5.pdf)

The figure shows that you still get the same relationship, but this may be easier to interpret in your head. Countries in Europe that experienced big increases in labor force participation also experienced big drops in productivity growth at the same time. 

### What's happening?
You'll notice above I was careful to say "correlation" and "association". It would be a mistake to assume that the figure above means that increases in labor force participation *cause* productivity growth to decline. Perhaps declines in productivity growth - perhaps by lowering wage growth - induce more people to re-enter the labor force. 

Having said that, I'm going to go ahead and take seriously the idea that the figure represents something causal. Why am I going to risk being excommunicated by the identification police? Mainly because this is a blog post. But also because I think there is a reasonable story here, and it is a way of thinking about why investigating this for stronger evidence might be worthwhile.

![Productivity and LFP](/assets/figures/2023-06-13-PWT-Europe-trend.pdf)

One of the reasons this is worth exploring is the trend in labor force participation. It isn't obvious in the prior posts, so the above figure uses the same binning procedure to plot the raw difference in labor force participation across these six European countries over time. From 1960 to around 1990 these differences tend to be negative. But starting then, and with some big fluctuations involved, the differences become positive, and the average creeps up. For the large European economies, labor force participation was shifting up, and shifting up at precisely the time that productivity growth was starting to decline. 

Another reason this idea is worth considering is the nature of measuring productivity growth. That productivity growth number is a residual. You calculate $g_{Prod}$ from this equation

$$
g_y = g_{Cap} + g_{Human} + g_{Prod},
$$

given data on the growth rate of GDP per capita, physical capital, and human capital. $g_{Prod}$ is whatever makes this equation hold. As such, it "eats" everything not contained in the terms $g_{Cap}$ and $g_{Human}$. I've said something similar before. Productivity growth is like a trash can. Everything you don't explicitly include in $g_{Cap}$ or $g_{Human}$ gets thrown in there. 

One particular thing that gets thrown into productivity growth is any distribution or variation in human capital across workers. $g_{Human}$ includes an accounting for "skills" through a measure based on average education. But that doesn't allow for a distribution of skills (e.g. different levels of education) and definitely doesn't allow for a distribution of skills that are not well captured by years of education. Those unmeasured skills could include things like non-cognitive skills, more informal training, and things like intrinsic motivation or connections. The effect of these distributions of education and non-education-based skills on economic growth get rolled into $g_{Prod}$ by default. 

Add to that the idea that there are some frictions in these economies that keep labor force participation from being 100%. Those could be policies that deliberately keep people out (maybe a union keeps membership small to keep wages for insiders high) or policies that make staying out attractive (comfortable social safety net). In this situation, where we have some kind of distibution of skills and frictions that keep everyone from working, which of the workers are going to work? Probably the most skilled ones. They are most valuable to firms, could probably command some kind of high wage, and thus have the most to lose by being left out of the labor market. Alternatively, some entity controlling entry to certain occupations might screen for only the most highly skilled.

In this situation, what happens when rules or policies change such that more people are allowed to enter the workforce and/or more people choose to enter the workforce? In general, since there is a distribution of skills, the most skilled were employed first, this expansion of the labor force is going to lower the average skill level. Recall that $g_{Human}$ only picks up the average education-based skill level of *all* possible workers, not just those employed. So $g_{Human}$ isn't going to change much based on the decline in average skill level. Where does that decline go? Into the trash can. $g_{Prod}$ has to account for the decline in average skill. 

We could thus tell some of the story of the European slowdown as the unintended consequence of expanding labor force participation, which drew in less-skilled workers. In the data this generates a negative relationship of productivity growth and labor force participation. 

As an aside, one doesn't have to take this idea of less-skilled workers in a particularly perjorative way. Given some frictions to labor market participation, those who were not working may simply have less experience and need a certain amount of time to get up to speed with their firms as they enter. With substantial increases in labor market participation, you are constantly bringing in new workers without a lot of tacit knowledge. While they learn on the job their productivity will be relatively low. Again, that kind of thing is not picked up in the crude measure of $g_{Human}$, and so gets lumped into $g_{Prod}$. 

I absolutely believe that someone has tried to formalize this somehow, but some medium-intensity searching has not turned up a great example. If you know of one, please let me know! In general, if you hunt around for analyses of the European slowdown, you get things like this [summary report from the ECB in 2017](https://www.ecb.europa.eu/pub/pdf/other/ebart201703_01.en.pdf). It covers things like aging, R&D, regulation, and such, but nothing about possible impacts of changing labor force composition? 

One place where the ECB report brushes up against the idea of labor skill composition is in discussing business dynamism and labor reallocation. They talk about how there may be less labor reallocation, perhaps due to increasing firm market power, and how this could prevent diffusion of technology. That argument implicitly assumes workers in the labor force reallocating moving between jobs, and taking some tacit (or explicit) knowledge with them, spreading that knowledge around. Moving people from out of the labor force to into the labor force is also a form of reallocation, but unlike employed workers moving firm-to-firm, moving an out-of-labor-force person into the labor force is not bringing (as much) tacit knowledge along with them? They are unlikely to help with technology diffusion unless their spells out of the labor force were very short? 

### Comparison to the US
An interesting point of comparison is the US. As discussed in earlier posts, the US slowdown looks different than the European one. Aging was more of a factor, and there was less of a drop in productivity growth. 

Moreover, there doesn't appear to be the same strong relationship of productivity growth and labor force participation as in Europe. Here's the same kind of figure relating productivity growth and labor force participation just for the US.

![US Only](/assets/figures/2023-06-13-PWT-US-glw5.pdf)

There is no distinct negative relationship here. If anything it is positive, but that fitted line is basically a zero slope and is nowhere close to statistically meaningful. In the US, at least, there is no relationship of labor force participation and productivity growth. 

In general, the conventional wisdom is that US labor markets are more fluid than European ones. *Perhaps* what is going on is that in the US these frictions that create a kind of sorting of higher-skilled individuals into the workforce and lower-skilled individuals out of the workforce are less powerful than in Europe. Hence movements of the labor force participation rate don't track to any kind of meaningful change in productivity growth. 

### Wrapping up
The slowdown in Europe appears to be based on a significant drop in the growth of productivity, offset to a large degree by an increase in growth coming from increased labor force participation. Those two features of recent European economic growth can possibly be reconciled with one another. If productivity growth is picking up changes in average skill level that are not getting measured by the crude human capital data I have, then this is really one larger phenomenon. As European countries expanded labor force participation, they drew in a relatively less skilled (or possibly less experienced?) workforce that lowered measured productivity growth.

This is perhaps another example of how recent growth slowdowns are, in part, unintended consequences of other actions. In the US the unique demographic shifts caused by the Baby Boom (and their subsequent "Baby Bust") created an unintended slowdown. In Europe it may have been an unintended effect of trying to loosen up "sclerotic" labor markets. New workers pulled into the labor force may be relatively less skilled and/or they do not bring along much tacit knowledge from other firms, limiting diffusion of innovations.

Another thing implied by this story is that the productivity slowdown you see in the European data need not be an indicator of some failure to innovate. It's an important reminder that measured productivity growth, $g_{Prod}$ is not a measure of innovation or technological creativity. It's a trash can that contains everything we cannot capture with the measures of physical capital and human capital we have in the data. 
