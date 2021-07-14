-- This file was written in MySQL Workbench, executing line-by-line, as opposed to the entire file.

create database if not exists Sales;
use Sales;-- use the Sales database.

CREATE TABLE sales (
    purchase_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_of_purchase DATE NOT NULL,
    customer_id INT,
    item_code VARCHAR(10) NOT NULL
);

/*
When running queries, you have to specify the database within which the query is to run.
You can set a default database, or you can call a table within a database with a dot operator.
<database_name>.<table_name>
*/

SELECT 
    *
FROM
    sales;
SELECT 
    *
FROM
    Sales.sales;

-- After executing the following line, you'll see that the table in DB Sales.sales in the schema doesn't exist anymore.
drop table sales;

/*
Section 6
=========
We'll learn about setting CONSTRAINTS.
Role of constraints is to outline relationships between tables.
NOT NULL is an example of a constraint.
PRIMARY KEY is also a constraint.
In order to AUTO_INCREMENT, the field must be a primary key, index, or unique key.
*/

CREATE TABLE sales (
    purchase_number INT AUTO_INCREMENT,
    date_of_purchase DATE,
    customer_id INT,
    item_code VARCHAR(10),
    PRIMARY KEY (purchase_number)
);

/*
Now we'll create the other tables we need.
*/

CREATE TABLE customers (
    customer_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
    PRIMARY KEY (customer_id)
);

CREATE TABLE items (
    item_code VARCHAR(255),
    item VARCHAR(255),
    unit_price NUMERIC(10 , 2 ),
    PRIMARY KEY (item_code)
);

CREATE TABLE companies (
    company_id VARCHAR(255),
    company_name VARCHAR(255),
    headquarters_phone_number INT(12),
    PRIMARY KEY (company_id)
);

/*
Foreign keys are, again, keys referenced from a parent table (the referenced table vs. reference table).
Linking Sales and Customers.
FOREIGN KEY is yet another constraint. This constraint maintains the referential integrity throughout the database.
*/

drop table sales.sales;
CREATE TABLE sales (
    purchase_number INT AUTO_INCREMENT,
    date_of_purchase DATE,
    customer_id INT,
    item_code VARCHAR(10),
    PRIMARY KEY (purchase_number),
    FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
        ON DELETE CASCADE
);

/*
ON DELETE CASCADE - a best practice used by DBAs, so if you remove a record/particular value in the parent table (customers), say a customer record with a particular ID, all records in this child table will be
removed as well. That's super cool!
*/

CREATE TABLE sales (
    purchase_number INT AUTO_INCREMENT,
    date_of_purchase DATE,
    customer_id INT,
    item_code VARCHAR(10),
    PRIMARY KEY (purchase_number)
);

-- An example of altering the table after it's  been created.
alter table sales add foreign key (customer_id) references customers(customer_id) on delete cascade;
alter table sales drop foreign key sales_ibfk_1;
alter table sales drop foreign key sales_ibfk_2;
alter table sales drop foreign key sales_ibfk_3;
alter table sales drop foreign key sales_ibfk_4;
-- ^ it would appear running the alter command just continues to add foreign keys, even if they're duplicates.

-- Next exercise - drop all tables in the specified order.
drop table sales;
drop table customers;
drop table items;
drop table companies;

-- Unique keys
-- UNIQUE is a keyword you can use to constrain values in a column.
-- One such column you'd want to constrain, for example, is a user's database containing emails - the emails column should be unique.

CREATE TABLE customers (
    customer_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
    PRIMARY KEY (customer_id),
    UNIQUE KEY (email_address)
);

-- Cool, now let's drop this table and re-create it without setting a unique key.

drop table customers;
CREATE TABLE customers (
    customer_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
    PRIMARY KEY (customer_id)
);
-- Another way to add this unique key by altering an existing table.
alter table customers
add unique key (email_address);

/*
Table indexes are tools that can be created in a column to retrieve data more quickly?
unique keys function as indexes.
*/

alter table customers
drop index email_address; -- drops the unique constraint on this table. Checking DDL tab, it's indeed gone after executing this statement.

-- Exercise:
drop table customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    number_of_complaints INT,
    PRIMARY KEY (customer_id)
);

alter table customers
add column gender enum('M', 'F') after last_name;

-- Inserts a record into the customer's table in the sales database.
insert into sales.customers (first_name, last_name, gender, email_address, number_of_complaints)
values ('John', 'Mackinly', 'M', 'john.mackinly@gmail.com', 0);

