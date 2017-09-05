require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def initialize(params = {})
    class_columns = self.class.columns
    params.each do |attribute, value|
      symbolized_attribute = attribute.to_sym
      if class_columns.include?(symbolized_attribute)
        self.send("#{symbolized_attribute}=", value)
      else
        raise "Unknown attribute '#{attribute}'"
      end
    end
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

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
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

  def self.finalize!
    columns.each do |column|
      define_method(column) do
        attributes[column]
      end
      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end
end
