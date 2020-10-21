
## Lab | SQL Advanced queries

use sakila;
SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

#1. List each pair of actors that have worked together.

select a2.film_id, a1.actor_id, 
concat(a1.first_name,' ',a1.last_name) as Name_1, 
a4.actor_id, concat(a4.first_name,' ',a4.last_name) as Name_2
from sakila.actor a1
inner join sakila.film_actor a2
on a1.actor_id = a2.actor_id
inner join sakila.film_actor a3
on a3.film_id=a2.film_id and a3.actor_id!=a2.actor_id
inner join sakila.actor a4
on a4.actor_id=a3.actor_id
order by a2.film_id, a1.actor_id, 
concat(a1.first_name,' ',a1.last_name), 
a4.actor_id, concat(a4.first_name,' ',a4.last_name);

#2. For each film, list actor that has acted in more films.
 
select c.film_id as Film_ID, c.title as Title, a.actor_id as Actor_ID, 
dense_rank() over (partition by c.film_id order by a.actor_id desc) as Ranking, 
concat(a.first_name,' ',a.last_name) as Full_Name 
from sakila.actor as a 
join (select actor_id, film_id 
from sakila.film_actor) as b
on b.actor_id=a.actor_id
join (SELECT film_id, title 
FROM sakila.film) as c 
on c.film_id = b.film_id
group by c.film_id, a.actor_id 
order by c.film_id;

#to verify the top actor per movie
select actor_id, dense_rank() over (partition by film_id order by actor_id desc) as Ranking from sakila.film_actor order by Ranking;

