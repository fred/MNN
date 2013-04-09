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
      100 * idx_scan / (seq_scan + greatest(1,idx_scan)) percent_of_times_index_used,
      n_live_tup rows_in_table
    FROM pg_stat_user_tables 
    ORDER BY n_live_tup DESC
    LIMIT #{lim};"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.heap_hit_ratio
    sql = "SELECT
      sum(heap_blks_read) as heap_read,
      sum(heap_blks_hit)  as heap_hit,
      (sum(heap_blks_hit) - sum(heap_blks_read)) / sum(heap_blks_hit) as ratio
    FROM
      pg_statio_user_tables;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.idx_hit_ratio
    sql = "SELECT
      sum(idx_blks_read) as idx_read,
      sum(idx_blks_hit)  as idx_hit,
      (sum(idx_blks_hit) - sum(idx_blks_read)) / sum(idx_blks_hit) as ratio
    FROM
      pg_statio_user_tables;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.stat_user_tables
    sql = 'select * from pg_stat_user_tables ORDER BY seq_scan DESC;'
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.stat_activity
    sql = "select * from pg_stat_activity where datname = 'mnn_production';"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.stat_bgwrite
    sql = "select * from pg_stat_bgwriter;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.statio
    sql = "select * from pg_statio_user_tables;"
    ActiveRecord::Base.connection.execute(sql)
  end


  def self.unused_indexes
    sql = "select indexrelid::regclass as index, relid::regclass as table 
      from pg_stat_user_indexes JOIN pg_index USING (indexrelid) 
      where idx_scan = 0 and indisunique is false order by relid::regclass;"
    ActiveRecord::Base.connection.execute(sql)
  end

  def self.duplicate_indexes
    sql = "
    select 
      a.indrelid::regclass, a.indexrelid::regclass as first_index, b.indexrelid::regclass as second_index
        from 
            (select *,array_to_string(indkey,' ') as cols from pg_index) a 
            join (select *,array_to_string(indkey,' ') as cols from pg_index) b on 
                ( a.indrelid=b.indrelid and a.indexrelid < b.indexrelid 
                and 
                    ( 
                        (a.cols LIKE b.cols||'%' and coalesce(substr(a.cols,length(b.cols)+1,1),' ')=' ') 
                        or 
                        (b.cols LIKE a.cols||'%' and coalesce(substr(b.cols,length(a.cols)+1,1),' ')=' ') 
                    ) 
                ) 
        order by indrelid;"
    ActiveRecord::Base.connection.execute(sql)
  end

end
