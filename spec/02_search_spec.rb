require 'search'

describe 'Search' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Pet < DataWrapper
      finalize!
    end

    class Character < DataWrapper
      self.table_name = 'characters'

      finalize!
    end
  end

  it '#where searches with single criterion' do
    pets = Pet.where(name: 'Santas Little Helper')
    pet = pets.first

    expect(pets.length).to eq(1)
    expect(pet.name).to eq('Santas Little Helper')
  end

  it '#where can return multiple objects' do
    characters = Character.where(house_id: 1)
    expect(characters.length).to eq(2)
  end

  it '#where searches with multiple criteria' do
    characters = Character.where(fname: 'Lisa', house_id: 1)
    expect(characters.length).to eq(1)

    character = characters[0]
    expect(character.fname).to eq('Lisa')
    expect(character.house_id).to eq(1)
  end

  it '#where returns [] if nothing matches the criteria' do
    expect(Character.where(fname: 'Nowhere', lname: 'Man')).to eq([])
  end
end
