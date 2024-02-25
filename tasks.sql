-- TASK 1: Using any type of the joins create a view that combines multiple tables in a logical way 

-- VIEW 1: In DB I created separate tables Customers and Customer_addresss in order to normalise 
-- and to reduce data redundancy. I created a view contact_details to see all customer details in one virtual table. 
CREATE VIEW contact_details AS
    SELECT
   	 c.customer_ID AS customer_ID,
   	 c.FirstName AS first_name,
   	 c.LastName AS last_name,
   	 c.email AS email,
   	 c.phone_number AS phone,
   	 a.house_number AS house_number,
     a.street AS street,
   	 a.city AS city,
     a.post_code AS postcode,
   	 a.country AS country
    FROM
   	 customers AS c
    LEFT JOIN
   	 customer_addresses AS a ON c.address_ID = a.address_ID;

SELECT * FROM contact_details;

-- VIEW 2: Adds room details onto room bookings. The SQL query creates a view named rooms_booked_details. 
-- This view combines information from several tables: rooms_booked, rooms, bookings, and customers. 
-- It retrieves details such as customer names, phone numbers, room IDs, room types, check-in and check-out dates, 
-- number of nights stayed, room rates, and total prices for each booking. 
-- The results are ordered by the room_booked_ID.

CREATE VIEW rooms_booked_details AS
    SELECT
   	 room_booked_ID AS room_booked_ID,
   	 c.FirstName,
   	 c.LastName,
   	 c.phone_number,
   	 r.room_ID,
   	 r.room_type,
   	 room_bk.check_in,
   	 room_bk.check_out,
   	 room_bk.nights AS nights,
   	 r.rate,
   	 room_bk.nights * r.rate AS total_price,
     room_bk.booking_ID
    FROM
   	 rooms_booked AS room_bk
    INNER JOIN
   	 rooms AS r
   	 ON r.room_ID = room_bk.room_ID
    INNER JOIN
   	 bookings AS b
   	 ON b.booking_ID = room_bk.booking_ID
    INNER JOIN
   	 customers AS c
   	 ON c.customer_ID = b.customer_ID
    ORDER BY
   	 room_booked_ID;

SELECT * FROM rooms_booked_details; 

-- TASK 2: In your DB create stored function that can be applied to a query in your DB
-- EXAMPLE 1: I would like to give 5% off to all my customers. In order to do that I created stored function
-- discount_price to find the price customer needs to pay at the end. This function takes 
-- an input amount (of type DECIMAL(5,2)) and calculates the discounted price 
-- by subtracting 5% from the original amount.

DELIMITER //
CREATE FUNCTION discount_price(input_amount DECIMAL(5,2))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE output_amount DECIMAL(5,2);
    SET output_amount = input_amount - 5 / 100 * input_amount;
    RETURN output_amount;
END//
DELIMITER ;

-- EXAMPLE 2: I also created stored function Full_Name. In this example, the function concatenates 
-- the first name and last name to create a full name.
DELIMITER //
CREATE FUNCTION Full_Name (FirstName VARCHAR (50), LastName VARCHAR (50))
RETURNS VARCHAR (100)
DETERMINISTIC
BEGIN
	DECLARE Full_Name VARCHAR (100);
	SET Full_Name = CONCAT(FirstName, ' ' ,LastName);
	RETURN Full_Name;
END//
DELIMITER ;
-- Example:
SELECT
	booking_ID,
    Full_Name(FirstName, LastName) AS Full_Name,
    discount_price(total_price) AS Discount_Price
FROM
    rooms_booked_details AS rbd;

-- TASK 3: Prepare an example query with a subquery to demonstate
-- how to extract data from your DB for analysis

-- EXAMPLE: I would like to find out the first and last names of customers 
-- who booked either Deluxe or Double room in March.
-- This query first finds all the bookings that are for a deluxe or double room and in the month of March. 
-- It then uses these bookings to find the corresponding customers.
SELECT c.FirstName, c.LastName
FROM Customers c
WHERE c.customer_ID IN (
    SELECT b.customer_ID
    FROM Bookings b
    WHERE b.booking_ID IN (
        SELECT rb.booking_ID
        FROM Rooms_booked rb
        JOIN Rooms r ON rb.room_ID = r.room_ID
        WHERE r.room_type IN ('Deluxe', 'Double') AND MONTH(rb.check_in) = 3
    )
);
-- EXAMPLE 2: I would like to know the cities from which customers are coming and have bookings for March.
-- This query first finds all the customer_IDs that have bookings in March 
-- from the Bookings and Rooms_booked tables. It then uses these customer_IDs 
-- to find the corresponding address_IDs from the Customers table. 
-- Finally, it uses these address_IDs to find the cities from the Customer_addresses table.

