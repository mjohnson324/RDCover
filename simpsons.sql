CREATE TABLE pets (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES characters(id)
);

CREATE TABLE characters (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES characters(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "742 Evergreen Terrace"),
  (2, "Kwik-E-Mart"),
  (3, "Springfield Elementary School");

INSERT INTO
  characters (id, fname, lname, house_id)
VALUES
  (1, "Bart", "Simpson", 1),
  (2, "Lisa", "Simpson", 1),
  (3, "Crazy", "Catlady", NULL),
  (4, "Groundskeeper", "Willie", 3);

INSERT INTO
  pets (id, name, owner_id)
VALUES
  (1, "Santas Little Helper", 1),
  (2, "Snowball", 2),
  (3, "cat projectile 1", 3),
  (4, "cat projectile 2", 3),
  (5, "Stray Cat", NULL);
