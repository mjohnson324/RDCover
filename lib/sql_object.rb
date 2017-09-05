require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def initialize
  end

  def self.table_name
    stringified_class_name = self.to_s
    @table_name ||= stringified_class_name.tableize
  end

  def self.table_name=(name)
    @table_name ||= name
  end

  def self.columns
    return @columns if @columns
    table_names = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT 1
    SQL
    @columns = table_names.first.map(&:to_sym)
  end

  def self.all
  end

  def self.find
  end

  def insert
  end

  def save
  end

  def update
  end
end
