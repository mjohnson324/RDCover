# frozen_string_literal: true

require_relative 'db_connection'
require_relative 'data_wrapper'

# Module for performing basic search queries
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
    column_names.map { |column| "#{column} = ?" }.join(' AND ')
  end
end

# Already defined
class DataWrapper
  extend Search
end
