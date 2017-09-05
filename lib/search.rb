require_relative 'db_connection'
require_relative 'sql_object'

module Search
  def where(params)
  end
end

class SQLObject
  extend Search
end
