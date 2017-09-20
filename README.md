# RDCover
---
RDCover, or Ruby DataCover is an Object Relational Mapping library for interfacing with SQL databases. Similar in functionality to ActiveRecord, DataCover makes it easy to set associations, query for records, and perform basic CRUD operations.

## Demo:
---
See DataCover in action

## Basic Methods:
---

::find

#all

::insert

::update

#save

#update

#insert

::new

::find(id)

::all

::last

::first

::columns

## Associations:
---
::belongs_to

::has_many

::has_one_through

## Queries:
---
::where

## Potential Future Additions
---
- #where that stacks/is lazy.
- A Relation class.
- Validations, including methods and a new class.
- Bi-directional through associations for has_many (works for has_many and belongs_to)
- #includes for pre-fetching to reduce SQL queries
- #joins, for establishing join relations directly between classes.
