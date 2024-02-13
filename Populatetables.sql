-- populate tables for Summer_House_Rental database 

 INSERT INTO Customer_addresses (address_ID, house_number, street, city, post_code, country)
VALUES
    (1, '123', 'Main Street', 'Coventry', 'CV1 1AB', 'United Kingdom'),
    (2, '456', 'Park Avenue', 'Birmingham', 'BB2 2XY', 'United Kingdom'),
    (3, '789', 'High Street', 'Leicester', 'LE1 3CD', 'United Kingdom'),
    (4, '101', 'Broadway', 'London', 'SW1 1AA', 'United Kingdom'),
    (5, '222', 'Oak Lane', 'Manchester', 'MA1 4DE', 'United Kingdom'),
    (6, '333', 'Elm Street', 'Liverpool', 'LS3 5FG', 'United Kingdom'),
    (7, '444', 'Grove Road', 'Sheffield', 'SR1 6HI', 'United Kingdom'),
    (8, '555', 'Crescent Avenue', 'Nottingham', 'NG1 7JK', 'United Kingdom'),
    (9, '666', 'Maple Drive', 'Leeds', 'LS1 8MN', 'United Kingdom'),
    (10, '777', 'Willow Close', 'York', 'YO1 9OP', 'United Kingdom');
    
INSERT INTO Customers (Customer_ID, FirstName, LastName, phone_number, email, address_ID)
VALUES
    (1, 'Alice', 'Smith', '123 456 7890', 'alice@egmail.com', 1),
    (2, 'Bob', 'Johnson', '20 1234 5678', 'bob@icloud.com', 2),
    (3, 'Charlie', 'Brown', '30 9876 5432', 'charlie@gmail.com', 3),
    (4, 'David', 'Lee', '987 654 3210', 'david@yahoo.com', 4),
    (5, 'Eva', 'Garcia', '91 234 5678', 'eva@gmail.com', 5),
    (6, 'Frank', 'Wang', '10 8765 4321', 'frank@icloud.com', 6),
    (7, 'Grace', 'Kim', '22 3456 7890', 'grace@gmail.com', 7),
    (8, 'Henry', 'Nguyen', '24 5678 9012', 'henry@yahoo.com', 8),
    (9, 'Isabella', 'Lopez', '55 1234 5678', 'isabella@gmail.com', 9),
    (10, 'Jack', 'Chen', '21 9876 5432', 'jack@icloud.com', 10);
    
    
    INSERT INTO Rooms (room_ID, room_type, rate)
VALUES
    (1, 'Single', 100),
    (2, 'Double', 150),
    (3, 'Suite', 250),
    (4, 'Twin', 120),
    (5, 'Deluxe', 300);
    
 INSERT INTO Bookings (booking_ID, date_booked, customer_ID)
VALUES
    (1, '2024-02-01', 1),
    (2, '2024-02-02', 2),
    (3, '2024-02-03', 3),
    (4, '2024-02-04', 4),
    (5, '2024-02-05', 5),
    (6, '2024-02-06', 6),
    (7, '2024-02-07', 7),
    (8, '2024-02-08', 8),
    (9, '2024-02-09', 9),
    (10, '2024-02-10', 10);
  

   INSERT INTO Rooms_booked (room_booked_ID, room_ID, check_in, check_out, nights, booking_ID)
VALUES
    (1, 1, '2024-02-15', '2024-02-18', 3, 1),
    (2, 2, '2024-02-20', '2024-02-25', 5, 2),
    (3, 3, '2024-02-22', '2024-02-24', 2, 3),
    (4, 4, '2024-02-28', '2024-03-03', 3, 4),
    (5, 5, '2024-03-05', '2024-03-08', 3, 5),
    (6, 1, '2024-03-10', '2024-03-15', 5, 6),
    (7, 2, '2024-03-12', '2024-03-14', 2, 7),
    (8, 3, '2024-03-18', '2024-03-20', 2, 8),
    (9, 4, '2024-03-22', '2024-03-25', 3, 9),
    (10, 5, '2024-03-28', '2024-03-30', 2, 10);
    
   
