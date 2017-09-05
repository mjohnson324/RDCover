require_relative 'db_connection'
require_relative 'sql_object'

module Search
  def where(params)
    where_line = param_filters(params)
    results = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_line}
    SQL
    self.parse_all(results)
  end

  private

  def param_filters(params)
    column_names = params.keys
    column_names.map do |column|
      "#{column} = ?"
    end.join(" AND ")
  end
end

class SQLObject
  extend Search
end
