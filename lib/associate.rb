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
end

class HasManyOptions < AssociationOptions
end

module Associates
end

class SQLObject
  extend Associates
end
