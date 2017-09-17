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
    defaults = { foreign_key: "#{self_class_name.underscore}_id".to_sym,
                 class_name: name.to_s.singularize.camelcase,
                 primary_key: :id }
    options = defaults.merge(options)
    options.each_key { |key| send("#{key}=", options[key]) }
  end
end

module Associates
  def belongs_to(name, options = {})
    belong_options = BelongsToOptions.new(name, options)
    @association_options = { name => belong_options }
    define_method(name) do
      foreign_key = self.send(belong_options.foreign_key)
      owner_class = belong_options.model_class
      primary_key = belong_options.primary_key
      owner_class.where(primary_key => foreign_key)
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
    
  end
end

class SQLObject
  extend Associates
end
