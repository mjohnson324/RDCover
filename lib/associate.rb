require_relative 'association_options'

module Associates
  def belongs_to(name, options = {})
    belong_options = BelongsToOptions.new(name, options)
    @association_options = { name => belong_options }
    define_method(name) do
      foreign_key = self.send(belong_options.foreign_key)
      owner_class = belong_options.model_class
      primary_key = belong_options.primary_key
      owner_class.where(primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    owning_options = HasManyOptions.new(name, options)
    define_method(name) do
      foreign_key = owning_options.foreign_key
      owned_class = owning_options.model_class
      primary_key = self.send(having_association.primary_key)
      owned_class.where(foreign_key => primary_key)
    end
  end

  def association_options
    @association_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      instance = self
      tables_info = self.class.send(
        :through_and_source, through_name, source_name
      )
      results = self.class.send(
        :through_source_join, instance, tables_info.first, tables_info.last
      )
      source_name = source_name.to_s.singularize
      source_class = source_name.camelcase.constantize
      source_class.parse_all(results).first
    end
  end

  private

  def through_and_source(through_name, source_name)
    through_options = self.assoc_options[through_name]
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

class SQLObject
  extend Associates
end