-- Default constraint
-- You'll see it in almost all databases.
-- Allows you to specify a default value for a record's field in the event that it's not specified on insertion.
alter table customers
change column number_of_complaints number_of_complaints int default 0; -- so, repeat the name of the column unless you'd like to change it, and then set the type and constraints.

insert into customers (first_name, last_name, gender)
values ('Peter', 'Figaro', 'M');

SELECT 
    *
FROM
    customers; -- now let's get a picture of this table's records.
-- This shows that the number_of_complaints field was set to the default value of 0, and the email address of Peter is NULL.
alter table customers
alter column number_of_complaints drop default;-- remove a default; that's a weird syntax, there's two alter keywords.

CREATE TABLE companies (
    company_id VARCHAR(255),
    company_name VARCHAR(255),
    headquarters_phone_number VARCHAR(255),
    PRIMARY KEY (company_id)
);

alter table companies
add unique key (headquarters_phone_number);
alter table companies
change column company_name company_name varchar(255) default 'X';
drop table companies;-- verified that the DDL tab shows the intended result.

CREATE TABLE companies (
    company_id VARCHAR(255),
    company_name VARCHAR(255) DEFAULT 'X',
    headquarters_phone_number VARCHAR(255),
    PRIMARY KEY (company_id),
    UNIQUE KEY (headquarters_phone_number)
);

-- And if I wanted to drop the unique key, recall that I have to call it as an index
alter table companies
drop index headquarters_phone_number;

drop table sales.companies;

-- NOT NULL constraints
CREATE TABLE companies (
    company_id INT AUTO_INCREMENT,
    headquarters_phone_number VARCHAR(255),
    company_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (company_id)
);

alter table companies
modify company_name varchar(255) null; -- this syntax is specific to working with null constraints and modifying them.

insert into sales.companies (headquarters_phone_number, company_name)
values ('+1 (617) 123 4567', 'Microsoft');-- note that the auto_increment'ed primary key will just start at 1.
SELECT 
    *
FROM
    sales.companies;
drop table sales.companies;

-- Exercise
CREATE TABLE companies (
    company_id INT AUTO_INCREMENT,
    headquarters_phone_number VARCHAR(255) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (company_id)
);
alter table companies
modify headquarters_phone_number varchar(255) null; -- ensure that this field can be null, instead of what I stated above as `not null`; checking the DDL, it looks like this indeed becomes varchar(255) default null;
alter table companies
modify company_name varchar(255) null;
alter table companies
modify headquarters_phone_number varchar(255) not null;
alter table companies
modify company_name varchar(255) not null;

drop table companies;

-- NULL is a value assigned by the computer. 0 and 'NONE' are not the same as NULL.

/*
So, in summary, modifying different constraints looks like

	alter table companies
    - modify <field_name> <type> [null|not null]
    - change column <field_name> <new_field_name> <type> [null|not null]
    - change column <field_name> <new_field_name> <type> default <default_value> -- add a default value to a column
    - alter column <field_name> drop default -- drop setting a default value to a field/column if not specified on insertion
    - add unique key (<field_name>)
    - drop index (<field_name>)
    ;
*/

/*
Section 7
=========
Coding style.
Good code, as always, is code that humans can read, not just computers.
ctrl-b in SQL workbench beautifies your code, or click the paintbrush above on the line.
*/

/*
Section 8
=========
Loading the employees database to practice SELECT queries.
https://www.dropbox.com/s/znmjrtlae6vt4zi/employees.sql?dl=0
*/

/*
Section 9
=========
SELECT and queries.
Here we'll start using DML, not just looking at DDL.
*/

use Employees;

SELECT 
    first_name, last_name
FROM
    employees.employees; -- displays these two columns in the output.

select * from employees;
    
select * from departments;
    
-- WHERE clauses
select * from employees where first_name = 'Denis' order by gender; -- retrieves 232 records from the table.

select * from employees where first_name = 'Elvis' order by gender; -- retrieves 246 records.

-- = is the equality operator.
-- AND, IN, NOT IN, LIKE, NOT LIKE, BETWEEN, BETWEEN AND, EXISTS, NOT EXISTS, IS NULL, IS NOT NULL, comparison operators (like <, >, <=, >=, ...)
select * from employees where first_name = 'Denis' and gender = 'M'; -- retrieves 140 records this time, instead of 232.
select * from employees where first_name = 'Kellie' and gender = 'F';
select * from employees where first_name = 'Denis' or first_name = 'Elvis';
select * from employees where first_name = 'Kellie' or first_name = 'Aruna';

