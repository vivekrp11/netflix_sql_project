--1. Count the number of Movies vs TV Shows

select type, COUNT(*) as content
from netflix_titles
group by type 

--2. Find the most common rating for movies and TV shows

select top 5 type,rating, count(*) as ratings
from netflix_titles
group by type , rating
order by ratings desc

--3. List all movies released in a specific year (e.g., 2020)

select *
from netflix_titles
where release_year = '2020' and type = 'Movie'


--4. Find the top 5 countries with the most content on Netflix

select top 5 value , COUNT(*) as top_country
from netflix_titles
cross apply string_split(country, ',')
group by value
order by  top_country desc

--5. Identify the longest movie
select top 3 show_id, title, cast(value as INT) as max_duration
from netflix_titles
cross apply string_split(duration, ' ')
where type = 'Movie' and TRY_CAST(value as int) is not null
order by max_duration desc
--6. Find content added in the last 5 years

select *
from netflix_titles
where cast(date_added as date) > DATEADD(year , -5 , getdate())
order by date_added desc

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select *
from netflix_titles
where director like  'Rajiv%'

--8. List all TV shows with more than 5 seasons
select *
from netflix_titles
cross apply string_split(duration , ' ')
where type = 'Tv Show' and TRY_CAST( value as int) is not null and value > 5
order by  TRY_CAST( value as int) desc


--9. Count the number of content items in each genre

select top 5 value , COUNT(*) as 'count_of_genre'
from netflix_titles
cross apply string_split(listed_in,',')
group by value
order by count_of_genre desc

--10.Find each year and the average numbers of content release in India on netflix. 


select 
YEAR(date_added) as year_added, 
count(*) as uploads , 
( COUNT(*)*1.0/ (select count(*)
from netflix_titles
where country = 'India'))*100 as avg_per
from netflix_titles
where country = 'India' and YEAR(date_added) is not null
group by YEAR(date_added)
order by avg_per desc


--return top 5 year with highest avg content release!
--11. List all movies that are documentaries
select *
from netflix_titles
where type = 'Movie' and listed_in like '%Documentaries%'

--12. Find all content without a director

select *
from netflix_titles
where director is null

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select *
from netflix_titles
where cast like '%Salman Khan%'
and release_year  > YEAR(GETDATE())-10

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
 select  top 10 value, COUNT(*) as top_actor
 from netflix_titles
 cross apply string_split(cast , ',' )
 where country = 'India'
 group by value
 order by top_actor desc
 
 
--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

select 
catagory , type , count(*)  as content_count
 from(
	select *,
	 case when description like '%kill%'
	 or
	 description like '%violence%'
	 then 'bad_content'
	 else 'good_content'
	 end as catagory
	from netflix_titles) as categorized_content
group by catagory , type


