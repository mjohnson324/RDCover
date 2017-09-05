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
        #{table_name}
      LIMIT
        1
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
    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    parse_all(data)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    object = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
      LIMIT
        1
    SQL
    object[0] ? new(object[0]) : nil
  end

  def insert
    my_class = self.class
    column_names = my_class.columns[1..-1].join(",")
    values_to_store = (["?"] * my_class.columns[1..-1].size).join(",")
    my_values = attribute_values
    DBConnection.execute(<<-SQL, *my_values)
      INSERT INTO
        #{my_class.table_name} (#{column_names})
      VALUES
        (#{values_to_store})
      SQL
    self.id = DBConnection.last_insert_row_id
  end

  def save
    id.nil? ? insert : update
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
