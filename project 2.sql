

select top 1 title,(first_name +' ' +last_name) as name,hire_date
from employee
order by hire_date asc

--------------------------------------------------

select * from invoice

select billing_country,count(billing_country) as country 
from invoice 
group by billing_country 
order by country desc

--------------------------------------------------

select * from invoice

select top 3 total from invoice order by total desc

--------------------------------------------------

select * from invoice

select top 5 billing_city,round(sum(total),2) as total 
from invoice 
group by billing_city 
order by total desc

---------------------------------------------

select * from customer
select * from invoice
select * from invoice_line

select top 1 c.customer_id,c.first_name+' '+c.last_name as name,sum(i.total) as total
from customer as c join invoice as i
on c.customer_id=i.customer_id
group by c.customer_id,first_name,last_name
order by total desc

---------------------------------------------


select * from customer
select * from genre

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

select * from artist
select * from album2
select * from track
select * from playlist_track
select * from playlist

select al.artist_id,a.name,count(al.artist_id) as songs_made
from artist as a 
join album2 as al
on a.artist_id=al.artist_id
group by al.artist_id,a.name
order by songs_made desc

------------------------------------------

select * from track

select name,milliseconds
from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc

-------------------------------------------


select * from artist
select * from customer
select * from invoice
select * from invoice_line

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

select * from customer 
select * from genre
select * from invoice
select * from invoice_line

with gen as (
select c.country,gl.name,round(sum(il.unit_price),2) as total
from customer as c 
join invoice as i
on c.customer_id=i.customer_id
join invoice_line as il
on il.invoice_id=i.invoice_id
join track as t
on t.track_id=il.track_id
join genre as gl
on gl.genre_id=t.genre_id
group by c.country,gl.name
)
select *,rank() over(partition by country order by total) as ranking from gen order by ranking desc
