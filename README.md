# RDCover
---
RDCover, or Ruby DataCover is an Object Relational Mapping library for interfacing with SQL databases. Similar in functionality to ActiveRecord, DataCover makes it easy to set associations, query for records, and perform basic CRUD operations.

## Demo:
---
See DataCover in action by loading 'demo.rb' in pry/irb. If not already present, a database will be created as well several model classes demonstrating the functionality of DataCover.

The model names are, respectively, Pet, Character, and Home, with data entries themed off The Simpsons.

Note the following relations:
- pets belong to characters; characters have many pets
- characters belong to homes; homes have many characters
- pets have one home through their owners

## Basic Methods:
---

::new

::find(id)

::all

::columns

#attributes

#save

#update

#insert

## Associations:
---
::belongs_to

::has_many

::has_one_through

## Search Module:
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
