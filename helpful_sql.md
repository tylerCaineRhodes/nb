# helpful sql

-- find the creation schema for any table/view (MUST BE RUN IN TERMINAL, NOT PSQL)
pg_dump -d $PUPPY_DATABASE_URL -t 'wells' --schema-only

-- find the creation schema for a function that doesn't have arguments (MUST BE IN PSQL)
SELECT pg_get_functiondef('newest_hire()'::regprocedure);

-- find currently running processes
SELECT * FROM pg_stat_activity WHERE state = 'active';

-- polite way to stop
SELECT pg_cancel_backend(PID);

-- stop at all costs - can lead to full database restart
SELECT pg_terminate_backend(PID);

--stop sql FROM using more than one process
set max_parallel_workers_per_gather = 0 ;

-- how to see table size
SELECT pg_relation_size('TABLE_NAME');

-- table_ size in a readable format
SELECT pg_size_pretty(pg_relation_size('TABLE_NAME'));

--WHERE to find the relation pages
SELECT relpages FROM pg_class
WHERE relname = 'TABLE_NAME';

--you can also find relation page sizes by dividing table size by 8192
SELECT pg_relation_size('TABLE_NAME') / 8192 FROM pg_class
WHERE relname = 'TABLE_NAME';


SELECT reltuples FROM pg_class WHERE relname = 'TABLE_NAME';

--cost of setting up each thread
show parallel_setup_cost;

--cost of communicating each row
show parallel_tuple_cost;

-- search for schemas and tables with a certain column
SELECT t.table_schema, t.table_name
FROM information_schema.tables t
INNER JOIN information_schema.columns c ON c.table_name = t.table_name 
AND c.table_schema = t.table_schema
WHERE c.column_name = COL_NAME

-- index for a fuzzy text search with a trigram
CREATE extension pg_trgm;
CREATE INDEX trgm_idx_performance_test_location ON performance_test USING gin (location gin_trgm_ops);

-- CTE using recursion
  -- counting to 50
  WITH recursion upto(t) AS (
    SELECT 1
    UNION ALL
    SELECT t + 1 FROM upto
    WHERE t < 50
  )
  SELECT * FROM upto;

  --find all employees that report to the CEO and down the management chain (level prints the level in the call)
  with recursion find_employees(firstname, lastname, title, employeeid, reportsto, level) as (
    select firstname, lastname, title, employeeid, reportsto, 0 from employees
	  where employeeid = 200
    union all
    select e.firstname, e.lastname, e.title, e.employeeid, e.reportsto, level + 1
    from employees as e
    join find_employees on e.reportsto = find_employees.employeeid
  )
  select * from find_employees;

