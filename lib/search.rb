module Search
  def where(params)
    filters = param_filters(params)
    results = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{filters}
    SQL
    parse_all(results)
  end

  private

  def param_filters(params)
    column_names = params.keys
    column_names.map { |column| "#{column} = ?" }.join(" AND ")
  end
end

class SQLObject
  extend Search
end
