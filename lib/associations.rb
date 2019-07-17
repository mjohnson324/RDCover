# frozen_string_literal: true

require_relative 'association_options'

# Defines common associations across SQL tables
module Associatable
  def belongs_to(name, options = {})
    belonging = BelongsToOptions.new(name, options)
    @assoc_options = { name => belonging }
    define_method(name) do
      f_key_value = send(belonging.foreign_key)
      owner_class = belonging.model_class
      p_key = belonging.primary_key
      owner_class.where(p_key => f_key_value).first
    end
  end

  def has_many(name, options = {})
    having_association = HasManyOptions.new(name, to_s, options)
    define_method(name) do
      foreign_key = having_association.foreign_key
      owned_class = having_association.model_class
      primary_key = send(having_association.primary_key)
      owned_class.where(foreign_key => primary_key)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      tables_info = self.class.send(
        :through_and_source, through_name, source_name
      )
      results = self.class.send(
        :through_source_join, self, tables_info.first, tables_info.last
      )
      source_name = source_name.to_s.singularize
      source_class = source_name.camelcase.constantize
      source_class.parse_all(results).first
    end
  end

  private

  def through_and_source(through_name, source_name)
    through_options = assoc_options[through_name]
    source_options = through_options.model_class.assoc_options[source_name]
    table_info = []
    [through_options, source_options].each do |options|
      table_info << { name: options.table_name,
                      p_key: options.primary_key,
                      f_key: options.foreign_key }
    end
    table_info
  end

  def through_source_join(instance, through, source)
    target_id = instance.send(through[:f_key])
    DBConnection.execute(<<-SQL, target_id)
    SELECT
      #{source[:name]}.*
    FROM
      #{through[:name]}
    JOIN
      #{source[:name]}
    ON
      #{through[:name]}.#{source[:f_key]} = #{source[:name]}.#{source[:p_key]}
    WHERE
      #{through[:name]}.#{through[:p_key]} = ?
    SQL
  end
end

# already defined
class DataWrapper
  extend Associatable
end
