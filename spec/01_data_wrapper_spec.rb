require 'data_wrapper'
require 'db_connection'
require 'securerandom'

describe DataWrapper do
  before(:each) { DBConnection.reset }
  after(:each) { DBConnection.reset }

  context 'before ::finalize!' do
    before(:each) do
      class Pet < DataWrapper
      end
    end

    after(:each) do
      Object.send(:remove_const, :Pet)
    end

    describe '::table_name' do
      it 'generates default name' do
        expect(Pet.table_name).to eq('pets')
      end
    end

    describe '::table_name=' do
      it 'sets table name' do
        class Character < DataWrapper
          self.table_name = 'characters'
        end

        expect(Character.table_name).to eq('characters')

        Object.send(:remove_const, :Character)
      end
    end

    describe '::columns' do
      it 'returns a list of all column names as symbols' do
        expect(Pet.columns).to eq([:id, :name, :owner_id])
      end

      it 'only queries the DB once' do
        expect(DBConnection).to(
          receive(:execute2).exactly(1).times.and_call_original)
        3.times { Pet.columns }
      end
    end

    describe '#attributes' do
      it 'returns @attributes hash byref' do
        pet_attributes = {name: 'Gizmo'}
        c = Pet.new
        c.instance_variable_set('@attributes', pet_attributes)

        expect(c.attributes).to equal(pet_attributes)
      end

      it 'lazily initializes @attributes to an empty hash' do
        c = Pet.new

        expect(c.instance_variables).not_to include(:@attributes)
        expect(c.attributes).to eq({})
        expect(c.instance_variables).to include(:@attributes)
      end
    end
  end

  context 'after ::finalize!' do
    before(:all) do
      class Pet < DataWrapper
        self.finalize!
      end

      class Character < DataWrapper
        self.table_name = 'characters'

        self.finalize!
      end
    end

    after(:all) do
      Object.send(:remove_const, :Pet)
      Object.send(:remove_const, :Character)
    end

    describe '::finalize!' do
      it 'creates getter methods for each column' do
        c = Pet.new
        expect(c.respond_to? :something).to be false
        expect(c.respond_to? :name).to be true
        expect(c.respond_to? :id).to be true
        expect(c.respond_to? :owner_id).to be true
      end

      it 'creates setter methods for each column' do
        c = Pet.new
        c.name = "Nick Diaz"
        c.id = 209
        c.owner_id = 2
        expect(c.name).to eq 'Nick Diaz'
        expect(c.id).to eq 209
        expect(c.owner_id).to eq 2
      end

      it 'created getter methods read from attributes hash' do
        c = Pet.new
        c.instance_variable_set(:@attributes, {name: "Nick Diaz"})
        expect(c.name).to eq 'Nick Diaz'
      end

      it 'created setter methods use attributes hash to store data' do
        c = Pet.new
        c.name = "Nick Diaz"

        expect(c.instance_variables).to include(:@attributes)
        expect(c.instance_variables).not_to include(:@name)
        expect(c.attributes[:name]).to eq 'Nick Diaz'
      end
    end

    describe '#initialize' do
      it 'calls appropriate setter method for each item in params' do
        # We have to set method expectations on the pet object *before*
        # #initialize gets called, so we use ::allocate to create a
        # blank Pet object first and then call #initialize manually.
        c = Pet.allocate

        expect(c).to receive(:name=).with('Don Frye')
        expect(c).to receive(:id=).with(100)
        expect(c).to receive(:owner_id=).with(4)

        c.send(:initialize, {name: 'Don Frye', id: 100, owner_id: 4})
      end

      it 'throws an error when given an unknown attribute' do
        expect do
          Pet.new(favorite_band: 'Anybody but The Eagles')
        end.to raise_error "unknown attribute 'favorite_band'"
      end
    end

    describe '::all, ::parse_all' do
      it '::all returns all the rows' do
        pets = Pet.all
        expect(pets.count).to eq(5)
      end

      it '::parse_all turns an array of hashes into objects' do
        hashes = [
          { name: 'pet1', owner_id: 1 },
          { name: 'pet2', owner_id: 2 }
        ]

        pets = Pet.parse_all(hashes)
        expect(pets.length).to eq(2)
        hashes.each_index do |i|
          expect(pets[i].name).to eq(hashes[i][:name])
          expect(pets[i].owner_id).to eq(hashes[i][:owner_id])
        end
      end

      it '::all returns a list of objects, not hashes' do
        pets = Pet.all
        pets.each { |pet| expect(pet).to be_instance_of(Pet) }
      end
    end

    describe '::find' do
      it 'fetches single objects by id' do
        c = Pet.find(1)

        expect(c).to be_instance_of(Pet)
        expect(c.id).to eq(1)
      end

      it 'returns nil if no object has the given id' do
        expect(Pet.find(123)).to be_nil
      end
    end

    describe '#attribute_values' do
      it 'returns array of values' do
        pet = Pet.new(id: 123, name: 'pet1', owner_id: 1)

        expect(pet.attribute_values).to eq([123, 'pet1', 1])
      end
    end

    describe '#insert' do
      let(:pet) { Pet.new(name: 'Gizmo', owner_id: 1) }

      before(:each) { pet.insert }

      it 'inserts a new record' do
        expect(Pet.all.count).to eq(6)
      end

      it 'sets the id once the new record is saved' do
        expect(pet.id).to eq(DBConnection.last_insert_row_id)
      end

      it 'creates a new record with the correct values' do
        # pull the pet again
        pet2 = Pet.find(pet.id)

        expect(pet2.name).to eq('Gizmo')
        expect(pet2.owner_id).to eq(1)
      end
    end

    describe '#update' do
      it 'saves updated attributes to the DB' do
        character = Character.find(2)

        character.fname = 'Lisa'
        character.lname = 'Simpson'
        character.update

        # pull the character again
        character = Character.find(2)
        expect(character.fname).to eq('Lisa')
        expect(character.lname).to eq('Simpson')
      end
    end

    describe '#save' do
      it 'calls #insert when record does not exist' do
        character = Character.new
        expect(character).to receive(:insert)
        character.save
      end

      it 'calls #update when record already exists' do
        character = Character.find(1)
        expect(character).to receive(:update)
        character.save
      end
    end
  end
end
