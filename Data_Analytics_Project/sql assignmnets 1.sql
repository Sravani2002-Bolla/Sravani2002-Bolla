use classicmodels;

#1a question
select* from employees;
desc employees;
select employeeNumber,firstName,lastName from employees where jobTitle = "Sales Rep" and reportsto =1102 ; #1a question


#1b question
select* from products;
select distinct productLine from products where productLine like "%cars"; 


#2 question
select * from customers; 
select customerNumber,customerName,
case 
     when country = "USA" or "Canada" then "North America"
     when country = "Uk" or "France" or "germany" then "Europe" 
     else "Others" 
     End as "customerSegment" 
     from customers;
 

#3a question
select* from orderdetails;
select productCode, sum(quantityOrdered) as total_ordered from orderdetails group by productCode order by total_ordered desc limit 10;


#3B QUESTION
SELECT* from payments;
select count(checkNumber) as num_payments,monthname(paymentDate) as months from payments group by months having num_payments>20 order by num_payments desc;


#4 question
create database customer_orders;
use customer_orders;
create table customers (customer_id int primary key auto_increment, first_name varchar(50) not null, last_name varchar(50) not null, email_id varchar(255), phone_number varchar(20));
create table orders (order_id int primary key auto_increment, customer_id int , order_date date, total_amount decimal(10,2));
alter table orders add constraint foreign key (customer_id) references customers (customer_id);
alter table orders add constraint check (total_amount >0);


#5 question
use classicmodels;
select * from customers;
select * from orders;
select country, count(orderNumber) as order_count from customers right join orders on customers.customerNumber=orders.customerNumber group by country order by order_count desc limit 5;


#6 question
create table project(employee_id int primary key auto_increment,full_name varchar(50) not null,gender varchar(10),manager_id int);
alter table project add constraint check (gender in ("male","female"));
insert into project (employee_id,full_name,gender,manager_id) values 
(1,"Pranaya","Male",3),
(2,"Priyanka","Female",1),
(3,"Preety","Female",null),
(4,"Anurag","Male",1),
(5,"Sambit","Male",1),
(6,"Rajesh","Male",3),
(7,"Hina","Female",3);
select * from project;
select table_2.full_name as manager_name,table_1.full_name as employee_name from project
as table_2 inner join project as table_1 on table_1.manager_id=table_2.employee_id;


#7 question
create table facility(facility_id int, name_s varchar(100),state varchar(100),country varchar(100));
alter table facility modify facility_id int primary key auto_increment first;
alter table facility modify city varchar(100) not null after name_s;
desc facility;


#8 question
use classicmodels;
select* from products;
select * from orderdetails;
create view product_category_sales as select productline,sum(quantityordered*priceeach) as total_sales, count(distinct(ordernumber)) as number_of_orders from orderdetails inner join products on orderdetails.productcode=products.productcode group by productLine;
select * from product_category_sales;


#9 question
SELECT* FROM PAYMENTS;
SELECT * FROM CUSTOMERS;
# Code for stored procedure
CREATE DEFINER=`root`@`localhost` PROCEDURE `GET_COUNTRY_PAYMENTS`(IN INPUTYEAR INT,IN INPUTCOUNTRY VARCHAR(200))
BEGIN
SELECT year(PAYMENTS.PAYMENTDATE) AS YEAR,
CUSTOMERS.COUNTRY AS COUNTRY,
CONCAT(FORMAT(SUM(PAYMENTS.AMOUNT)/1000,0),'K') AS 'TOTAL AMOUNT' 
FROM PAYMENTS JOIN CUSTOMERS ON PAYMENTS.CUSTOMERNUMBER = CUSTOMERS.CUSTOMERNUMBER
WHERE YEAR(PAYMENTS.PAYMENTDATE) = INPUTYEAR AND
CUSTOMERS.COUNTRY =INPUTCOUNTRY GROUP BY YEAR,COUNTRY;
END
CALL GET_COUNTRY_PAYMENTS(2003,"FRANCE");


#10a question
SELECT * FROM CUSTOMERS;
select * from orders;
select * from customers inner join orders on customers.customernumber = orders.customernumber;
select customername, count(ordernumber) as order_count, dense_rank() over( order by count(ordernumber) desc) as order_frequency_rnk 
from customers inner join orders on customers.customernumber = orders.customernumber group by customers.customernumber,customername;


#10b question
select* from orders;
select year(orderdate) as y_r,monthname(orderdate) as m_th, count(ordernumber) as total_orders, 
CONCAT(ROUND((((count(ordernumber)) - lag(count(ordernumber),1) over(order by year(orderdate)))/lag(count(ordernumber),1) over(order by year(orderdate)))*100,0),"%") AS PERCENT_YOY_CHANGE from orders group by y_r,m_th;


#11 question
use classicmodels;
select* from products;
select productline, count(productline) as total from products where buyprice > (select avg(buyprice) from products) group by productline order by total desc;


#12 question
create table EMP_EH (Emp_ID INT PRIMARY KEY, Emp_Name varchar(100),Email_address varchar(200));
#code for errorhandling
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_emp_eh`(
in input_EMP_ID int,
in input_emp_name varchar(100),
in input_email_address varchar(200)
)
BEGIN
	DECLARE EXIT handler for SQLEXCEPTION
    BEGIN
         ROLLBACK;
         SELECT"ERROR OCCURRED" AS MESSAGE;
    END;
    START TRANSACTION;
    INSERT INTO EMP_EH (EMP_ID,EMP_NAME,EMAIL_ADDRESS)
    VALUES (INPUT_EMP_ID,INPUT_EMP_NAME,INPUT_EMAIL_ADDRESS);
    COMMIT;
    SELECT"DATA INSERTED SUCCESSFULLY" AS MESSAGE;
END
call classicmodels.insert_emp_eh(2, 'SWATHI ', 'SWATHI@GMAIL.COM');
call classicmodels.insert_emp_eh(1, 'RAMA', 'RAMA123@GMAIL.COM');


#13 question
create table emp_bit (Name_s varchar(50),occupation_s varchar(100), working_date date,working_hours int);
# code for triggers before insert
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if new.working_hours <0 then
  set new.working_hours = abs(new.working_hours);
end if;
END
insert into emp_bit ( name_s,occupation_s,working_date, working_hours) values 
("Robin","Scientist","2020-10-04",12),("Warner","Engineer","2020-10-04",10),("Peter","Actor","2020-10-04",13),("Macro","Doctor","2020-10-04",14),("Baryden","Teacher","2020-10-04",12),("Antonio","Business","2020-10-04",11);
select * from emp_bit;