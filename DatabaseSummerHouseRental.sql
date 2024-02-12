CREATE DATABASE Summer_House_Rental; 
USE Summer_House_Rental;

CREATE TABLE Customers (
customer_ID INTEGER NOT NULL AUTO_INCREMENT,
FirstName VARCHAR (50),
LastName VARCHAR (50),
phone_number VARCHAR (50) NOT NULL,
email VARCHAR (50),
address_ID INTEGER NOT NULL,
CONSTRAINT PK_Customers PRIMARY KEY (customer_ID),
FOREIGN KEY (address_ID) REFERENCES customer_addresses(address_ID)
);

CREATE TABLE Customer_addresses (
address_ID INTEGER NOT NULL AUTO_INCREMENT,
house_number varchar(55) NOT NULL,
street VARCHAR(55) NOT NULL,
city VARCHAR(55),
post_code VARCHAR(55) NOT NULL,
country VARCHAR(55),
CONSTRAINT PK_Customer_addresses PRIMARY KEY (address_ID)
);

CREATE TABLE Rooms (
room_ID INTEGER NOT NULL AUTO_INCREMENT,
room_type VARCHAR (50) NOT NULL,
rate INTEGER NOT NULL,
CONSTRAINT PK_Rooms PRIMARY KEY (room_ID) 
);

CREATE TABLE Bookings (
booking_ID INTEGER NOT NULL AUTO_INCREMENT,
date_booked DATE,
customer_ID INTEGER NOT NULL,
CONSTRAINT PK_Bookings PRIMARY KEY (booking_ID),
FOREIGN KEY (customer_ID) REFERENCES Customers(customer_ID)
);

CREATE TABLE Rooms_booked (
room_booked_ID INTEGER NOT NULL AUTO_INCREMENT,
room_ID INTEGER NOT NULL,
check_in DATE,
check_out DATE, 
nights INTEGER NOT NULL,
booking_ID INTEGER NOT NULL,
CONSTRAINT PK_Rooms_booked PRIMARY KEY (room_booked_ID),
FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

UPDATE rooms_booked
SET nights = DATEDIFF(check_out, check_in);

SELECT * FROM Customers;
SELECT * FROM Customer_addresses;
SELECT * FROM Rooms;
SELECT * FROM Bookings;
SELECT * FROM Rooms_booked;