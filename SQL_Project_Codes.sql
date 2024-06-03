----------------------------------------
/* 1. Who is the senior most employee based on the job title? */

select top 1 title,(first_name +' ' +last_name) as name,hire_date
from employee
order by hire_date asc

--------------------------------------------------
/* 2. Which countries have the most invoices? Order in Desc mode. */

select billing_country,count(billing_country) as country 
from invoice 
group by billing_country 
order by country desc

--------------------------------------------------
/* 3. What are the top 3 values of the total invoice? */

select top 3 total from invoice order by total desc

--------------------------------------------------
/* 4. Which city has the best customer? We would like to throw a promotional Music 
Festival in the city where made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals. */

select top 5 billing_city,round(sum(total),2) as total 
from invoice 
group by billing_city 
order by total desc

---------------------------------------------
/* 5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money. */

select top 1 c.customer_id,c.first_name+' '+c.last_name as name,sum(i.total) as total
from customer as c join invoice as i
on c.customer_id=i.customer_id
group by c.customer_id,first_name,last_name
order by total desc

---------------------------------------------
/* 6. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A. */

select (c.first_name+' '+c.last_name) as Full_Name,c.email,g.name
from customer as c
join invoice as i
on  c.customer_id=i.customer_id
join invoice_line as il
on il.invoice_id=i.invoice_id
join track as t
on t.track_id=il.track_id
join genre as g
on t.track_id=g.genre_id
where g.name like 'rock'
order by c.first_name

----------------------------------------------------
/* 7. Lets invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands. */

select al.artist_id,a.name,count(al.artist_id) as songs_made
from artist as a 
join album2 as al
on a.artist_id=al.artist_id
group by al.artist_id,a.name
order by songs_made desc

------------------------------------------
/* 8. Return all the track names that have a song length longer than the average song 
length. Return the Name and Milliseconds for each track. Order by the song length 
with the longest songs listed first. */

select name,milliseconds
from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc

-------------------------------------------
/* 9. Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent. */

select il.invoice_id,c.first_name,a.name as artist_name,round(sum(il.unit_price),2) as total 
from invoice_line as il
join invoice as i
on il.invoice_id=i.invoice_id
join customer as c on 
c.customer_id=i.customer_id
join track as t
on t.track_id=il.track_id
join album as al
on al.album_id=t.album_id
join artist as a
on a.artist_id=al.artist_id
group by il.invoice_id,c.first_name,a.name
order by total desc

---------------------------------------------
/* 10.We want to find out the most popular music Genre for each country. We determine 
the most popular genre as the genre with the highest number of purchases. Write a 
query that returns each country along with the top Genre. For countries where the 
maximum number of purchases is shared return all Genres. */

select country,name from (select c.country,gl.name,round(sum(il.unit_price),2) as total,
rank() over(partition by country order by round(sum(il.unit_price),2)desc) as ranking
from customer as c 
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on il.invoice_id=i.invoice_id
join track as t
on t.track_id=il.track_id
join genre as gl
on gl.genre_id=t.genre_id
group by c.country,gl.name)as query
where ranking=1


-------------------------------------------------
/* 11.Write a query that determines the customer that has spent the most on music for 
each country. Write a query that returns the country along with the top customer and 
how much they spent. For countries where the top amount spent is shared, provide 
all customers who spent this amount. */

select country,first_name,last_name,total_spent from(select c.country,c.first_name,c.last_name,round(sum(il.unit_price*il.quantity),2) as total_spent,
rank() over(partition by c.country order by round(sum(il.unit_price*il.quantity),2) desc) as con_rank
from customer as c 
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on il.invoice_id=i.invoice_id
group by country,first_name,last_name) as query
where con_rank=1
order by total_spent desc