-- Operator precedence
-- AND is applied first and OR is applied second.
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND (first_name = 'Kellie'
        OR first_name = 'Aruna');
        
-- IN and NOT IN
select * from employees where first_name in ('Cathie', 'Mark', 'Nathan');
select * from employees where first_name in ('Elvis', 'Denis');
select * from employees where first_name not in ('John', 'Mark', 'Jacob');

-- LIKE, NOT LIKE
select * from employees where first_name like ('ar%');
select * from employees where first_name like ('%ar_');


-- Note that MySQL is case insensitive.

select * from employees where first_name like ('mar%');
select * from employees where hire_date like ('2000%');
select * from employees where emp_no like ('1000_');

-- Wildcard characters are *, _, and %
select * from employees where first_name like ('%jack%');
select * from employees where first_name not like ('%jack%');

-- Between operator, Between... and...
select * from employees where hire_date between '1990-01-01' and '2000-01-01' order by hire_date desc;
SELECT 
    *
FROM
    salaries
WHERE
    salary BETWEEN 66000 AND 70000
ORDER BY salary DESC;

select * from employees where emp_no not between '10004' and '10012';
select * from departments where dept_no between 'd003' and 'd006';

-- IS NOT NULL
select * from departments where dept_no is not null;

-- Mathematical operators
-- <> or != can be used for not equals.
select * from employees where first_name <> 'Mark';
select * from employees where hire_date >= '2000-01-01' order by hire_date asc; -- gives 13 results.
select * from employees where hire_date <= '1985-02-01' order by hire_date desc;
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND hire_date >= '2000-01-01'
ORDER BY hire_date ASC;

select * from salaries where salary > 150000 order by salary desc;

-- SELECT DISTINCT
select distinct gender from employees; -- shows the enum values for gender, 'M' and 'F'
select distinct hire_date from employees order by hire_date asc;

-- Aggregate functions - COUNT(), MIN(), MAX(), SUM(), AVERAGE()
select count(emp_no) from employees;
select count(first_name) from employees; -- same answer as above
select count(distinct first_name) from employees;
select count(salary) from salaries where salary >= 100000;
select count(*) from dept_manager; -- 24

-- ORDER BY
select * from employees;
select * from employees order by first_name; -- orders by first_name, starting with the letter 'a'
select * from employees order by hire_date desc;

-- GROUP BY - must be placed after WHERE clause, and before ORDER BY
/*
SELECT [DISTINCT]
	...
FROM
	...
WHERE
	...
GROUP BY
	...
ORDER BY
	...
*/
select first_name from employees;
select first_name from employees group by first_name order by first_name; -- removes duplicates, similar to
select distinct first_name from employees order by first_name;
select count(first_name) from employees; -- number of records
select count(first_name) from employees group by first_name; -- number of times each distinct name arises in the database
select first_name, count(first_name) from employees group by first_name order by first_name asc; -- get an alphabetical list of names and the number of times they occur in the database. Cool!
select first_name, count(first_name) from employees group by first_name order by count(first_name) desc; -- get a list of names from the db ordered by the number of times they occur, instead of alphabetically.
select first_name, count(first_name) as first_name_count from employees group by first_name order by first_name_count desc; -- same as above, but this time using an alias referenced elsewhere
-- Aliases clarify output, and it's more professional to use these instead of leaving function names in query output.
select salary, count(salary) as emps_with_same_salary from salaries where salary > 80000 group by salary order by salary desc;

