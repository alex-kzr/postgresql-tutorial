// INSTALL & SETUP

sudo apt-get update // update packages

sudo apt-get install postgresql postgresql-contrib

<user>@<pc>:~$ psql --version

sudo service postgresql start // start postgresql in WSL
sudo service postgresql restart // restart
sudo service postgresql stop // stop

sudo /etc/init.d/postgresql start // works also

pg_lsclusters // check the cluster is up

/var/lib/postgresql/10/main // folder with configs


// USERS

sudo -i -u postgres  // change user to postgres in console
<user>@<pc>:~$ psql // run psql client using postgres user

sudo -u postgres psql // do the same from two up cmd in one

sudo passwd postgres // set up postgres pass
// if in pgAdmin ERROR: Postgresql: password authentication failed for user “postgres”
<db_name>=# ALTER USER postgres PASSWORD 'newPassword';

sudo -u postgres createuser <username> // create new user
<db_name>=# ALTER USER <username> with encrypted password '<password>';
<db_name>=# grant all privileges on database <dbname> to <username> ;

<db_name>=# \du // show list of roles


// NAVIGATION

<user>@<pc>:~$ psql --help
<db_name>=# help

<user>@<pc>:~$ psql -h localhost -p 5432 -U postgres test // make connection to db test on host:port

<db_name>=# \c <db_name> // use db_name

<db_name>=# \q // quit psql console
<user>@<pc>:~$ exit // change postgres user to default

<db_name>=# \x // turn on/off expanded display


// SCRIPT

<db_name>=# \i <file_path>/<file_name> // run script file 
// service to generate dummy data https://mockaroo.com/


// DATABASES

<db_name>=# \l // show all databases

<user>@<pc>:~$ createdb <db_name>
<db_name>=# CREATE DATABASE <db_name>;

WARNING:  could not flush dirty data: Function not implemented // if get this warning, then do cmd below
sudo vim /etc/postgresql/10/main/postgresql.conf
// change to these configs:
// fsync = off
// data_sync_retry = true
sudo service postgresql restart // restart server after configs change

<user>@<pc>:~$ dropdb <db_name>
<db_name>=# DROP DATABASE <db_name>


// TABLES

<db_name>=# \d // show list of tables & sequences
<db_name>=# \dt // show only list of tables
<db_name>=# \d <table_name> // show description of <table_name>

<db_name>=# CREATE TABLE person (
  id BIGSERIAL NOT NULL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  gender VARCHAR(6) NOT NULL,
  email VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  country_of_birth VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL default current_timestamp
);

<db_name>=# DROP TABLE <table_name>;


// CONSTRAINTS

<db_name>=# ALTER TABLE <table_name> ALTER COLUMN <col_name> SET NOT NULL;
<db_name>=# ALTER TABLE <table_name> ALTER COLUMN <col_name> DROP NOT NULL;

<db_name>=# ALTER TABLE <table_name> ADD PRIMARY KEY (<col_name>);
<db_name>=# ALTER TABLE person ADD PRIMARY KEY (id);


<db_name>=# ALTER TABLE <table_name> DROP CONSTRAINT <pkey_name>;
<db_name>=# ALTER TABLE person DROP CONSTRAINT person_pkey;

<db_name>=# ALTER TABLE <table_name> ADD CONSTRAINT <constraint_name> UNIQUE (<col_name>);
<db_name>=# ALTER TABLE <table_name> ADD UNIQUE (<col_name>); // Postgres will give name to constraint
<db_name>=# ALTER TABLE person ADD CONSTRAINT unique_email_address UNIQUE (email);

<db_name>=# ALTER TABLE <table_name> DROP CONSTRAINT <constraint_name>;
<db_name>=# ALTER TABLE person DROP CONSTRAINT unique_email_address;

<db_name>=# ALTER TABLE <table_name> ADD CONSTRAINT <constraint_name> CHECK (<col_name> = 'value1' OR <col_name> = 'value2');
<db_name>=# ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK (gender = 'Male' OR gender = 'Female');


// INSERT INTO

