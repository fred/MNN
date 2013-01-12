class DbStats
  def self.biggest_relations(lim=20)
    sql = "
    SELECT nspname || '.' || relname AS \"relation\",
    pg_size_pretty(pg_total_relation_size(C.oid)) AS \"total_size\"
      FROM pg_class C
      LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
      WHERE nspname NOT IN ('pg_catalog', 'information_schema')
        AND C.relkind <> 'i'
        AND nspname !~ '^pg_toast'
      ORDER BY pg_total_relation_size(C.oid) DESC
      LIMIT #{lim};
    "
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.index_status(lim=20)
    sql = "
    SELECT relname,
      100 * idx_scan / (seq_scan + idx_scan) percent_of_times_index_used, 
      n_live_tup rows_in_table
    FROM pg_stat_user_tables 
    ORDER BY n_live_tup DESC
    LIMIT #{lim};"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.hit_ratio
    sql = "SELECT
      sum(heap_blks_read) as heap_read,
      sum(heap_blks_hit)  as heap_hit,
      (sum(heap_blks_hit) - sum(heap_blks_read)) / sum(heap_blks_hit) as ratio
    FROM
      pg_statio_user_tables;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.stat_user_tables
    sql = 'select * from pg_stat_user_tables;'
    ActiveRecord::Base.connection.execute(sql)
  end
end
