# RDCover

---

RDCover, or Ruby DataCover is an Object Relational Mapping library for interfacing with SQL databases. Similar in functionality to ActiveRecord, DataCover makes it easy to set associations, query for records, and perform basic CRUD operations.

This library is not intended to be a replacement for ActiveRecord; rather it is meant to showcase how Ruby's metaprogramming capabilities enable some of ActiveRecord's more advanced features. For example, it's possible to define wrapper methods at runtime for associations between models.

## Demo

---

See DataCover in action by loading 'demo.rb' in pry/irb. If not already present, a database will be created as well several model classes demonstrating the functionality of DataCover.

The model names are, respectively, Pet, Character, and Home, with data entries themed off The Simpsons.

Note the following relations:

- pets belong to characters; characters have many pets
- characters belong to homes; homes have many characters
- pets have one home through their owners

## Basic Methods

---

::new - Standard Ruby method to define new model instances.

::find(id) - Searches for and displays the specific data entry for a model.

::all - Displays all data entries for a given model.

::columns - Displays a model's column/attribute names.

#attributes - Specifies a data entry's attribute values.

#save - Convenience method to automatically update or insert an entry depending on its presence in the table.

#update - Updates a specific entry.

#insert - Adds new data entries to the table specified by the model.

## Associations Module

---

::belongs_to - Defines foreign key associations, specifying the model table and row the key points to.

::has_many - The reverse of ::belongs_to; defines rows in another table with foreign keys pointing to the row in question.

::has_one_through - A basic join defining model relations across two tables.

## Search Module

---

::where(parameters) - Perform basic filter queries. Accepts a parameters hash where keys correspond to column names and values correspond to column values.

## Potential Future Additions

---

- #where that stacks/is lazy.
- A Relation class.
- Validations, including methods and a new class.
- Bi-directional through associations for has_many (works for has_many and belongs_to)
- #includes for pre-fetching to reduce SQL queries
- #joins, for establishing join relations directly between classes.
