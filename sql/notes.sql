ELECT column_names
FROM table
WHERE (NOT) EXISTS (
  SELECT column_names FROM table WHERE condition
)

/* WHERE ANY */
/* operator must be =, >, <, <=, >=, != */
SELECT column_names
FROM table
WHERE column operator ANY (
  SELECT column_names FROM table WHERE condition
)

/* WHERE ALL */
/* operator must be =, >, <, <=, >=, != */
SELECT column_names
FROM table
WHERE column operator ALL (
  SELECT column_names FROM table WHERE condition
)

/* SELECT INTO */
SELECT column1, column2, ...
INTO new_table
FROM old_table
WHERE condition

/* INSERT INTO SELECT */
INSERT INTO table2 (column1, column2, ...)
SELECT column1, column2, ...
FROM table1
WHERE condition

/* or if fields match */
INSERT INTO table2
SELECT * FROM table1
WHERE condition

/* Returning data from update, delete, or INSERT */
INSERT INTO table (field1, field2) VALUES (value1, value2) returning id
/* syntax:  */
/* returning value1, value2 */
/* returning * */

/* Index types */

/* B-Tree
stands for binary tree.
It works for comparison operators such as:
>
<=
=
>=
>
 */

/* Hash
works great with the equal operator
 */

/* GIN
Generalized Inverted Index.
Great for data types that have multiple values in a column.
Arrays
Range types
JSON B
Hstore - key/value pairs

Works for more advanced pattern matching like finding intersecting values in arrays:
@> and <@
&&
*/

/* Gist
Generalized Inverted Search Tree
Useful for data that overlaps with values from a column
full text search
geometry
 */


/* BRIN
Block Range Indexes
Best used for large datasets that have some natural ordering
time series
zip codes
the more sequential ordering the better
 */

/* SP-Gist
Space Partitioned Gist
Useful for data that has a natural clustering to it but not balanced.

U.S. phone numbers are an example of this. Clusted around the area code, the
next 3 numbers, followed by the last 4
*/

/* Creating an Index */
CREATE INDEX name
ON table USING type (field1...)

/* speeding up text matching */
CREAT extension pg_trgm
CREATE INDEX trgm_idx_performance_test_location
ON performance_test USING gin (location gin_trgm_ops)

CREATE INDEX idx_perforamance_test_name
ON performance_test (name)

/* Create sequence */
CREATE sequence test_sequence;
SELECT nextval('test_sequence')
SELECT currval('test_sequence')
SELECT lastval()
SELECT setval('test_sequence', 14)
/* this would skip 14 and go to 15 */
SELECT nextval('test_sequence')
/* if you don't want to skip 14, add `false` */
SELECT setval('test_sequence', 14, false)

/* to increment by 5 */
CREATE sequence IF NOT EXISTS test_sequence_2 INCREMENT 5;

/* full sequence control */
CREATE SEQUENCE IF NOT EXISTS test_sequence_3
increment 50
minvalue 350
maxvalue 5000
start with 550;

/* Views - With check option */
/* add  */
with local check option
/* or */
with cascading check option

/* CASE WHEN */
CASE WHEN <condition> THEN result
WHEN condition THEN result
ELSE default
END as new_column_name

SELECT companyname, contry,
CASE WHEN country in ('Austria, Germany, Poland') THEN 'Europe'
WHEN country IN ('Mexico', 'USA', 'Canada') THEN 'North America'
WHEN country IN ('Brazil', 'Venezuala', 'Argentina') THEN 'South America'
else 'unknown'
END AS continent
FROM customers

/* second syntax */

CASE field WHEN value THEN result
WHEN value THEN result
ELSE default
END AS new_column_name

SELECT companyname, city
case city when 'New Orleans' then 'Big Easy'
when 'Paris' then 'City of Lights'
else 'Needs nickname'
end as nickname
FROM suppliers;

/* COALESCE Function - returns the first non-null value */
coalesce(field1, field2...)
/* return 'N/A' for shipregion from orders when the shipregion is null */

SELECT customerid, coalesce(shipregion, 'N/A')
FROM orders


