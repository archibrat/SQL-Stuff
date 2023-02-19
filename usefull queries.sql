-- show running queries (9.2)
SELECT  pid
       ,age(clock_timestamp(),query_start)
       ,usename
       ,query
FROM pg_stat_activity
WHERE query != '<IDLE>'
AND query NOT ILIKE '%pg_stat_activity%'
ORDER BY query_start desc;

-- kill running query
SELECT  pg_cancel_backend(procpid);

-- kill idle query
SELECT  pg_terminate_backend(procpid);

-- vacuum command VACUUM (VERBOSE,ANALYZE);
-- all database users
SELECT  *
FROM pg_stat_activity
WHERE current_query not like '<%';

-- all databases
AND their sizes
SELECT  *
FROM pg_user;

-- all tables AND their size, with/without indexes
SELECT  datname
       ,pg_size_pretty(pg_database_size(datname))
FROM pg_database
ORDER BY pg_database_size(datname) desc;

-- cache hit rates (should not be less than 0.99)
SELECT  SUM(heap_blks_read)                                             AS heap_read
       ,SUM(heap_blks_hit)                                              AS heap_hit
       ,(SUM(heap_blks_hit) - SUM(heap_blks_read)) / SUM(heap_blks_hit) AS ratio
FROM pg_statio_user_tables;

-- TABLE index usage rates (should not be less than 0.99)
SELECT  relname
       ,100 * idx_scan / (seq_scan + idx_scan) percent_of_times_index_used
       ,n_live_tup rows_in_table
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;

-- how many indexes are IN cache
SELECT  SUM(idx_blks_read)                                           AS idx_read
       ,SUM(idx_blks_hit)                                            AS idx_hit
       ,(SUM(idx_blks_hit) - SUM(idx_blks_read)) / SUM(idx_blks_hit) AS ratio
FROM pg_statio_user_indexes;

-- Script to kill all running connections of a current database
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE datname = current_database()  
  AND pid <> pg_backend_pid();
