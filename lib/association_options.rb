# frozen_string_literal: true

# Class for setting model and table names at runtime
class AssociationOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    @class_name.constantize
  end

  def table_name
    "#{model_class.underscore}s"
  end
end

# Class for defining one model's ownership of another via foreign keys
class BelongsToOptions < AssociationOptions
  def initialize(name, options = {})
    defaults = { foreign_key: "#{name}_id".to_sym,
                 class_name: name.to_s.camelcase,
                 primary_key: :id }
    options = defaults.merge(options)
    options.each_key { |key| send("#{key}=", options[key]) }
  end
end

# Class for defining models with a foreign key corresponding to the current one
class HasManyOptions < AssociationOptions
  def initialize(name, self_class_name, options = {})
    name = name.to_s
    defaults = { foreign_key: "#{self_class_name.underscore}_id".to_sym,
                 class_name: name.to_s.singularize.camelcase,
                 primary_key: :id }
    options = defaults.merge(options)
    options.each_key { |key| send("#{key}=", options[key]) }
  end
end
