CREATE TABLE car (
	uid UUID NOT NULL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19,2) NOT NULL
);

CREATE TABLE person (
  uid UUID NOT NULL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  gender VARCHAR(6) NOT NULL,
  email VARCHAR(100),
  date_of_birth DATE NOT NULL,
  country_of_birth VARCHAR(100) NOT NULL,
  car_uid UUID REFERENCES car (uid),
  UNIQUE(car_uid),
  created_at TIMESTAMP NOT NULL default current_timestamp
);

insert into car (uid, make, model, price) values (uuid_generate_v4(), 'Lamborghini', 'Diablo', '131288.99');
insert into car (uid, make, model, price) values (uuid_generate_v4(), 'Honda', 'Civic', '72925.63');
insert into car (uid, make, model, price) values (uuid_generate_v4(), 'GMC', 'Savana', '143213.96');


insert into person (uid, first_name, last_name, gender, email, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Devy', 'Patley', 'Male', 'dpatley0@narod.ru', '2004-12-06', 'Poland');
insert into person (uid, first_name, last_name, gender, email, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Ernaline', 'Yukhnini', 'Female', 'eyukhnini1@noaa.gov', '1991-05-15', 'China');
insert into person (uid, first_name, last_name, gender, email, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Yulma', 'Freeburn', 'Male', 'yfreeburn2@marketwatch.com', '2013-06-04', 'Philippines');

