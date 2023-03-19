Select * from Project3.dbo.Data1;
Select * from Project3.dbo.Data2;

--number of rows into dataset

Select count(*) from Project3.dbo.Data1;
Select count(*) from Project3.dbo.Data2;

--Dataset for Andhra Pradesh and Telengana

Select * from Project3.dbo.Data1 where State in ('Andhra Pradesh','Tamil Nadu');
Select * from Project3.dbo.Data2 where State in ('Andhra Pradesh','Tamil Nadu');

--Population of India

Select SUM(Population) Total_Population from Project3.dbo.Data2

--Average Growth percentage of India

Select avg(growth)*100 avg_growth_perc from Project3.dbo.Data1

--Average Growth percentage of States

Select state,round(avg(growth)*100,2) avg_growth_perc from Project3.dbo.Data1 group by State;

--Average sex ratio of States

Select state,round(avg(Sex_Ratio),0) avg_sex_ratio from Project3.dbo.Data1 group by State order by avg_sex_ratio desc;

--Average literacy rate of States

Select state,round(avg(literacy),0) avg_literacy_rate from Project3.dbo.Data1 
group by State 
having round(avg(literacy),0)>90
order by avg_literacy_rate desc;

--Top 3 States showing highest growth rate

Select top 3 state,round(avg(growth)*100,2) avg_growth_perc from Project3.dbo.Data1 group by State order by avg_growth_perc desc;
Select state,round(avg(growth)*100,2) avg_growth_perc from Project3.dbo.Data1 group by State order by avg_growth_perc desc limit 3;

--Bottom 3 States lowest sex ratio

Select top 3 State,round(avg(Sex_Ratio),0) avg_sex_ratio from Project3.dbo.Data1 group by State order by avg_sex_ratio;

--Top and bottom 3 States in literacy rate

drop table if exists #topstates
create table #topstates
(State nvarchar(255),
 avg_literacyrate float
 )

 insert into #topstates
Select state,round(avg(literacy),0) avg_literacy_rate from Project3.dbo.Data1 
group by State 
order by avg_literacy_rate desc;

Select * from #topstates order by avg_literacyrate desc;

drop table if exists #bottomstates
create table #bottomstates
(State nvarchar(255),
 avg_literacyrate float
 )

 insert into #bottomstates
Select state,round(avg(literacy),0) avg_literacy_rate from Project3.dbo.Data1 
group by State 
order by avg_literacy_rate desc;

Select * from #bottomstates order by avg_literacyrate;

--UNION

select * from (Select top 3 * from #topstates order by avg_literacyrate desc)a
Union
select * from (Select top 3 * from #bottomstates order by avg_literacyrate)b
order by avg_literacyrate;

--States Starting with 'A'

Select distinct(State) from Project3.dbo.Data1 where State like 'A%';

--States Starting with 'A' and ending with 'M'

Select distinct(State) from Project3.dbo.Data1 where State like 'A%' and State like '%m' ;

--JOINING TABLES

--Total males and Total Females

Select State, sum(males) total_males, sum(females) total_females from
(Select district, State, round(c.Population*1000/(c.Sex_Ratio+1),0) males, round((c.Population*c.Sex_Ratio)/(c.Sex_Ratio+1),0) females
from
(Select D1.*,D2.Area_km2,D2.Population 
from Project3.dbo.Data1 D1
join Project3.dbo.Data2 D2
on D1.District=D2.District)c)d
group by State;

--Total Population Literacy

Select State, sum(round(c.Population*c.Literacy/100,0)) literates, sum(round(c.Population*(100-c.Literacy)/100,0)) Illiterates
from
(Select D1.*,D2.Area_km2,D2.Population 
from Project3.dbo.Data1 D1
join Project3.dbo.Data2 D2
on D1.District=D2.District)c
group by State;


-- Population in previous Census

Select State, sum(round(c.Population/(1+c.Growth),0)) PreviousCensusPopulation,sum(round(c.Population,0)) CurrentCensusPopulation
from
(Select D1.*,D2.Area_km2,D2.Population 
from Project3.dbo.Data1 D1
join Project3.dbo.Data2 D2
on D1.District=D2.District)c
group by State;

--Population Density (Population/Area)

Select q.TotalPreviousCensusPopulation/q.TotalArea PreviousPopDensity,q.TotalCurrentCensusPopulation/q.TotalArea CurrentPopDensity from
(Select sum(p.PreviousCensusPopulation) TotalPreviousCensusPopulation, sum(p.CurrentCensusPopulation) TotalCurrentCensusPopulation,sum(p.Area_km2) TotalArea from
(Select State, sum(round(c.Population/(1+c.Growth),0)) PreviousCensusPopulation,sum(round(c.Population,0)) CurrentCensusPopulation,c.Area_km2
from
(Select D1.*,D2.Area_km2,D2.Population 
from Project3.dbo.Data1 D1
join Project3.dbo.Data2 D2
on D1.District=D2.District)c
group by State, Area_km2)p)q;

--Window Function

--Output top 3 districts from each State with highest Literacy Rate

Select x.* from
(Select District,State,Literacy,rank()over(partition by State order by Literacy desc) rnk from Project3..Data1)x
where x.rnk in(1,2,3);


------------------------------------

