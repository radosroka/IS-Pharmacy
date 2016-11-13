CREATE DATABASE `lekaren` COLLATE 'utf8_bin';

CREATE TABLE Liek(
    id_sukl char(6) NOT NULL,
    nazov varchar(1024) NOT NULL,
    vyrobca varchar(1024) NOT NULL,
    dodavatel int NOT NULL,
    cena int NOT NULL,
    na_predpis int
);

ALTER TABLE Liek ADD PRIMARY KEY (id_sukl);