-- HAVING - implemented with GROUP BY often to further narrow down. Difference between HAVING and GROUP BY
/*
SELECT [DISTINCT]
	...
FROM
	...
WHERE
	...
GROUP BY
	...
HAVING
	...
ORDER BY
	...
*/
-- HAVING applies to the GROUP BY block.
select * from employees where hire_date >= '2000-01-01';
select * from employees having hire_date >= '2000-01-01';
-- HAVING can have an aggregate function, whereas WHERE cannot.
select first_name, count(first_name) as first_name_count from employees where first_name_count > 250 group by first_name order by first_name_count desc; -- error code 1054 - can't use aliases in WHERE clause
select first_name, count(first_name) as first_name_count from employees where count(first_name) > 250 group by first_name order by first_name_count desc; -- error code 1011 - can't use aggregate function in WHERE clause
select first_name, count(first_name) as first_name_count from employees group by first_name having first_name_count > 250 order by first_name_count desc; -- works just fine, so you _can_ call aliasees in the HAVING clause
select first_name, count(first_name) as first_name_count from employees group by first_name having count(first_name) > 250 order by first_name_count desc; -- works as well, though I'd probably want the above.
-- So, lesson's learned from WHERE ... GROUP BY ... HAVING - you can't use functions or aliases in the WHERE clause, but you _can_ use them in GROUP BY ... HAVING ...'s clauses.
-- COUNT is an aggregate function.
-- Another Exercise:
select emp_no, avg(salary) as average_salary from salaries group by emp_no having average_salary > 120000 order by average_salary desc; -- at first, I didn't realize there were multiple salaries in this table per emp_no, I thought emp_no was a key?
-- Ahh, looking over the DDL for this table, the primary key is the pair emp_no and from_date, so you can indeed have multiple emp_no's and different salaries. Interesting! First time I've seen that.
-- And yes, with my query above, I get 101 results from this DB as the question hints.
SELECT *, AVG(salary) FROM salaries WHERE salary > 120000 GROUP BY emp_no ORDER BY emp_no;

-- Important to decide whether to use WHERE and HAVING
-- Exercise II - where vs. having
select *, count(from_date) as contracts_signed from dept_emp where from_date > '2000-01-01' group by emp_no having contracts_signed > 1 order by emp_no asc;

-- LIMITs
select * from salaries; -- returns the maximum default records, 1000
select *, avg(salary) as average_salary from salaries group by emp_no order by average_salary desc limit 10; -- get the top 10 highest paid (on average, throughout their time with the company) employees

-- So now the blocks look like
/*
SELECT [DISTINCT]	
	...
FROM
	...
WHERE
	... -- cannot use functions here
GROUP BY
	... -- can use them here, as well as aliases
HAVING
	... -- can also use them here
ORDER BY
	...
LIMIT n
*/

-- Exercise:
select * from dept_emp limit 100; -- gimme the first 100 rows of this table.

/*
Section 10
==========
Insert statement
Let's insert some records into the employees table.
*/

select * from employees order by emp_no desc limit 10;
insert into employees (
	emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    hire_date
) values (
	999901,
    '1986-04-21',
    'John',
    'Smith',
    'M',
    '2011-01-01'
);

insert into employees (
	emp_no,
    birth_date,
    first_name,
    last_name,
    gender,
    hire_date
) values (
	999902,
    '1973-3-26',
    'Patricia',
    'Lawrence',
    'F',
    '2005-01-01'
);

-- Shortcut - you don't need to specify the fields you're inserting if it's in the proper order.
insert into employees values (
	999903,
    '1977-09-14',
    'Jonathan',
    'Creek',
    'M',
    '1999-01-01'
);

select * from employees where emp_no = 999901;

-- Execute the above again, and you'll see John Smith at the top, since he has the largest employee number.
-- You can write integers in quotes and they'll be coerced into integer types. However, this is not best practice and should be avoided.
-- Order matters in tuples of values.

-- Exercise 1
select * from titles limit 10;
insert into titles (
	emp_no,
    title,
    from_date,
    to_date
) values (
	999903,
    'Senior Engineer',
    '1997-10-01'
); -- requires there to be a record for the emp_no 999903 in the parent table, employees, in order to properly submit.

-- Exercise 2
select * from dept_emp limit 10;
insert into dept_emp values (
	999903,
    'd005',
    '1997-10-01',
    '9999-01-01'
);

-- Now let's copy data from one table to another.
create table departments_dup (
	dept_no char(4) not null,
    dept_name varchar(40) not null
);

select * from departments_dup;

insert into departments_dup (
	dept_no,
    dept_name
) 
select *
from departments;

/* So my total picture of the syntax can look like
INSERT INTO
	...
SELECT [DISTINCT]
	...
FROM
	...
    
for insertion statements. For selection statements, so far it looks like I can do the following clauses -

SELECT [DISTINCT]
	...
FROM
	...
WHERE
	...
GROUP BY
	...
HAVING
	...
ORDER BY
	...
LIMIT
	...
    
though I'm sure there are far more ways you can combine this.
*/

-- Exercise -
insert into departments (
	dept_no,
    dept_name
) values (
	'd010',
    'Business Analysis'
);

/*
Section 11
==========
Commit and rollbacks.
When changing the state of your dataset, you can only rollback to the latest commit. Former commits cannot be rolled back to.
*/