<db_name>=# INSERT INTO person (first_name, last_name, gender, date_of_birth, country_of_birth) VALUES ('John', 'Smith', 'Male', DATE '1988-01-20', 'USA');


// SELECT

<db_name>=# SELECT * FROM person;
<db_name>=# SELECT first_name, last_name FROM person;


// ORDER BY 
<db_name>=# SELECT * FROM person ORDER BY date_of_birth DESC; // ACS by default


// DISTINCT 

<db_name>=# SELECT DISTINCT country_of_birth FROM person ORDER BY country_of_birth;


// WHERE AND OR IN BETWEEN LIKE ILIKE

<db_name>=# SELECT * FROM person WHERE gender = 'Male' AND country_of_birth = 'Poland';
<db_name>=# SELECT * FROM person WHERE gender = 'Male' AND (country_of_birth = 'Poland' OR country_of_birth = 'China');
<db_name>=# SELECT * FROM person WHERE country_of_birth IN ('Poland', 'Brazil', 'France');
<db_name>=# SELECT * FROM person WHERE date_of_birth BETWEEN '2000-01-01' AND '2015-12-31';
<db_name>=# SELECT * FROM person WHERE email LIKE '%google.%';
<db_name>=# SELECT * FROM person WHERE email LIKE '%________@%';
<db_name>=# SELECT * FROM person WHERE country_of_birth LIKE 'P%'; // a bit faster then ILIKE
<db_name>=# SELECT * FROM person WHERE country_of_birth ILIKE 'p%';


// Comparison operators

<db_name>=# SELECT 1 = 1 // return t
<db_name>=# SELECT 1 = 2 // return f
<db_name>=# SELECT 1 < 2
<db_name>=# SELECT 1 <= 2
<db_name>=# SELECT 1 >= 2
<db_name>=# SELECT 1 <> 2
<db_name>=# SELECT 'TEST' <> 'test'


// LIMIT OFFSET

<db_name>=# SELECT * FROM person LIMIT 10;
<db_name>=# SELECT * FROM person OFFSET 15 LIMIT 10; // not SQL standart
<db_name>=# SELECT * FROM person OFFSET 15 FETCH FIRST 10 ROW ONLY; // official SQL standart


// GROUP BY COUNT

<db_name>=# SELECT country_of_birth, COUNT(*) FROM person GROUP BY country_of_birth ORDER BY country_of_birth;
<db_name>=# SELECT country_of_birth, COUNT(*) FROM person GROUP BY country_of_birth HAVING COUNT(*) > 5 ORDER BY country_of_birth;


 // MAX MIN AVG

<db_name>=# SELECT MAX(price) FROM car;
<db_name>=# SELECT MIN(price) FROM car;
<db_name>=# SELECT AVG(price) FROM car;
<db_name>=# SELECT ROUND(AVG(price)) FROM car;
<db_name>=# SELECT make, model, MIN(price) FROM car GROUP BY make, model;
<db_name>=# SELECT make, MIN(price) FROM car GROUP BY make ORDER BY MIN(price);
<db_name>=# SELECT make, AVG(price) FROM car GROUP BY make ORDER BY AVG(price);
<db_name>=# SELECT SUM(price) FROM car;
<db_name>=# SELECT make, SUM(price) FROM car GROUP BY make ORDER BY SUM(price) DESC;


// Basic arithmetic operators

<db_name>=# SELECT 10 + 2;
<db_name>=# SELECT 10 * 2 + 8;
<db_name>=# SELECT 10 / 3;
<db_name>=# SELECT 10 % 3;
<db_name>=# SELECT 10^2;
<db_name>=# SELECT 10!;
<db_name>=# SELECT id, make, model, price, price * 0.1 FROM car;
<db_name>=# SELECT id, make, model, price, ROUND(price * 0.1, 2) FROM car;
<db_name>=# SELECT id, make, model, price, ROUND(price * 0.1, 2), ROUND (price - price * 0.1, 2) FROM car;


// Aliases - AS

<db_name>=# SELECT id, make, model, price AS original_price, ROUND(price * 0.1, 2) AS ten_percent_value, ROUND (price - price * 0.1, 2) AS discount_after_ten_percent FROM car;


// COALESCE

