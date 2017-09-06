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
                 primary_key: :id }
    options = defaults.merge(options)
    options.each_key { |key| send("#{key}=", options[key]) }
  end
end

class HasManyOptions < AssociationOptions
  def initialize(name, self_class_name, options = {})
    name = name.to_s
    defaults = { foreign_key: "#{self_class_name}_id".underscore.to_sym,
                 class_name: name.singularize.camelcase,
                 primary_key: :id }
    options = defaults.merge(options)
    options.each_key { |key| send("#{key}=", options[key]) }
  end
end

module Associates
  def belongs_to(name, options = {})
    belong_options = BelongsToOptions.new(name, options)
    define_method(name) do

    end
  end

  def has_many(name, options = {})
    owning_options = HasManyOptions.new(name, options)
    define_method(name) do
      
    end
  end
end

class SQLObject
  extend Associates
end
