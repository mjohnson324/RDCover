require_relative 'search'
require 'active_support/inflector'

class AssociationOptions
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