use employees;
select * from employees where emp_no = 999903;
update employees set first_name = 'Stella', last_name = 'Parkinson', birth_date = '1990-12-31', gender = 'F' where emp_no = 999903;

-- turned off autocommit.

commit;
select * from departments_dup order by dept_no asc;
update departments_dup set dept_no = 'd011', dept_name = 'Quality Control'; -- leaving off the WHERE clause, so it'll just update all records?
-- Ouch, it actually did that :p
rollback;
commit;

-- Exercise:
select * from departments order by dept_no asc limit 10;
update departments set dept_name = 'Data Analytics' where dept_no = 'd010';
commit;

-- DELETE
select * from employees where emp_no = 999903;
select * from titles where emp_no = 999903;
delete from employees where emp_no = 999903;
rollback;
commit;

select * from departments order by dept_no limit 10;
delete from departments; -- affects 10 rows.
rollback;

-- DROP, DELETE, and TRUNCATE
-- Exercise:
delete from departments where dept_no = 'd010';

-- drop - you will lose everything if you drop a table. Works on objects.
-- truncate - will also delete all records without a WHERE clause. However, records will reset for fields that have AUTO_INCREMENT set. Faster than delete since it doesn't examine each row.
-- delete ... where - slower than truncating.
-- There are other technical differences between these options that won't be covered in this course.

/*
Section 13
==========
Aggregation functions, and general SQL functions.

Quick summary of the last few sections - we covered

select ... from ... where ... group by ... having ... order by ... limit ...
insert into ... select ... from ... where ......
update ... set ... where ...
delete ... from ...
truncate
drop

in addition to aliases (as keyword).
*/

select count(salary) from salaries; -- get the number of salaries there are (basically, how many records are in this db, so not crazy useful)
select count(distinct from_date) from salaries;
-- Agg functions typically ignore null values.
select count(*) from salaries;

-- Exercise:
select count(distinct dept_no) from dept_emp; -- shows 9 distinct departments in the dept_emp database

-- SUM
select sum(salary) from salaries; -- gives us the total amount of money the firm has spent on salaries (? not really, but as an exercise, makes sense).
-- So basically, count is used on records, sum is used on record values.
-- select sum(*) from salaies; -- syntax error, because you can't use the * syntax with SUM.
-- Exercise:
select sum(salary) from salaries where from_date >= '1997-01-01';

-- MIN and MAX - return the min and max of the column.
select max(salary) from salaries;
select min(salary) from salaries;
-- Exercise:
select max(emp_no) from employees;
select min(emp_no) from employees;

-- AVG - extracts average from all non-null values in a field
select avg(salary) from salaries;
-- These agg functions are commonly used with group-by clauses.
-- Exercise:
select avg(salary) from salaries where from_date >= '1997-01-01';

-- ROUND
select avg(salary) from salaries; -- returns 4 digits to the right of the decimal.
select round(avg(salary)) from salaries; -- rounds to the nearest integer by default, but it has an optional second parameter
select round(avg(salary), 2) from salaries;
-- Exercise:
select round(avg(salary), 2) from salaries where from_date >= '1997-01-01';

-- COALESCE and IFNULL
-- IFNULL can wrap a field name and, should a record contain NULL, it will return the second  argument of IFNULL instead. Similar to Excel or Google Sheets.
-- Also important to alias IFNULL.
-- COALESCE is an extended IFNULL that returns the first value from left-to-right that is not NULL.
-- If COALESCE has only two arguments, it will act exactly like IFNULL.
-- COALESCE will also need to be aliased for a professional output.

-- Exercise (COALESCE):
select *, coalesce(dept_no, dept_name, 'N/A') as 'dept_info' from departments_dup order by dept_no asc;

-- Exercise 2
select IFNULL(dept_no, 'N/A') as 'dept_no', IFNULL(dept_name, 'Department name not provided') as 'dept_name', coalesce(dept_no, dept_name, 'N/A') as 'dept_info' from departments_dup order by dept_no asc;

/*
Section 14
==========
Joins - the SQL tool that allows us to construct a relationship between objects.
Relational schemas help you figure out how to construct these relationships.
Joins show a result set representing these relations between tables.
1. find a column of commonality between the two tables that has the same time of data.
	- remember that tables don't have to be logically adjacent to one another, or directly related, in order to form a join.
2. What is important is that there's a related column between the two tables that's the same type.
*/

