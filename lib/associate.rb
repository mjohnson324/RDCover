require_relative 'search'

class AssociationOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    @class_name.constantize
  end

  def table_name
    "#{model_class.underscore}s"
  end
end

class BelongsToOptions < AssociationOptions
  def initialize(name, options = {})
    defaults = { foreign_key: "#{name}_id".to_sym,
                 class_name: name.to_s.camelcase,
                 primary_key: :id}

    options = defaults.merge(options)

    options.each_key { |key| send("#{key}=", options[key]) }
end

class HasManyOptions < AssociationOptions
end

module Associates
end

class SQLObject
  extend Associates
end