<db_name>=# SELECT COALESCE(null, 1);
<db_name>=# SELECT COALESCE(null, null, 1);
<db_name>=# SELECT COALESCE(null, null, 1, 10);
<db_name>=# SELECT id, COALESCE(email, 'Email not privided') AS email FROM person WHERE email IS NULL;


// NULLIF

<db_name>=# SELECT NULLIF(10, 10); // return NULL
<db_name>=# SELECT NULLIF(10, 1); // return 10
<db_name>=# SELECT 10 / 0; // divide by zero error
<db_name>=# SELECT 10 / NULLIF (0, 0); // return NULL
<db_name>=# SELECT COALESCE(10 / NULLIF (0, 0), 0); // return 0


// TIMESTAMP & DATE

<db_name>=# SELECT NOW(); // return timestamp
<db_name>=# SELECT NOW()::DATE; // return date
<db_name>=# SELECT NOW()::TIME; // return time

<db_name>=# SELECT NOW() - INTERVAL '1 YEAR';
<db_name>=# SELECT (NOW() - INTERVAL '1 YEAR')::DATE; // do not show time
<db_name>=# SELECT NOW() - INTERVAL '10 YEARS';
<db_name>=# SELECT NOW() - INTERVAL '10 MONTHS';
<db_name>=# SELECT NOW()::DATE - INTERVAL '10 DAYS'; // but show 00:00:00 time

<db_name>=# SELECT EXTRACT(YEAR FROM NOW());
<db_name>=# SELECT EXTRACT(MONTH FROM NOW());
<db_name>=# SELECT EXTRACT(DAY FROM NOW());
<db_name>=# SELECT EXTRACT(DOW FROM NOW()); // day of the week, 0 - sunday
<db_name>=# SELECT EXTRACT(CENTURY FROM NOW()); // day of the week, 0 - sunday

<db_name>=# SELECT first_name, last_name, date_of_birth, AGE(NOW(), date_of_birth) AS age FROM person;


// DELETE

<db_name>=# DELETE FROM person WHERE id = 1;


// UPDATE

<db_name>=# UPDATE person SET email = 'cpeevor@gmail.com' WHERE id = 90;
<db_name>=# UPDATE person SET first_name = 'Danie', email = 'd.hugonet@gmail.com' WHERE id = 12;

<db_name>=# UPDATE person SET car_id = 3 WHERE id = 1;





// ON CONFLICT DO NOTHING DO UPDATE

<db_name>=# INSERT INTO person (id, first_name, last_name, gender, date_of_birth, country_of_birth) VALUES (1, 'John', 'Smith', 'Male', DATE '1988-01-20', 'USA') ON CONFLICT (id) DO NOTHING;

<db_name>=# INSERT INTO person (id, first_name, last_name, gender, email, date_of_birth, country_of_birth) VALUES (1, 'Devy', 'Patlen', 'Male', 'dpatley0@gmail.com', '2004-12-06', 'Poland') ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, last_name = EXCLUDED.last_name;


// INNER JOIN

<db_name>=# SELECT * FROM person JOIN car ON person.car_id = car.id;
<db_name>=# SELECT person.first_name, car.make, car.model, car.price FROM person JOIN car ON person.car_id = car.id;


// LEFT JOIN

<db_name>=# SELECT * FROM person LEFT JOIN car ON person.car_id = car.id;
<db_name>=# SELECT * FROM person LEFT JOIN car ON person.car_id = car.id WHERE car.* IS NULL;


// Export to CSV

<db_name>=# \copy (SELECT * FROM person LEFT JOIN car ON person.car_id = car.id) TO '<file_path>/<file_name>' DELIMITER ',' CSV HEADER;

// Sequences

<db_name>=# nextval('person_id_seq'::regclass) // invoke function that increace person table id to import into next time
<db_name>=# ALTER SEQUENCE person_id_seq RESTART WITH 5; // restart service from entered value


// Extentions

<db_name>=# SELECT * FROM pg_available_extensions; // show all available extensions

<db_name>=# CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

<db_name>=# \df // show list of functions


// uuid-ossp extension

<db_name>=# SELECT uuid_generate_v4();