-- INNER JOINs
select * from departments_dup order by dept_no asc limit 10; -- so let's take a look at this table, looks good
drop table departments_dup;
create table if not exists departments_dup (
	dept_no varchar(4), -- cannot be null since it's a PK.
	dept_name varchar(40),
    primary key (dept_no)
);
drop table if exists department_dup;
alter table departments_dup modify column dept_name varchar(40);
show columns from departments_dup;

insert into departments_dup (dept_no, dept_name) select * from departments; -- lastly, let's copy all this stuff over for practice

insert into departments_dup values ('d010', 'Public Relations');
commit;
delete from departments_dup where dept_no = 'd002';
alter table departments_dup change column dept_no dept_no char(4) null;

-- Exercise 2:
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
);
INSERT INTO dept_manager_dup
select * from dept_manager;
INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES (999904, '2017-01-01'), (999905, '2017-01-01'), (999906, '2017-01-01'), (999907, '2017-01-01');
DELETE FROM dept_manager_dup 
WHERE
    dept_no = 'd001';
INSERT INTO departments_dup (dept_name) VALUES ('Public Relations');
DELETE FROM departments_dup 
WHERE
    dept_no = 'd002'; 

-- So now we have duplicates. Inner joins can show us the common records between the two tables.
select * from dept_manager_dup order by dept_no; -- shows some fields here have NULL values.
select * from departments_dup order by dept_no;

/*
JOIN syntax is like

select table_1.column_names, table_2.column_names  -- columns to display in the output for matching columns
from table_1 -- base tabl
join table_2 on table_1.column_name = table_2.column_name -- select the field over which to 'pivot' to find commmon records between the two tables?

Oooh, even better, you can alias table names at the beginning of the FROM ... and JOIN ... clauses like

select
	t1.column_names, t2.column_names
from
	table_1 t1
join
	table_2 t2 on t1.column_name = t2.column_name
    
which is some nice syntactic sugar. In other words, you don't have to use AS keyword.
*/

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
ORDER BY dept_no ASC;

-- Exercise:
SELECT 
    d.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
FROM
    dept_manager_dup d
        INNER JOIN
    employees e ON d.emp_no = e.emp_no
ORDER BY d.emp_no ASC;
    
-- Some notes on making joins - 
-- You should probably start with the FROM block so you know what the aliases are referencing/pointing toward, then write the beginning 
-- Just typing JOIN and not INNER JOIN is fine since it means the same thing; however, you will have to specify the type of join in other places.

-- Duplicate records indicate (x1, x2, ..., xn) = (y1, y2, ..., yn)
-- You can use GROUP BY to eliminate duplicate records in the data

select
	*
from 
	dept_manager_dup
where
	emp_no = 110022;
    
insert into
	dept_manager_dup
select
	*
from 
	dept_manager_dup
where
	emp_no = 110022; -- creates a duplicate record in my database, per above.

select
	d.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
from 
	dept_manager_dup d
join
	employees e
on
	d.emp_no = e.emp_no
group by
	emp_no
order by
	emp_no asc; -- with this query, unlike the exercise query above, we still get 24 returned results with grouping by emp_no, whereas the above query returns 25
    
-- LEFT JOIN - show me all records that occur in the left table, as well as those that occur in the left and the right.
-- Remove the duplicate I added above
delete from dept_manager_dup where emp_no = 110022; -- deletes two rows.
-- Eh let's just recreate the table, I've duplicated a different record than he does in the videos.
drop table if exists dept_manager_dup;
select * from dept_manager_dup order by dept_no asc limit 10;

select
	d.emp_no, e.first_name, e.last_name, d.dept_no, e.hire_date
from 
	dept_manager_dup d
left join
	employees e
on
	d.emp_no = e.emp_no
group by
	emp_no
order by
	emp_no asc; -- we get 26 rows
    
-- Order matters when you switch table orders, so m left join n is obviously not the same as n left join m. 
-- LEFT JOIN and LEFT OUTER JOIN are synonymous.

-- Exercise:
use employees;
select 
	d.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
from 
	employees e
		left join
	dept_manager d
		on e.emp_no = d.emp_no
where
	e.last_name = 'Markovitch'
order by
	d.emp_no desc; -- I got Margareta Markovitch from department number d001, emp_no 110022.

-- I really wish he'd forget about null values and adding things, and just focus on joins first. I'm rather confused in his examples at this point, but the syntax/concept makes sense.
-- RIGHT JOINs are seldom made in practice, since you can just swap the table order with LEFT JOINs and get the same result as a right join.
-- LEFT and RIGHT joins are examples of one-to-many relationships in MySQL.