SELECT ca.city
FROM Customer_addresses ca
WHERE ca.address_ID IN (
    SELECT c.address_ID
    FROM Customers c
    WHERE c.customer_ID IN (
        SELECT b.customer_ID
        FROM Bookings b
        JOIN Rooms_booked rb ON b.booking_ID = rb.booking_ID
        WHERE MONTH(rb.check_in) = 3 OR MONTH(rb.check_out) = 3
    )
);

-- EXAMPLE 3: I would like to calculate the total_revenue for each room_type across all bookings.
-- This query calculates the total revenue for each room type 
-- by executing a subquery for each room in the Rooms table. 
-- The subquery sums up the product of nights and rate for each booking in the Rooms_booked table 
-- where the room_ID matches the room_ID in the Rooms table.
SELECT
    r.room_type,
    (SELECT SUM(rb.nights * r.rate)
     FROM Rooms_booked rb
     WHERE rb.room_ID = r.room_ID) AS total_revenue
FROM Rooms r;

-- EXAMPLE 4: I would like to calcualte the total number of bookings per room type.
-- This query calculates the total number of bookings for each room type by executing a subquery 
-- for each room in the Rooms table. The subquery counts the number of bookings in the Rooms_booked table 
-- where the room_ID matches the room_ID in the Rooms table.
SELECT
    r.room_type,
    (SELECT COUNT(*) FROM Rooms_booked rb WHERE rb.room_ID = r.room_ID) AS total_bookings
FROM Rooms r
ORDER BY total_bookings DESC;

-- TASK 4: In your DB create stored procedure and demonstate how it runs.
-- In this example, the stored procedure GetTotalRevenue calculates the total revenue for each room type 
-- by executing a subquery for each room in the Rooms table.
-- The subquery sums up the product of nights and rate for each booking in the Rooms_booked table 
-- where the room_ID matches the room_ID in the Rooms table.

DELIMITER //
CREATE PROCEDURE GetTotalRevenue()
BEGIN
   SELECT
       r.room_type,
       (SELECT SUM(rb.nights * r.rate)
        FROM Rooms_booked rb
        WHERE rb.room_ID = r.room_ID) AS total_revenue
   FROM Rooms r;
END//
DELIMITER ;

CALL GetTotalRevenue();


-- TASK 5: In your DB create a trigger and demonstate how it runs.
-- In this example, the trigger update_nights is created on the Rooms_booked table. 
-- It’s set to execute before each insert operation on the Rooms_booked table.
-- The operation it performs is to calculate the number of nights based on 
-- the check_in and check_out dates of the new record being inserted.

DELIMITER //
CREATE TRIGGER update_nights
BEFORE INSERT ON rooms_booked
FOR EACH ROW
BEGIN
   SET NEW.nights = DATEDIFF(NEW.check_out, NEW.check_in);
END//
DELIMITER ;

-- to demonstrate how it runs I will insert a new record into the Rooms_booked table
INSERT INTO Rooms_booked (room_booked_ID, room_ID, check_in, check_out, booking_ID)
VALUES (11, 1, '2024-04-01', '2024-04-05', 1);

SELECT * FROM Rooms_booked WHERE room_booked_ID = 11;

DELETE FROM Rooms_booked WHERE room_booked_ID = 11; 
DROP TRIGGER update_nights; 

  -- TASK 6: create a view that uses at least 3-4 base tables; 
  -- prepare and demonstate a query that uses the view to produce a logically arranged result set for analysis
  
  CREATE VIEW customer_bookings AS
    SELECT 
	Full_Name(FirstName, LastName) AS Full_Name,
	r.room_type AS RoomType,
    rb.check_in AS CheckInDate,
    rb.check_out AS CheckOutDate,
    rb.nights AS NightsBooked,
    r.rate AS RoomRate
FROM
    Customers c
JOIN
    Rooms_booked rb ON c.customer_ID = rb.booking_ID
JOIN
    Rooms r ON rb.room_ID = r.room_ID;
    
SELECT * FROM customer_bookings; 

--  retrieve all booked rooms along with customer names
SELECT 
Full_Name,  
RoomType, 
CheckInDate, 
CheckOutDate
FROM customer_bookings;

-- find the total cost for each booking:
SELECT 
Full_Name, 
RoomType, 
NightsBooked * RoomRate AS TotalCost
FROM customer_bookings;

  -- TASK 8: prepare an example query with group by and having to demonstrate how to extract data for analysis
  -- EXAMPLE: query written calculates the total revenue for each room type where the total revenue exceeds £1000. 
  -- It joins the Rooms table with the Rooms_booked table based on the room_ID and calculates the revenue
  -- by multiplying the number of nights (rb.nights) by the rate (r.rate) for each booking. 
  -- The results are grouped by room_type. 
  SELECT
    r.room_type,
    SUM(rb.nights * r.rate) AS total_revenue
FROM
    Rooms r
JOIN
    Rooms_booked rb ON r.room_ID = rb.room_ID
GROUP BY
    r.room_type
HAVING
    total_revenue > 1000; 