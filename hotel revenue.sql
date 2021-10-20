--combine all tables together
with hotels as (
select * from [PortfolioProject].[dbo].[2018]
union
select * from [PortfolioProject].[dbo].[2019]
union
select * from [PortfolioProject].[dbo].[2020])

select * from hotels
left join PortfolioProject.dbo.market_segment
on hotels.market_segment = PortfolioProject.dbo.market_segment.market_segment
left join PortfolioProject.dbo.meal_cost
on PortfolioProject.dbo.meal_cost.meal =hotels.meal







--revenue growth per year and by hotel type
with hotels as (
select * from [PortfolioProject].[dbo].[2018]
union
select * from [PortfolioProject].[dbo].[2019]
union
select * from [PortfolioProject].[dbo].[2020])

select
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue 
from hotels
group by arrival_date_year,hotel



--join market_segment and meal from market_segment table and meal_cost table
with hotels as (
select * from [PortfolioProject].[dbo].[2018]
union
select * from [PortfolioProject].[dbo].[2019]
union
select * from [PortfolioProject].[dbo].[2020])

select * from hotels
left join PortfolioProject.dbo.market_segment
on hotels.market_segment = PortfolioProject.dbo.market_segment.market_segment
left join PortfolioProject.dbo.meal_cost
on PortfolioProject.dbo.meal_cost.meal =hotels.meal