-- Exercise:
select
	m.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
from
	dept_manager m,
    employeees e
where
	m.emp_no = e.emp_no
order by m.emp_no; -- this does not run on my machine, but it looks identical to the code used in the course (course is probably slightly outdated compared to the version of MySQL I'm running)

-- Exercise:
select
	e.emp_no, e.first_name, e.last_name, e.hire_date, s.salary
from
	employees e
		join
	salaries s
		on e.emp_no = s.emp_no
where
	s.salary >= 145000 and e.hire_date >= '1986-01-01'
order by
	e.emp_no asc;
    
-- Exercise:
select
	e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
from
	employees e
		join
	titles t
		on
	e.emp_no = t.emp_no
where
	e.first_name = 'Margareta' and e.last_name = 'Markovitch'
order by
	e.emp_no;
    
-- CROSS JOIN - cartesian product of two or more sets.
-- ON clause following join is optional, but best practice to include; otherwise, use a cross join.
select
	dm.*, d.*
from
	dept_manager dm
		cross join
	departments d
		-- notice there's no ON clause here.
where
	dm.dept_no <> d.dept_no
order by
	dm.emp_no, d.dept_no asc; -- this removes records where the manager is currently working.
    
-- We could also have written this like
select
	dm.*, d.*
from
	dept_manager dm
		cross join
	departments d
		on
	dm.dept_no <> d.dept_no
order by
	dm.emp_no, d.dept_no asc;
-- So that's pretty cool, the condition over which you're joining ON doesn't have to be an =.

-- We can also CROSS JOIN more than two tables, but know that the size is going to be n1 x n2 x n3 etc. So be careful about the size of the returned result, SQL may not execute it.

-- Exercise:
select
	dm.*, d.*
from
	dept_manager dm
		cross join
	departments d
where
	d.dept_no = 'd009'
order by
	dm.emp_no asc; -- we ordered by different columns, but I don't think it makes much sense for him to order by dept_no when they're all the same dept_no from the WHERE clause.

select emp_no from employees limit 10; -- didn't realize the first column was type int, so it's ordered
select
	e.*, d.*
from
	employees e
		cross join
	departments d
where
	e.emp_no <= 10010
order by
	e.emp_no, d.dept_no;
    
-- Exercise: find the average wage of men and women in the company.
SELECT 
    e.gender, AVG(s.salary) AS average_salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.gender;

-- JOINs can be fragile, and SQL allows you to 
select
	e.first_name, e.last_name, e.hire_date, dm.from_date, d.dept_name
from
	employees e
		join
	dept_manager dm
		on e.emp_no = dm.emp_no
		join
	departments d
		on dm.dept_no = d.dept_no
order by e.first_name limit 100; -- returns 24 managers

select * from dept_manager; -- there are 24 managers, which makes sense.

-- Exercise:
select
	e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_name
from
	employees e
		join
	titles t
		on e.emp_no = t.emp_no
		join
	dept_manager dm
		on e.emp_no = dm.emp_no
		join
	departments d
		on dm.dept_no = d.dept_no
order by e.first_name;

-- Tips and tricks for JOINs
-- Exercise: How many male and how many female managers do we have in the employees database?
select
	e.gender, count(e.gender) as gender_count
from
	employees e
		join
	dept_manager dm
		on e.emp_no = dm.emp_no
group by
	e.gender; -- I get an answer of 13.
    
-- UNION vs. UNION ALL
drop table if exists employees_dup;
CREATE TABLE employees_dup (
    emp_no INT,
    birth_date DATE,
    first_name VARCHAR(14),
    last_name VARCHAR(16),
    gender ENUM('M', 'F'),
    hire_date DATE
);
insert into employees_dup select e.* from employees e limit 20; -- copy first 20 records in their entirety to the table.
select * from employees_dup; -- 20 records are returned.

insert into employees_dup select e.* from employees_dup e where e.emp_no = 10001; -- duplicate this row.
select ed.* from employees_dup ed where ed.emp_no = 10001; -- returns 2 records.

-- UNION will remove duplicate records, whereas UNION ALL won't, it returns all records.
-- UNION is more expensive to compute than UNION.

/*
Section 15
==========
SQL subqueries and nested queries.
*/

-- Typically reside in a WHERE clause following a select statement.
-- Subqueries should always be placed within parentheses.
-- Innermost queries are executed first, and you can have as many subqueries as you'd like

-- Exercise:
SELECT 
    dm.*
FROM
    dept_manager dm
WHERE
    dm.emp_no IN (SELECT 
            e.emp_no
        FROM
            employees e
        WHERE
            e.hire_date >= '1990-01-01'
                AND e.hire_date <= '1995-01-01');
                
-- EXISTS operator could be used instead on the above exercise:
SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            dept_manager dm
        WHERE
            dm.emp_no = e.emp_no);	-- So you can flip the inner and outer queries here by using exists, neat.
            
