require_relative 'rdcover'

# pets: id, name, owner_id
# characters, id, fname, lname, house_id
# homes: id, address

class Pet < SQLObject
  belongs_to :character
  has_one_through :house, :character, :home
end

class Character < SQLObject
  has_many :pets
  belongs_to :home
end

class Home < SQLObject
  has_many :characters
end
