# frozen_string_literal: true

require_relative 'lib/data_cover'

ROOT_FOLDER = File.join(File.dirname(__FILE__), '/')
SQL_FILE = File.join(ROOT_FOLDER, 'simpsons.sql')
DB_FILE = File.join(ROOT_FOLDER, 'simpsons.db')
DBConnection.open(DB_FILE)

# pets: id, name, owner_id
# characters, id, fname, lname, house_id
# homes: id, address

# Pets from The Simpsons tv show
class Pet < DataCover
  belongs_to :character,
             class_name: 'Character',
             foreign_key: :owner_id,
             primary_key: :id

  has_one_through :house, :character, :home

  Pet.finalize!
end

# Characters from The Simpsons
class Character < DataCover
  has_many :pets,
           class_name: 'Pet',
           foreign_key: :owner_id,
           primary_key: :id

  belongs_to :home,
             class_name: 'Home',
             foreign_key: :house_id,
             primary_key: :id

  Character.finalize!
end

# Settings from The Simpsons
class Home < DataCover
  has_many :characters,
           class_name: 'Character',
           foreign_key: :house_id,
           primary_key: :id

  Home.finalize!
end