-- EXISTS is better for large datasets, and IN is faster with smaller datasets.
-- Some (but not all) subqueries can be rewritten as joins, which can be more performant. They are also, at times, more readable than joins.

-- Exercise:
select
	e.*
from
	employees e
where
	exists(select * from titles t where t.title = 'Assistant Engineer' and t.emp_no = e.emp_no); -- 15128 rows returned in twice the time as the next query, so this one appears to be less efficient for this dataset size.
    
select
	e.*
from
	employees e
where
	e.emp_no in (select t.emp_no from titles t where t.title = 'Assistant Engineer'); -- 15128 rows returned
    
-- You can put a subquery anywhere in a query, so also in SELECT and FROM blocks, not just WHERE clauses.
-- Exercise:
-- Interesting item learned: you can alias subqueries as well, and reference them elsewhere in your longer queries.
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_id,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_id
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_id,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_id
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;
    
-- Exercise:
commit;
drop table if exists emp_manager;

CREATE TABLE emp_manager (
    emp_no INT NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT NOT NULL
);

-- Exercise: 2
-- ? his solution doesn't work.

/*
Section 16
==========
Self joins - you have to use aliases here.
*/
select distinct
	e1.*
from
	emp_manager e1
		join
	emp_manager e2
		on e1.emp_no = e2.manager_no;
        
/*
Section 17
==========
Views. Retrievals happen through SQL statements.
*/

create or replace view v_dept_emp_last_date as 
select
	emp_no, max(from_date) as from_date, max(to_date) as to_date
from
	dept_emp
group by emp_no;

-- Views save coding time, since they can be called under the db as an 'object' using dot notation.
-- Views also instantly update as the db changes.
CREATE OR REPLACE VIEW v_manager_average_salary AS
    SELECT 
        ROUND(AVG(s.salary), 2) AS average_salary
    FROM
        dept_manager dm
            JOIN
        salaries s ON s.emp_no = dm.emp_no;
        
/*
Section 18
==========
Stored routines - 'fixed actions' or basically reusable methods stored on the DB server.
Uses the CALL keyword.
*/

-- 2 different types of procedures - functions and stored procedures
use employees;
-- in order to use a stored procedure, you need to change the delimiter ? $$
delimiter $$
create procedure get_employees()
begin
	select * from employees limit 100;
end$$

call get_employees();

delimiter ;
use employees;

-- Exercise:
-- created a procedure that finds the average employee salary company-wide in a different file.
drop procedure average_employee_salary;
drop procedure get_employees;

-- Parametric procedures.
-- See employee_salary_from_emp_no.sql for solution to a parametric procedure. It's  really cool because SQL Workbench will prompt you for the type/inputs in order to produce outputs.
call employees.employee_salary(110022);

-- Multi-parameter procedures and outputs -
-- See emp_avg_salary_out.sql for solution / work

-- Exercise:
-- see emp_info.sql for my procedure.

-- Variables
set @v_employee_number = 0;
call emp_info('Margareta', 'Markovitch', @v_employee_number);
select @v_employee_number; -- cool! I didn't even know MySQL had variables.

-- Exercise:
set @v_emp_no = 0;
call emp_info('Aruna', 'Journel', @v_emp_no);
select @v_emp_no;

-- User-defined functions in MySQL
-- Within function bodies, use the declare keyword to create a variable that's associated with the function object.
-- There also needs to be a return statement if you've defined 'returns' in the function signature.

-- Exercise: write a function that accepts an employee number as input, and returns the average salary of the employee as output.
-- See file function_avg_salary.sql for the solution.

-- Differences between procedures and functions:
-- Procedures can have multiple out parameters, whereas functions can only have one output.
-- Functions must always return a value. So, if you need to perform an operation like INSERT, DELETE, or UPDATE, use a procedure.
-- procedures are call'ed, whereas functions are select'ed.

-- Moving on to Tableau!
-- SQL and Tableau can be integrated to produce visualizations. I'd like to try this with Grafana as well.