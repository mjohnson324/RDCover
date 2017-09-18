# RDCover
---
RDCover, or Ruby Data Cover is a library for interfacing with SQL databases.

## Notable Methods:
---
where(params)

find

all

insert

update

# Potential Future Additions
- A #where method that can stack/is lazy.
- A Relation class.
- Validations, including methods and a new class.
- Bi-directional through associations for has_many (works for has_many and belongs_to)
- An #includes method for pre-fetching to reduce SQL queries
- #joins, for establishing join tables directly between classes.
