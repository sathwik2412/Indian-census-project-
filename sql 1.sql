use indain_censues;
select * from dataset1;
select * from dataset2;

-- Number of rows in dataset--
select count(*) from dataset1;
select count(*) from dataset2;

-- dataset for jharkhand and bihar
select * from dataset1
where state ="jharkhand" or  state = "bihar";
      -- or--
select * from dataset1 
where state in ('Jharkhand' ,'Bihar');

-- population of India --
 select sum(population) Total_population_in_India 
 from dataset2;

-- avg growth
 select  state,avg(growth)*100 as Avg_growth from dataset1
 group by state ;
 
-- avg sex ratio
Select state ,round(avg(sex_ratio),0) as avg_sex_ratio 
from dataset1
group by state
order by  avg_sex_ratio desc;

-- avg literacy rate

select state , round( avg (literacy),0) as avg_literacy from dataset1
group by state
having avg (literacy)>90 
order by  avg_literacy  desc;

-- top 3 state showing highest growth ratio
   
   select state ,round( avg(growth)*100,0) as growth_ratio  from dataset1
   group by state 
   order by growth_ratio desc 
   limit  3;
   
   -- bottom 3 state showing lowest sex ratio
    select state ,round( avg(sex_ratio)*100,0) as sex_ratio  from dataset1
   group by state 
   order by  sex_ratio asc 
   limit  3;
   
   -- top 3 literacy state and bottom 3 litercay state 
   drop table  if exists topstates ;
   create table topstates
   ( state varchar(255), 
    topstates float
    );
    
   -- Insert average literacy ratios into the table
INSERT INTO topstates 
select state , round( avg (literacy),0) as avg_literacy from dataset1
group by state
order by  avg_literacy  desc;

select * from topstates 
order by state desc
limit 3 ; 

 drop table  if exists bottomstates;
 create table bottomstates
   ( state varchar(255), 
    bottomstates float
    );
    
   
INSERT INTO bottomstates 
select state , round( avg (literacy),0) as avg_literacy from dataset1
group by state
order by  avg_literacy  desc;

select * from bottomstates 
order by state desc
limit 3 ;

-- final result of top and bootom 

select * from 
( select * from topstates 
order by state desc
limit 3 ) a 

union 
 
 select * from 
(select * from bottomstates 
order by state asc
limit 3 ) b;


-- joining  both table 



SELECT d.state, sum(d.males) as Total_males, sum(d.females) as Total_females FROM 
(SELECT c.district, c.state, round(c.population/(c.sex_ratio + 1), 0) males, round((c.population*c.sex_ratio)/(c.sex_ratio + 1), 0) as Females FROM
(SELECT a.district, a.state, a.sex_ratio/1000  Sex_Ratio, b.population FROM dataset1 as a
INNER JOIN dataset2 as b
ON a.district = b.district) as c) as d
GROUP BY d.state;

-- total litercay rate 
 
 SELECT c.State, sum(Literate_People) as Total_Literate_People, sum(illiterate_people) as Total_Illiterate_People FROM
(SELECT d.district, d.State, round(d.Literacy_ratio* d.Population, 0) as Literate_People, round((1-d.Literacy_Ratio)* d.Population, 0) as Illiterate_People FROM
(SELECT a.district, a.State, a.Literacy/ 100 as Literacy_Ratio, b.Population FROM dataset1 AS a
INNER JOIN dataset2 as b
ON a.district = b.district) as d) AS c
GROUP BY c.State;
 
 





