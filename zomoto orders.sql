
--   shopname is  kfc
select * from portfolioproject.bangalorezomatodata where Shopname ='KFC';

-- averagecost higherthan 500 and is and only veg food

select * from portfolioproject.bangalorezomatodata where AverageCost>500 and isVegOnly =1;
select * from portfolioproject.bangalorezomatodata;
select * from portfolioproject.zomato_kolkata_restaurants;


--  highest order ratings 

select Shopname,Area,DinRatings,DelRatings,
case
	when  DinRatings and DelRatings>=4 then 'perfect'
    when DinRatings and DelRatings>3.5 then 'good'
    else 'its okay'
end as Type_of_order
from portfolioproject.bangalorezomatodata;

-- looking for highest ratings by shopname and cuisines

select shopname,Cuisines,max(dinRatings) as max_dinner_ratings
from portfolioproject.bangalorezomatodata group by shopname,Cuisines order by max_dinner_ratings desc;

-- only nonveg orders

with nonveg as (
	select *,
	case
		when  isVegOnly=1 then 'veg'
		when isVegOnly=0  then 'nonveg'
        end as Type_of_food
	from portfolioproject.bangalorezomatodata
)
select *from nonveg where Type_of_food ='nonveg';

-- only veg orders 
with veg as (
	select *,
	case
		when  isVegOnly=1 then 'veg'
		when isVegOnly=0  then 'nonveg'
        end as Type_of_food
	from portfolioproject.bangalorezomatodata
)
select * from veg where Type_of_food ='veg';

ALTER TABLE portfolioproject.bangalorezomatodata
RENAME COLUMN Area to bangalore_Area ;


-- Number of orders send by each Area in bangalore and highest orders area

select bangalore_Area,count(Orderid) as countorderid
from portfolioproject.bangalorezomatodata p  group by bangalore_Area order by  countorderid desc;

-- Number of orders send by each Area in kolkata and highest orders area

select Area,count(customerid) as countid
from portfolioproject.zomato_kolkata_restaurants z  group by Area order by countid desc;

-- which shop sold maximum non veg in bangalore
with nonveg as (
	select *,
	case
		when  isVegOnly=1 then 'veg'
		when isVegOnly=0  then 'nonveg'
        end as Type_of_food
	from portfolioproject.bangalorezomatodata
)
select shopname,count(orderid) as countorderid from nonveg 
where Type_of_food ='nonveg' group by shopname order by countorderid desc;

-- which shop sold maximum non veg in kolkata
with nonveg_kolkata as (
	select *,
	case
		when  isVegOnly=1 then 'veg'
		when isVegOnly=0  then 'nonveg'
        end as Type_of_food_kolkata
	from portfolioproject.zomato_kolkata_restaurants
)
select shopname,count(customerid) as countcustomerid from nonveg_kolkata
where Type_of_food_kolkata='nonveg' group by shopname order by countcustomerid desc;

-- highest averagecost by each Area in bangalore
select * from (select bangalore_Area,AverageCost,dense_rank() over(partition by bangalore_Area order by AverageCost desc) as densrnk
from portfolioproject.bangalorezomatodata) p where densrnk = 1;

-- second  maximum averagecost in bangalore

select max(AverageCost)from portfolioproject.bangalorezomatodata 
where AverageCost<(select max(AverageCost) from portfolioproject.bangalorezomatodata);

-- Pizza and midnight orders  

select Timing,bangalore_Area,Cuisines,max(AverageCost) over(partition by Cuisines) as maxcost 
from portfolioproject.bangalorezomatodata where Cuisines in  (select Cuisines from portfolioproject.bangalorezomatodata 
where Cuisines like '%Pizza%' and Timing like '%midnight%') order by maxcost desc;

-- sounth indian and midnight orders in koramangala

select Timing,bangalore_Area,Cuisines,max(AverageCost) over(partition by Cuisines) as maxcost 
from portfolioproject.bangalorezomatodata where Cuisines in  (select Cuisines from portfolioproject.bangalorezomatodata 
where Cuisines like '%South Indian%' and Timing like '%midnight%')and bangalore_Area like '%koramangala%' order by maxcost desc;

-- sounth indian orders in salt lake

select Timing,Area,Cuisines,max(AverageCost) over(partition by Cuisines) as maxcost 
from portfolioproject.zomato_kolkata_restaurants where Cuisines in  (select Cuisines from portfolioproject.zomato_kolkata_restaurants
where Cuisines like '%South Indian%')and Area like '%Salt%' order by maxcost desc;

-- maximum averagecost by each shop and highest delivery ratings Areas in bangalore

select * from (select delRatings,Shopname,bangalore_Area,AverageCost,dense_rank() over(partition by Shopname order by AverageCost desc) as densrnk
from portfolioproject.bangalorezomatodata) p where densrnk =1 and DelRatings>4;

-- maximum averagecost by each shop and highest delivery ratings Areas in kolkata

select * from (select delRatings,Shopname,Area,AverageCost,dense_rank() over(partition by Shopname order by AverageCost desc) as densrnk
from portfolioproject.zomato_kolkata_restaurants) z where densrnk =1 and DelRatings>4;