/* NULLIF Function - returns null if both are equal, otherwise returns the first */
nullif(field1, field2)
/* return null for homepages that are an empty string, and return need to call for that value */

SELECT companyname, phone, coalesce(nullif(homepage, ''), 'Need to call')
FROM suppliers;

/* WINDOW Function */
SELECT *,
<function> OVER (partition by field)
FROM ...

/* include average price grouped by category */
SELECT categoryname, productname, unitprice,
avg(unitprice) over (partition by categoryname)
FROM products
JOIN categories USING categoryid

/* Rank with window functions */
SELECT * FROM
(
  SELECT orders.orderid, productid, unitprice, quantity
  rank() over (partition by order_details.orderid order by (quantity * unitprice) desc) as rank_amount
  FROM orders
  NATURAL JOIN order_details
)
WHERE rank_amount <= 2;

/* FUNCTIONS */
/* syntax for the simplest function */

CREATE OR REPLACE name() RETURNS void AS $$
...statement...
$$ LANGUAGE SQL

/* Returning a single value */
CREATE OR REPLACE name() RETURNS <type> AS $$
...select statement...
$$ LANGUAGE SQL

/* Functions with parameters */
CREATE OR REPLACE FUNCTION name(param1 type, param2 type, ...) RETURNS type AS $$
...
$$ LANGUAGE SQL

/* Functions with output parameters */
CREATE FUNCTION name (IN x int, IN y int, OUT sum int)

CREATE OR REPLACE FUNCTION sum_n_product(x int, y int, OUT sum int, OUT product int) AS $$
SELECT x + y, x * y
$$ LANGUAGE SQL

/* same as  */
CREATE TYPE sum_prod AS (sum int, product int);
CREATE FUNCTION sum_n_product(x int, y int) RETURNS sum_prod

/* Functions with default values */
/* if there is one parameter with a default, everything after must also have a default */
CREATE OR REPLACE FUNCTION name(a int, b int DEFAULT 2, c int DEFAULT 7)

/* Using functions as a table source */
SELECT column1, column2, ... FROM some_function();

/* Functions that return more than one row */
CREATE FUNCTION name() RETURNS SETOF type AS $$

CREATE OR REPLACE FUNCTION suppliers_to_reorder_from()
RETURNS SETOF suppliers AS $$

/* Or for multiple parameters */
CREATE FUNCTION name(x int, OUT sum int, OUT product int) RETURN SETOF record AS

/* Another way to return a set */
Syntax RETURNS TABLE(columns)
CREATE FUNCTION name (params) RETURNS TABLE(params)
/* Must list out all of the return parameters */
CREATE OR REPLACE FUNCTION next_birthday() 
RETURNS TABLE(birthday date, firstname varchar(10), hiredate date) AS $$

/* Procedures - Same as functions but don't return any values */
CREATE OR REPLACE PROCEDURE name(param list) AS $$
...statements...
$$ LANGUAGE SQL

CREATE OR REPLACE PROCEDURE add_em(x int, y int) AS $$
SELECT x + y
$$ LANGUAGE SQL

CALL add_em(5, 10)


/* Recursive CTE statement */

WITH RECURSIVE name(field1, field2, ...) AS (
  ...select statement that returns definite value...
  UNION ALL
  ...select statement that combines with the first statement...
)

WITH RECURSIVE countfifty(num) AS (
  SELECT 0
  UNION ALL
  SELECT num + 1 FROM countfifty
  WHERE num < 49
)
SELECT * FROM countfifty

WITH RECURSIVE downfrom(n) AS (
  SELECT 500
  UNION ALL
  SELECT num - 2 FROM downfrom
  WHERE num > 2
)

WITH RECURSIVE manager(firstname, lastname, title, employeeid, reportsto, level) AS (
  SELECT firstname, lastname, title, employeeid, reportsto, 0
  FROM employees
  // narrow down by top manager like CEO's id of 200
  WHERE employeeid = 200
  UNION ALL
  SELECT managed.firstname, managed.lastname, managed.title, managed.employeeid, managed.reportsto, level + 1
  FROM employees AS managed
  // join into the CTE on the relevant field
  JOIN manager ON managed.reportsto = manager.employeeid
)
SELECT * FROM manager;
