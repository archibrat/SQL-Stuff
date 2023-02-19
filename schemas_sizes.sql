CREATE VIEW AS public.schemas_sizes
SELECT  schema_name
       ,pg_size_pretty(SUM(table_size)::bigint)                                 AS pretty_size
       ,SUM(table_size)::bigint                                                 AS size_in_bytes
       ,trunc((SUM(table_size) / pg_database_size(current_database())) * 100,2) AS percent
FROM
(
	SELECT  pg_catalog.pg_namespace.nspname           AS schema_name
	       ,pg_relation_size(pg_catalog.pg_class.oid) AS table_size
	FROM pg_catalog.pg_class
	JOIN pg_catalog.pg_namespace
	ON relnamespace = pg_catalog.pg_namespace.oid
) t
GROUP BY  schema_name
ORDER BY percent desc