----Capstone Project
---Scenario
---You are hired as a Junior Data Analyst for a retail company
---that sells electronics and accessories.
---Your manager wants you to analyze sales and customer data using SQl in SSMS.

use class;

Create database project;
use project;

---Create Customers table

Create table customers(
customer_id int primary key,
firstname varchar(50),
lastname varchar(50),
city varchar(50),
joindate date
);

---Insert data into customers

insert into customers values
(1,'john','doe','mumbai','2024-01-05'),
(2,'alice','smith','delhi','2024-02-15'),
(3,'bob','brown','bangalore','2024-03-20'),
(4,'sara','white','mumbai','2024-01-25'),
(5,'mike','black','chennai','2024-02-10');

select * from customers;

---Create orders table

create table orders(
orderid int primary key,
customerid int foreign key references customers(customer_id),
orderdate date,
product varchar(50),
quantity int,
price int
);


-- Insert data into Orders

INSERT INTO Orders VALUES
(101, 1, '2024-04-10', 'Laptop', 1, 55000),
(102, 2, '2024-04-12', 'Mouse', 2, 800),
(103, 1, '2024-04-15', 'Keyboard', 1, 1500),
(104, 3, '2024-04-20', 'Laptop', 1, 50000),
(105, 4, '2024-04-22', 'Headphones', 1, 2000),
(106, 2, '2024-04-25', 'Laptop', 1, 52000),
(107, 5, '2024-04-28', 'Mouse', 1, 700),
(108,3,'2024-05-02','keyboard',1,1600);

select * from orders;

---Part A: Basic Queries
---1 Get the list of all customers from mumbai.
---2 show all orders for laptops.
---3 Find the total number of orders placed.
---4 Find price between 50000 and 8000

---1
select * from customers
where city= 'mumbai';
--- Sara & John From Mumbai.

---2
select * from orders 
where product= 'laptop';

---3
select COUNT(*) as TotalOrders from orders;

--Total of 8 order placed

---4

select * from orders
where price between 50000 and 80000;

---there are 3 customers who shopped between 50K to 80K

---Part B: Joins
---4 Get the full name of customer and their product order.
---5 Get the full name of customers and their product ordered.

select c.Firstname +' '+ c.Lastname as fullname, o.product 
from customers c 
join orders o on c.customer_id = o.customerid;

---5  Get the full name of customers and their product ordered.

Select * from customers
where customer_id not in (Select Distinct CustomerID From  orders);


----PART C: Aggregations
---6 find the total revenue earned from all orders.
---7 Find total quantity of mouses Sold.

---6
select SUM(price) as Total_revenue
from orders;

---7
SELECT SUM(Quantity) AS total_mouses_sold
FROM orders
WHERE product = 'mouse';

---PART D: Group By
---8 Show total sales amount per customer 
---9 show numbers of orders per city.

---8

select c.firstname, SUM(o.quantity * o.price)sales
from customers c join orders o on c.customer_id = o.customerid
group by c.firstname;

---9 
SELECT c.city, COUNT(o.orderid) AS orders
FROM customers c join orders o on c.customer_id = o.customerid
GROUP BY c.city;

----PART E: Subquery and Case
---10 Find customers who spent more than 50,000 in total.
---11 Write a quary to display each order  with a label

---High value if price > 50000

---Low value otherwise

---10
select c.* 
from customers c
where c.customer_id IN (
select customerID 
from Orders
group by customerID
having Sum(price) > 50000
);

---11
Select OrderId,price, 
case 
when Price > 50000 then 'High Value'
else 'Low value'
end as ValueLabel
from orders;


----PART F:Window function
---12 find the running total of  revenue by order date

select orderID, OrderDate, Price,
    SUM(Price) Over (Order By OrderDate) as RunningRevenue
From orders;

---13 assign a row number to each order
---by customerid ordered by orderdate (oldest first)

select 
orderid,
customerid,
orderdate,
price,
ROW_NUMBER() over (partition by customerid order by orderdate) as rownum from orders;

---14  assign a row number to each order
---by customerid ordered by price

select 
orderid,
customerid,
orderdate,
price,
ROW_NUMBER() over (partition by customerid order by price) as rownum from orders;


---15 Use DENSE RANK to
---rank order by price (highest to lowest) explaim different with rank.

---15

SELECT 
   OrderID,
   CustomerID,
   Price,
   DENSE_RANK() OVER (ORDER BY Price DESC) AS Pricedenserank
From orders;


---16 Find customer who have placed more than 1 order using having.

Select 
   customerID,
   COUNT(OrderID) As totalOrders
   from orders
   group by  customerid
   Having COUNT(orderid)>1;




