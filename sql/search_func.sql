CREATE OR REPLACE FUNCTION find(COL_NAME) RETURNS TABLE
$BODY$
BEGIN
  SELECT t.table_schema, t.table_name
  FROM information_schema.tables t
  INNER JOIN information_schema.columns c ON c.table_name = t.table_name 
  AND c.table_schema = t.table_schema
  WHERE c.column_name = COL_NAME
END;
$BODY$ LANGUAGE plpgsql;
