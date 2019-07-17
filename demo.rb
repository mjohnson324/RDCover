# frozen_string_literal: true

require_relative 'lib/associations.rb'

# Pets from The Simpsons tv show
class Pet < DataWrapper
  belongs_to :owner,
             class_name: 'Character',
             foreign_key: :owner_id,
             primary_key: :id

  has_one_through :home, :character, :house

  finalize!
end

# Characters from The Simpsons
class Character < DataWrapper
  has_many :pets,
           class_name: 'Pet',
           foreign_key: :owner_id,
           primary_key: :id

  belongs_to :house,
             class_name: 'House',
             foreign_key: :house_id,
             primary_key: :id

  finalize!
end

# Homes from The Simpsons
class House < DataWrapper
  has_many :characters,
           class_name: 'Character',
           foreign_key: :house_id,
           primary_key: :id

  finalize!
end
