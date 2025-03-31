-- SQL-Sequence Query Language

SELECT first_name, last_name, email FROM customer;

-- select distinct entries
SELECT DISTINCT rating FROM film; 

-- return nr of distinct ratings from film table - Count uses () mandatory
SELECT  COUNT(DISTINCT rating) FROM film;

SELECT email FROM customer
WHERE first_name ='Nancy'  AND last_name = 'Thomas';

SELECT store_id, first_name,last_name  FROM customer
ORDER BY store_id,first_name 

-- list first 10 customers
SELECT customer_id FROM payment
ORDER BY payment_date
LIMIT 10

SELECT title,length  from film
ORDER BY length ASC
LIMIT 5

SELECT * FROM payment
WHERE payment_date BETWEEN '2007-02-20' AND '2007-02-21';

SELECT * FROM payment
WHERE amount NOT BETWEEN 8 AND 9;

SELECT * FROM payment
WHERE amount IN (0.99, 1.99)

SELECT * FROM customer
WHERE first_name NOT IN ('Marie','Ann')

-- LIKE - case sensitive, ILIKE- case insensitive
--  Wildcard characters: % matches any sequence of characters, _ matches any single character 
-- list all entries with first_name starting with 'J'
SELECT * FROM customer
WHERE first_name LIKE 'J%'
-- list all entries with first_name containing one character followed by 'her' and any sequence
SELECT * FROM customer
Where first_name LIKE '_her%'

-- MIN/MAX/AVG/SUM)
SELECT MIN(replacement_cost) FROM film 
-- ROUND- rotunjeste raspunsul la valoarea specificata dupa virgula (exe: 3 decimale)
SELECT ROUND(AVG(replacement_cost),3) FROM film 

-- GROUP BY
SELECT customer_id,staff_id,SUM(amount) FROM payment
GROUP BY staff_id, customer_id
ORDER BY customer_id

SELECT staff_id, COUNT(amount) FROM payment
GROUP BY staff_id

-- HAVING - filtreaza rezultatele dupa ce s-a facut gruparea 
SELECT customer_id, COUNT(payment_id) FROM payment
GROUP BY customer_id 
HAVING COUNT(payment_id) >= 40

SELECT customer_id, staff_id,SUM(amount) FROM payment
WHERE staff_id=2
GROUP BY customer_id, staff_id 
HAVING SUM(amount) >= 100

-- INNER JOIN - matching of entries in both tables
-- An INNER JOIN will result with the set of records that match in both tables.
SELECT payment_id, payment.customer_id, first_name
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id

-- FULL OUTER JOIN 
-- A FULL OUTER JOIN will result in the set of all records in both tables.
SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IS null 
OR payment.payment_id IS null

-- LEFT JOIN
-- A LEFT OUTER JOIN results in the set of records that are in the left table, 
if there is no match with the right table, the results are null.
SELECT film.film_id, title,inventory_id,store_id 
FROM film
LEFT JOIN inventory
ON inventory.film_id = film.film_id

SELECT  district,email FROM customer
LEFT JOIN address
ON customer.address_id = address.address_id
WHERE address.district= 'California'

SELECT film.title, actor.first_name, actor.last_name FROM actor
INNER JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
INNER JOIN  film
ON film.film_id=film_actor.film_id
WHERE actor.first_name= 'Nick' AND actor.last_name = 'Wahlberg'

SELECT EXTRACT(YEAR FROM payment_date) from payment

SELECT DISTINCT TO_CHAR(payment_date,'MONTH')  FROM payment
WHERE amount > 0.1

-- concatenation and adding space between fisrt and last name
SELECT first_name || ' ' || last_name from customer

-- subquery - is executed first
SELECT title,rental_rate FROM Film
WHERE rental_rate>(SELECT AVG(rental_rate) FROM film)

SELECT film_id, title FROM film
WHERE film_id IN 
(SELECT inventory.film_id FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')

SELECT facid,SUM(slots) FROM cd.bookings
WHERE starttime >=  '2012-09-01' AND starttime <=  '2012-10-01'
GROUP BY facid ORDER BY SUM(slots)

-- create TABLE - 
CREATE TABLE job(
	job_id SERIAL PRIMARY KEY, 
	job_name VARCHAR(200) UNIQUE NOT NULL
)
-- create table and relation with other table 
CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id)
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP
)
-- insert into table
INSERT INTO account (username, password, email, created_on)
VALUES
('Jose', 'password','jose@email.com', CURRENT_TIMESTAMP)

-- update table
UPDATE account
SET last_login = CURRENT_TIMESTAMP

-- update based on results from another table (UPDATE JOIN)
UPDATE account_job
SET hire_date = account.created_on
FROM account
WHERE account_job.user_id=account.user_id

-- delete row in table
DELETE FROM  job 
WHERE job_name = 'cici'
RETURNING job_id, job_name -- return rows that are deleted

-- rename table
ALTER TABLE job
RENAME TO new_job

-- rename column in table
ALTER TABLE account
RENAME COLUMN username TO people

-- CASE
SELECT customer_id,
CASE
	WHEN (customer_id <= 100) THEN 'Premium'
	WHEN (customer_id BETWEEN 100 and 200) THEN 'Plus'
	ELSE 'Normal'
END
FROM customer

-- Write a query that will give the number of times each user logged in within 
-- their first week of registration (i.e. within 7 days after registering for the site)
	
SELECT Registrations.id, count(Registrations.id) FROM Registrations
INNER JOIN Logins
ON Registrations.id = Logins.id
WHERE abs(date(Registrations.date)-date(Logins.date)) < 7
GROUP BY Registrations.id

