------------------------------------set 1 easy ---------------------------

Q1. who is the senior most employee based on the job title ?

select * from employee
order by levels desc 
limit 1

Q2.which countries have the most invoices ?

select * from invoice
select count (*) as c , billing_country
from invoice
group by billing_country
order by c desc 

Q3. what are the top three vlues of invoice ?

select * from invoice
select total from invoice
order by total desc
limit 3 

Q4. which city has the best customers? we would like to throw a promotional music festival in the city we made the most money.
    write a query that returns one city that has the highest sum of invoice totals.return both the city name & sum of ALL invoice totals ?
	
	select * from invoice
	select sum(total) as invoice_total,billing_city 
	from invoice
	group by billing_city 
	order by  invoice_total desc
	
Q5.  who is the best customer? the customer who has spent the most money will be declared the best customer.
     write a query that returns the person who has the most money?	
	 
	 select * from customer
	 select customer.customer_id,customer.first_name,customer.last_name, sum(invoice.total) as total
	 from customer
	 join invoice on customer.customer_id = invoice.customer_id
	 group by customer.customer_id
	 order by total desc
	 limit 1 
	 
	 ------------------------------------set 2 moderate  ---------------------------
	 
Q1.   write query to return the email,first name, last name,& gerne of all rock music listeners. return your list ordered
      alphabetically by email starting with A?
	  
	  select distinct email,first_name,last_name
	  from customer
	  join invoice on customer.customer_id = invoice.customer_id
	  join invoice_line on invoice.invoice_id = invoice_line.invoice_id
	  where track_id in (
		  select track_id from track
	      join genre on track.genre_id = genre.genre_id
	       where genre.name like 'Rock'
		)
		order by email;
		
Q2.   lets invite the artists who have written the most rock music in our dataset.
      write a query that returns the artist name and total track count of the top 10 rock band? 
	  
	  select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
	  from track 
	  join album on album.album_id = track.album_id
	  join artist on artist.artist_id = album.artist_id
	  join genre on genre.genre_id = track.genre_id
	  where genre.name like 'Rock'
	  group by artist.artist_id
	  order by number_of_songs desc
	  limit 10;
	  
	  
Q3.   return all the track names that have a song lenght longer then the average song length.
      Return the name and milliseconds for the each track .order by the song length with the longest songs listed first ?
	  
	  select name,milliseconds
	  from track
	  where milliseconds > (
	    select avg(milliseconds) as Avg_track_length
	    from track)
	  order by milliseconds desc;
	  
	  
	 	 ------------------------------------set 3 advance  ---------------------------
       
Q1.   find how much amount spent by each customer on artist? write a query to return customer name, artist name and total spent ?

      with best_selling_artist as (
		    select artist.artist_id as artist_id, artist.name as artist_name,
	        sum (invoice_line.unit_price*invoice_line.quantity) as total_sales
		    from invoice_line
	    	join track on track.track_id = invoice_line.track_id
	    	join album on album.album_id = track.album_id
	    	join artist on artist.artist_id = album.artist_id
		    group by 1 
            order by 3 desc 
		    limit 1
	)
       
	   select customer.customer_id,customer.first_name,customer.last_name,best_selling_artist.artist_name, 
	   sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
	   from invoice
	   join customer on customer.customer_id = invoice.customer_id
	   join invoice_line on invoice_line.invoice_id = invoice.invoice_id
	   join track  on track.track_id = invoice_line.track_id
	   join album on album.album_id = track.album_id
	   join best_selling_artist on best_selling_artist.artist_id = album.artist_id
	   group by 1,2,3,4
	   order by 5 desc;


Q2.    we want to find out the most popular music genre for each country. we determine the most popular genre as the genre with the highest 
       amount of purchases. write a query that returns each country along with the top genre. for countries where the maximum number of 
	   purchases is shared return all genre ?
	   
	   with popular_genre as 
	   (
	          select count(invoice_line.quantity) as purchases, customer.country,genre.name,genre.genre_id,
	              row_number() over(partition by customer.country order by count(invoice_line.quantity) desc)as rowno
	           from invoice_line
	                 join invoice on invoice.invoice_id = invoice_line.invoice_id
	                 join customer on customer.customer_id= invoice.customer_id
	                 join track on track.track_id = invoice_line.track_id
	                 join genre on genre.genre_id = track.genre_id
	                 group by 2,3,4
	                 order by 2 asc,1 desc
	    )
		select * from popular_genre where rowno <=1
		


  
Q3.         Write a query that determines the customer that has spent the most on music for each country. 
            Write a query that returns the country along with the top customer and how much they spent. 
             For countries where the top amount spent is shared, provide all customers who spent this amount.
			 
			 
			 with  customer_with_country as (
			          select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
			           row_number() over(partition by billing_country order by sum(total) desc )as rowno
			            from invoice
			            join customer on customer.customer_id = invoice.customer_id
			            group by 1,2,3,4
			            order by 4 asc,5 desc)
				select *from customer_with_country where rowno <= 1		
			 
			 
			 

