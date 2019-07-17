# frozen_string_literal: true

require_relative 'search'

# Sets association options
class Options
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    "#{class_name.underscore}s"
  end
end

# Defines belongs_to relation via foreign keys
class BelongsToOptions < Options
  def initialize(name, options = {})
    defaults = { foreign_key: "#{name}_id".to_sym,
                 class_name: name.to_s.camelcase,
                 primary_key: :id }
    options = defaults.merge(options)
    options.each_key { |key| send("#{key}=", options[key]) }
  end
end

# Defines has_many relation via foreign keys
class HasManyOptions < Options
  def initialize(name, self_class_name, options = {})
    defaults = { foreign_key: "#{self_class_name.underscore}_id".to_sym,
                 class_name: name.to_s.singularize.camelcase,
                 primary_key: :id }
    options = defaults.merge(options)
    options.each_key { |key| send("#{key}=", options[key]) }
  end
end
