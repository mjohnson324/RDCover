# RDCover

RDCover is an object relational mapping library for interfacing with SQL databases. It simplifies the process of seting associations and performing basic CRUD operations.

This library is meant to showcase how Ruby's metaprogramming capabilities enable defining associations between models in a convenient way.

---

## Setup

Simply run bundle `bundle install` and try out the project.

This project is designed to work with **sqlite3** out of the box. A sample sql and demo file are provided to illustrate the library's methods. To set up the database, ensure *sqlite3* and *libsqlite3-dev* are installed on your computer and run `sqlite3 simpsons.db < simpsons.sql` from the command line.

This project should work with other sql databases but will require the addition of additional gems for interfacing with other databases.

## Demo

The model names are, respectively, Pet, Character, and Home, with data entries themed off The Simpsons. Note the following relations:

- pets belong to characters; characters have many pets
- characters belong to homes; homes have many characters
- pets have one home through their owners

---

## Available Methods

### Class Methods

- **all** - Displays all data entries for a given model.
- **columns** - Displays a model's column/attribute names.
- **find(id)** - Searches for and displays the specific data entry for a model.
- **where(parameters)** - Perform basic filter queries. Accepts a parameters hash where keys correspond to column names and values correspond to column values.

### Instance Methods

- **attributes** - Specifies a data entry's attribute values.
- **insert** - Adds new data entries to the table specified by the model.
- **save** - Convenience method to automatically update or insert an entry depending on its presence in the table.
- **update** - Updates a specific entry.

### Associations Module

The following methods are applied as class methods in the example demo file. During runtime model associations are defined via metaprogramming and can be called on instances.

For example, executing the following code after loading demo.rb will list Bart's pets as Santa's Little Helper and Stampy.

```ruby
    bart = Character.find(3)
    bart.pets
```

This approach to defining associations is more convenient as it permits the user to quickly define new associations without having to code database logic into the methods.

- **belongs_to** - Defines foreign key associations, specifying the model table and row the key points to.
- **has_many** - The reverse of ::belongs_to; defines rows in another table with foreign keys pointing to the row in question.
- **has_one_through** - A basic join defining model relations across two tables.
