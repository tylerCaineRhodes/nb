CREATE OR REPLACE TEMPORARY TABLE table_schema (Path varchar(255), Type varchar(255), Count number);

SET system_name = 'strongmind_central';
SET snake_case = 'teacher_post_engagement_insight';
SET message_noun = 'StrongMind.Central.Insights.TeacherPostEngagementInsight';

INSERT INTO table_schema
select regexp_replace(f.path, '\\[[0-9]+\\]', '[]') as "Path",
       typeof(f.value)                              as "Type",
       count(*)                                     as "Count"

from datapipeline_prod.public.messages,
     lateral flatten(input => message, recursive=>true) f
where message:noun::string = $message_noun
group by 1, 2
order by 1, 2;

--SELECT * FROM table_schema;

WITH 
columns AS (
    SELECT LOWER(SPLIT_PART(path, '.', -1)) AS column_alias,
        type,
        path
    FROM table_schema
    WHERE path NOT LIKE '%[]' AND type != 'OBJECT' AND type != 'NULL_VALUE'
),
columns_defs AS (
    SELECT 
        column_alias,
        'message:' || REPLACE(path, '.', ':') || '::' || 
        type || ' AS ' || 
        column_alias AS column_definition,
        column_alias || ' ' || type AS table_column_definition,
        't.' || column_alias || ' = s.' || column_alias AS column_set_statement,
        't.' || column_alias AS column_target_aliased,
        's.' || column_alias AS column_source_aliased
    FROM columns
),
sql_statements as (
SELECT 'SELECT DISTINCT ' || LISTAGG(column_definition, ',\n    ') || 
       '\nFROM datapipeline_prod.public.messages\nWHERE noun::STRING = \'' || $message_noun || '\';' AS sql_statement, 1 as sql_order
FROM columns_defs
UNION ALL
SELECT 'create stream staging.' || $system_name || '.elt_' || $snake_case || ' on table datapipeline_prod.public.messages;', 2
UNION ALL
SELECT 'create table staging.' || $system_name || '.' || $snake_case || '(\n    ' || LISTAGG(table_column_definition, ',\n    ') || ');', 3
FROM columns_defs
UNION ALL
SELECT 'create
or replace task staging.strongmind_central.elt_' || $snake_case || ' --remember prepend _elt
	warehouse=INTERNAL_ENGINEERING
	schedule=\'USING CRON 15 9 * * * UTC\'
	as; --this is here to test merge works, once ok remove and rerun to setup task
MERGE INTO staging.' || $system_name || '.' || $snake_case || ' t
    USING
        (select distinct
                ' || LISTAGG(column_alias, ',\n                ') || '
         from (
                  select distinct 
                            ' || LISTAGG(column_definition, ',\n                            ') || '
              from datapipeline_prod.public.messages
               where message:noun::string = \'' || $message_noun || '\'
              )) s
--CHANGE THIS JOIN TO MATCH WHAT YOU NEED (you probably do not need to change this)
    on t.identifiers_id = s.identifiers_id
        and t.action = s.action
        AND t.message_timestamp = s.message_timestamp
        WHEN MATCHED THEN UPDATE
SET 
' || LISTAGG(column_set_statement, ',\n') || '
WHEN NOT MATCHED THEN INSERT
(
' || LISTAGG(column_target_aliased, ',\n') || '
)
VALUES
(
' || LISTAGG(column_source_aliased, ',\n') || '
);', 4
FROM columns_defs
UNION ALL
SELECT 'alter task staging.' || $system_name || '.elt_' || $snake_case || ' resume;', 5
)
SELECT sql_statement FROM sql_statements ORDER BY sql_order;
