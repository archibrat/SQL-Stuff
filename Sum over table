/* --This is the example of creating working SELECT query for summarazing all integer columns
WITH tmp AS (
   SELECT 'schemaname'::text AS schema  -- change for your schema 
         ,'tablename'::text AS tbl      --change for needed table name
   )
SELECT 'SELECT ' || string_agg('sum(' || quote_ident(column_name)
                 || ') AS sum_' || quote_ident(column_name), ', ')
       || E'\n FROM   ' || quote_ident(tmp._schema) || '.' || quote_ident(tmp._tbl)
FROM   tmp, information_schema.columns
WHERE  table_schema = _schema
AND    table_name = tbl
AND    data_type = 'integer'
GROUP  BY tmp.schema, tmp.tbl;
*/
--To get 
CREATE OR REPLACE FUNCTION sum_over_table(schema text, tbl text)
  RETURNS TABLE(names text[], sum bigint[]) AS
$BODY$
BEGIN

RETURN QUERY EXECUTE (
    SELECT 'SELECT ''{'
           || string_agg(quote_ident(c.column_name), ', ' ORDER BY c.column_name)
           || '}''::text[],
           ARRAY['
           || string_agg('sum(' || quote_ident(c.column_name) || ')'
                                                   , ', ' ORDER BY c.column_name)
           || ']
    FROM   '
           || quote_ident(schema) || '.' || quote_ident(tbl)
    FROM   information_schema.columns c
    WHERE  table_schema = schema
    AND    table_name = tbl
    AND    data_type = 'integer'
    );

END;
$BODY$
  LANGUAGE plpgsql;
  
  -------To get a readable data  query should look like below:
  SELECT unnest(names) AS name, unnest (sums) AS col_sum
FROM   f_get_sums('public', 'somereport');
  
