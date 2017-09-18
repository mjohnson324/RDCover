CREATE TABLE pets (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE characters (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE homes (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  homes (id, address)
VALUES
  (1, "742 Evergreen Terrace"),
  (2, "1000 Mammon Avenue"),
  (3, "Abandoned Warehouse");


INSERT INTO
  characters (id, fname, lname, house_id)
VALUES
  (1, "Homer", "Simpson", 1),
  (2, "Marge", "Simpson", 1),
  (3, "Bart", "Simpson", 1),
  (4, "Lisa", "Simpson", 1),
  (5, "Maggie", "Simpson", 1),
  (6, "Monty", "Burns", 2),
  (7, "Homeless", "Guy", NULL);

INSERT INTO
  pets (id, name, owner_id)
VALUES
  (1, "Snowball", 4),
  (2, "Santa's Little Helper", 3),
  (3, "Hound 1", 6),
  (4, "Hound 2", 6),
  (5, "Stampy", 3),
  (6, "Baboon", NULL),
  (7, "Scruffy", 7);
