# common extension method
class X
  BACK_SUFFIX = '_bak'.freeze
  MAIN_ID = 'id'.freeze

  # @note backup a table
  def self.table_backup(table, *ids)
    if table.class == String
      table_name = table
      clear = false
    else
      table_name = table[:table]
      clear = table[:clear]
    end
    table_backup = table_name + BACK_SUFFIX

    ids.flatten!
    puts 'warning: backup whole table?' if ids.empty?

    puts table_backup, clear
    dbc = ActiveRecord::Base.connection
    puts "make backup to #{dbc.current_database}@#{table_backup}"
    if clear
      dbc.execute('DROP TABLE IF EXISTS ' + table_backup) if clear
    end

    sql = "CREATE TABLE IF NOT EXISTS `#{table_backup}` LIKE `#{table_name}`"
    dbc.execute(sql)

    sql = "DELETE FROM #{table_backup}" + _where_in(MAIN_ID, ids)
    dbc.execute(sql)

    sql = "INSERT INTO #{table_backup} SELECT * FROM #{table_name}" +
        _where_in(MAIN_ID, ids)

    dbc.execute(sql)
  end

  # restore info from backup table.
  def self.table_restore(table, *ids)
    table_backup = table + BACK_SUFFIX
    dbc = ActiveRecord::Base.connection
    ids.flatten!

    dbc.transaction do
      no_foreign_check
      sql = %{
      DELETE FROM	`#{table}` WHERE id IN (
        SELECT #{MAIN_ID} FROM `#{table_backup}`#{_where_in(MAIN_ID, ids)}
      );
      }
      dbc.execute(sql)
      foreign_check

      sql = "INSERT INTO #{table} SELECT * FROM #{table_backup}" +
          _where_in(MAIN_ID, ids)
      dbc.execute(sql)
    end

    'ok'
  end

  def self.foreign_check
    ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1')
  end

  def self.no_foreign_check
    ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0')
  end

  def self._where_in(column, values)
    v = _in(column, values)
    return '' if values.blank?

    ' WHERE' + v
  end

  def self._in(column, values)
    return '' if values.blank?

    " #{column} IN (" + values.join(',') + ')'
  end


  # redis
  #
  def self.pdel(pattern)
    return "pattern can't be nil" if pattern.blank?

    script = <<EOF
      local ret = redis.call('KEYS', KEYS[1])
      for _,v in ipairs(ret) do
         redis.call('DEL', v)
      end
      return #ret
EOF

    $redis.eval(script, [pattern])
  end

end