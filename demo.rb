require_relative 'lib/data_cover'

ROOT_FOLDER = File.join(File.dirname(__FILE__), '/')
SQL_FILE = File.join(ROOT_FOLDER, 'simpsons.sql')
DB_FILE = File.join(ROOT_FOLDER, 'simpsons.db')
DBConnection.open(DB_FILE)
# pets: id, name, owner_id
# characters, id, fname, lname, house_id
# homes: id, address

class Pet < DataCover
  belongs_to :character
  has_one_through :house, :character, :home
end

class Character < DataCover
  has_many :pets
  belongs_to :home
end

class Home < DataCover
  has_many :characters
end
