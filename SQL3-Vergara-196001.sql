-- Vergara, Sebastian
-- 196001
-- May 16, 2021

-- I have not discussed the SQL code in my program
-- with anyone other than my instructor or the teaching assistants
-- assigned to this course.

-- I have not used SQL code obtained from another student,
-- or any other unauthorized source, either modified or unmodified.

-- If any SQL code or documentation used in my program
-- was obtained from another source, such as a textbook or website,
-- that has been clearly noted with a proper citation in the comments
-- of my program.

-- SELECT Statements

-- What is the title of the most expensive (in retail price) computer book?
SELECT title AS Title, MAX(retail) AS Price, 
		name AS 'Publisher Name' 
FROM book 
INNER JOIN publisher ON book.pubid = publisher.pubid 
WHERE category = 'Computer' 
GROUP BY title, name 
ORDER BY title DESC 
LIMIT 1;

-- Which customers referred other customers?
SELECT DISTINCT customerno AS 'Customer Number', 
       CONCAT(firstname, ' ', lastname) AS 'Customer Name'
FROM customer 
WHERE customerno IN
	(
	SELECT referredby 
	FROM customer
	WHERE referredby IS NOT NULL
	);


-- Which books were priced higher than the average price?
SELECT isbn AS ISBN, title AS 'Book Title',
	   name AS Publisher,
	   retail AS Retail_Price 
FROM book 
INNER JOIN publisher ON book.pubid = publisher.pubid
WHERE retail > 
	   (
	   SELECT AVG(retail) 
	   FROM book)
	   ;

-- What titles did Bonita Morales buy?
SELECT isbn AS ISBN,
	   title AS 'Book Title',
	   retail AS 'Retail Price'
FROM book
WHERE isbn IN 
	   (
	   SELECT isbn 
	   FROM orderitem 
	   WHERE orderno IN 
	   (
	   SELECT orderno
	   FROM orders
	   WHERE customerno = 
	   (
	   SELECT customerno
	   FROM customer
	   WHERE lastname = 'MORALES'
	   ))) 
ORDER BY title ASC;

-- Who published the books written by the author named Tamara Kzochsky?
SELECT title,
       category,
       name,
       contact,
       phone
FROM book 
INNER JOIN publisher ON book.pubid = publisher.pubid
WHERE isbn =
	   (
	   SELECT isbn
	   FROM bookauthor
	   WHERE authorid =
	   (
	   SELECT authorid
	   FROM author
	   WHERE lname = 'KZOCHSKY' 
	   AND fname = 'TAMARA'
	   )); 

-- Which books that were published by the publisher of the book "Big Bear and Little Dove" generate more profit than the average profit from all books?
SELECT isbn AS ISBN,
	   title,
	   category
FROM book
WHERE pubid = 
	   (
	   SELECT pubid
	   FROM book
	   WHERE title = 'BIG BEAR AND LITTLE DOVE'
	   ) 
	   AND retail > 
	   (
	   SELECT AVG(retail - cost) 
	   FROM book
	   ); 

-- Which books are more expensive than the most expensive cooking book?
SELECT isbn AS ISBN,
       title,
       category,
       retail 
FROM book
WHERE retail > 
	   (
	   SELECT MAX(retail)
	   FROM book
	   WHERE category = 'Cooking'
	   );

-- Which books have not been ordered at all?
SELECT isbn AS ISBN,
	   title,
	   category,
	   retail
FROM book
WHERE isbn 
NOT IN 
	   (
	   SELECT isbn
	   FROM orderitem
	   );


-- Determine which orders were shipped to the same state as the orders of Steve Schell.
SELECT orderno AS 'Order Number',
	   shipdate AS 'Date of Shipping',
	   CONCAT(firstname, ' ', lastname) AS 'Customer Name'
FROM orders 
LEFT JOIN customer ON orders.customerno = customer.customerno 
WHERE shipstate = 
	   (
	   SELECT statename
	   FROM customer
	   WHERE lastname = 'SCHELL'
	   AND firstname = 'STEVE'
	   ) 
	   AND lastname != 'SCHELL'
	   AND firstname != 'STEVE'
	   ;

-- List the customers who placed orders for the least expensive books carried by the bookstore.
SELECT CONCAT(firstname, ' ', lastname)AS "Customer's Name", 
	   statename AS State 
FROM customer
WHERE customerno IN 
	   (
	   SELECT customerno
	   FROM orders
	   WHERE orderno IN 
	   (
	   SELECT orderno
	   FROM orderitem
	   WHERE isbn = 
	   (
	   SELECT isbn
	   FROM book
	   WHERE retail =
	   (
	   SELECT MIN(retail) 
	   FROM book
	   ))));

-- How many books are in each category and what is the combined retail price of all the books in each category. Show only those groups with a combined retail price greater than 50.
SELECT category, 
	   COUNT(category) AS Total,
	   SUM(retail) AS 'Combined Retail'
FROM book
GROUP BY category
HAVING SUM(retail) > 50;

-- How many items were in each order made by the customer named Tammy Giana?
SELECT orderno,
	   SUM(quantity) 
FROM orderitem
GROUP BY orderno
HAVING orderno IN 
	   (
	   SELECT orderno
	   FROM orders
	   WHERE customerno = 
	   (
	   SELECT customerno
	   FROM customer
	   WHERE lastname = 'GIANA'
	   ));

