require 'associations'

describe 'Options' do
  describe 'BelongsToOptions' do
    it 'provides defaults' do
      options = BelongsToOptions.new('house')

      expect(options.foreign_key).to eq(:house_id)
      expect(options.class_name).to eq('House')
      expect(options.primary_key).to eq(:id)
    end

    it 'allows overrides' do
      options = BelongsToOptions.new('owner',
                                     foreign_key: :characters_id,
                                     class_name: 'Character',
                                     primary_key: :characters_id
      )

      expect(options.foreign_key).to eq(:characters_id)
      expect(options.class_name).to eq('Character')
      expect(options.primary_key).to eq(:characters_id)
    end
  end

  describe 'HasManyOptions' do
    it 'provides defaults' do
      options = HasManyOptions.new('pets', 'Character')

      expect(options.foreign_key).to eq(:character_id)
      expect(options.class_name).to eq('Pet')
      expect(options.primary_key).to eq(:id)
    end

    it 'allows overrides' do
      options = HasManyOptions.new('pets', 'Character',
                                   foreign_key: :owner_id,
                                   class_name: 'Kitten',
                                   primary_key: :characters_id
      )

      expect(options.foreign_key).to eq(:owner_id)
      expect(options.class_name).to eq('Kitten')
      expect(options.primary_key).to eq(:characters_id)
    end
  end

  describe 'Options' do
    before(:all) do
      class Pet < DataWrapper
        self.finalize!
      end

      class Character < DataWrapper
        self.finalize!
      end
    end

    it '#model_class returns class of associated object' do
      options = BelongsToOptions.new('character')
      expect(options.model_class).to eq(Character)

      options = HasManyOptions.new('pets', 'Character')
      expect(options.model_class).to eq(Pet)
    end

    it '#table_name returns table name of associated object' do
      options = BelongsToOptions.new('character')
      expect(options.table_name).to eq('characters')

      options = HasManyOptions.new('pets', 'Character')
      expect(options.table_name).to eq('pets')
    end
  end
end

describe 'Associatable' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Pet < DataWrapper
      belongs_to :character, foreign_key: :owner_id

      finalize!
    end

    class Character < DataWrapper
      has_many :pets, foreign_key: :owner_id
      belongs_to :house

      finalize!
    end

    class House < DataWrapper
      has_many :characters

      finalize!
    end
  end

  describe '#belongs_to' do
    let(:santaslittlehelper) { Pet.find(1) }
    let(:bart) { Character.find(1) }

    it 'fetches `character` from `Pet` correctly' do
      expect(santaslittlehelper).to respond_to(:character)
      character = santaslittlehelper.character

      expect(character).to be_instance_of(Character)
      expect(character.fname).to eq('Bart')
    end

    it 'fetches `house` from `Character` correctly' do
      expect(bart).to respond_to(:house)
      house = bart.house

      expect(house).to be_instance_of(House)
      expect(house.address).to eq('742 Evergreen Terrace')
    end

    it 'returns nil if no associated object' do
      stray_pet = Pet.find(5)
      expect(stray_pet.character).to eq(nil)
    end
  end

  describe '#has_many' do
    let(:bart) { Character.find(1) }
    let(:bart_house) { House.find(1) }

    it 'fetches `pets` from `Character`' do
      expect(bart).to respond_to(:pets)
      pets = bart.pets

      expect(pets.length).to eq(1)

      expected_pet_names = ["Santas Little Helper"]
      1.times do |i|
        pet = pets[i]
        expect(pet).to be_instance_of(Pet)
        expect(pet.name).to eq(expected_pet_names[i])
      end
    end

    it 'fetches `characters` from `House`' do
      expect(bart_house).to respond_to(:characters)
      characters = bart_house.characters

      expect(characters.length).to eq(2)
      expect(characters[0]).to be_instance_of(Character)
      expect(characters[0].fname).to eq('Bart')
    end

    it 'returns an empty array if no associated items' do
      willie = Character.find(4)
      expect(willie.pets).to eq([])
    end
  end
end

describe 'Associatable' do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  before(:all) do
    class Pet < DataWrapper
      belongs_to :character, foreign_key: :owner_id

      finalize!
    end

    class Character < DataWrapper
      has_many :pets, foreign_key: :owner_id
      belongs_to :house

      finalize!
    end

    class House < DataWrapper
      has_many :characters

      finalize!
    end
  end

  describe '::assoc_options' do
    it 'defaults to empty hash' do
      class TempClass < DataWrapper
      end

      expect(TempClass.assoc_options).to eq({})
    end

    it 'stores `belongs_to` options' do
      pet_assoc_options = Pet.assoc_options
      character_options = pet_assoc_options[:character]

      expect(character_options).to be_instance_of(BelongsToOptions)
      expect(character_options.foreign_key).to eq(:owner_id)
      expect(character_options.class_name).to eq('Character')
      expect(character_options.primary_key).to eq(:id)
    end

    it 'stores options separately for each class' do
      expect(Pet.assoc_options).to have_key(:character)
      expect(Character.assoc_options).to_not have_key(:character)

      expect(Character.assoc_options).to have_key(:house)
      expect(Pet.assoc_options).to_not have_key(:house)
    end
  end

  describe '#has_one_through' do
    before(:all) do
      class Pet
        has_one_through :home, :character, :house

        self.finalize!
      end
    end

    let(:pet) { Pet.find(1) }

    it 'adds getter method' do
      expect(pet).to respond_to(:home)
    end

    it 'fetches associated `home` for a `Pet`' do
      house = pet.home

      expect(house).to be_instance_of(House)
      expect(house.address).to eq('742 Evergreen Terrace')
    end
  end
end