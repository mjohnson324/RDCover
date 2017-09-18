require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def initialize(params = {})
    params.each do |attribute, value|
      symbolized_attribute = attribute.to_sym
      if table_class.columns.include?(symbolized_attribute)
        self.send("#{symbolized_attribute}=", value)
      else
        raise "Unknown attribute '#{attribute}'"
      end
    end
  end

  def self.table_name
    @table_name ||= "#{self}".tableize
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
        #{table_name}
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
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{table_class.table_name} (#{column_names_string})
      VALUES
        (#{values_to_store})
      SQL
    self.id = DBConnection.last_insert_row_id
  end

  def save
    id.nil? ? insert : update
  end

  def update
    my_values = attribute_values[1..-1]
    DBConnection.execute(<<-SQL, *my_values, id)
      UPDATE
        #{table_class.table_name}
      SET
        #{values_to_update}
      WHERE
        id = ?
    SQL
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

  private

  def column_names_string
    my_class = table_class
    my_class.columns[1..-1].join(",")
  end

  def values_to_store
    my_columns = table_class.columns
    (["?"] * my_columns[1..-1].size).join(",")
  end

  def values_to_update
    table_columns = table_class.columns
    table_columns[1..-1].map do |column|
      "#{column} = ?"
    end.join(", ")
  end

  def table_class
    self.class
  end
end
