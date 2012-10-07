-- Indexes

SELECT 
  relname,                         
  100 * idx_scan / (seq_scan + idx_scan) percent_of_times_index_used, 
  n_live_tup rows_in_table
FROM 
  pg_stat_user_tables 
ORDER BY 
  n_live_tup DESC;


--        relname       | percent_of_times_index_used | rows_in_table 
-- ---------------------+-----------------------------+---------------
--  taggings            |                          99 |          8762
--  attachments         |                          99 |          2483
--  items               |                          94 |          1729
--  item_stats          |                          93 |          1704
--  queries             |                          81 |          1534
--  shares              |                          85 |          1453
--  email_deliveries    |                          84 |          1212
--  comments            |                          99 |           550
--  job_stats           |                          61 |           515
--  tags                |                          72 |           309
--  versions            |                          74 |           290
--  contacts            |                           2 |           111
--  roles_users         |                             |            82
--  schema_migrations   |                           0 |            77
--  users               |                          43 |            68
--  subscriptions       |                           0 |            30
--  links               |                           0 |            21
--  simple_captcha_data |                           0 |            15
--  categories          |                           0 |            10
--  languages           |                           0 |             9
--  roles               |                           0 |             7
--  documents           |                           0 |             7
--  pages               |                           0 |             6
--  scores              |                           0 |             0
--  settings            |                           0 |             0
-- (25 rows)
