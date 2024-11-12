# Netflix Movies and Tv-Shows analysis using SQL
![Netflix Logo](https://github.com/vivekrp11/netflix_sql_project/blob/main/logo.png)


## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql

select type, COUNT(*) as content
from netflix_titles
group by type 
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
select top 5 type,rating, count(*) as ratings
from netflix_titles
group by type , rating
order by ratings desc

```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select *
from netflix_titles
where release_year = '2020' and type = 'Movie'


```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select top 5 value , COUNT(*) as top_country
from netflix_titles
cross apply string_split(country, ',')
group by value
order by  top_country desc
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
select top 3 show_id, title, cast(value as INT) as max_duration
from netflix_titles
cross apply string_split(duration, ' ')
where type = 'Movie' and TRY_CAST(value as int) is not null
order by max_duration desc

```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
select *
from netflix_titles
where cast(date_added as date) > DATEADD(year , -5 , getdate())
order by date_added desc
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select *
from netflix_titles
where director like  'Rajiv%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select *
from netflix_titles
cross apply string_split(duration , ' ')
where type = 'Tv Show' and TRY_CAST( value as int) is not null and value > 5
order by  TRY_CAST( value as int) desc
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select top 5 value , COUNT(*) as 'count_of_genre'
from netflix_titles
cross apply string_split(listed_in,',')
group by value
order by count_of_genre desc
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select *
from netflix_titles
where type = 'Movie' and listed_in like '%Documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select *
from netflix_titles
where director is null
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select *
from netflix_titles
where cast like '%Salman Khan%'
and release_year  > YEAR(GETDATE())-10
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
 select  top 10 value, COUNT(*) as top_actor
 from netflix_titles
 cross apply string_split(cast , ',' )
 where country = 'India'
 group by value
 order by top_actor desc
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
