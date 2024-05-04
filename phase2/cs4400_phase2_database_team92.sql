-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 19, 2024 @ 12:00am EST

-- Team 92
-- Anirudh Jaishankar (ajaishankar7)
-- Sacchit Kumar Mittal (smittal81)
-- Seung Taek Lee (slee3321)
-- Sunho Park (spark901)
-- Shalin Anand Jain (sjain441)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

CREATE TABLE user (
    uname VARCHAR(40) PRIMARY KEY NOT NULL, 
    fname VARCHAR(100) NOT NULL,
    lname VARCHAR(100) NOT NULL,
    address VARCHAR(500) NOT NULL,
    birthdate DATE CHECK(birthdate like '____-__-__')
) engine = innodb;

CREATE TABLE customer (
    uname VARCHAR(40) NOT NULL PRIMARY KEY,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    credit DECIMAL(10,2),
    CONSTRAINT fk1 FOREIGN KEY (uname) REFERENCES user(uname)
)engine = innodb;

CREATE TABLE employee (
    uname VARCHAR(40) NOT NULL PRIMARY KEY,
	taxID CHAR(11) CHECK(taxID like '___-__-____'),  
    salary INT CHECK (salary >= 0),  
    service INT default 0 CHECK (service >= 0), 
    CONSTRAINT fk2 FOREIGN KEY (uname) REFERENCES user (uname)
) engine = innodb;

CREATE TABLE drone_pilot (
    uname VARCHAR(40) NOT NULL PRIMARY KEY,
    licenseID INTEGER NOT NULL,
    experience INTEGER NOT NULL CHECK(experience >= 0),
    CONSTRAINT fk3 FOREIGN KEY (uname) REFERENCES employee(uname)
)engine = innodb;

CREATE TABLE store_worker (
    uname VARCHAR(40) NOT NULL PRIMARY KEY,
    CONSTRAINT fk4 FOREIGN KEY (uname) REFERENCES employee(uname)
)engine = innodb;


CREATE TABLE product (
    barcode VARCHAR(40) NOT NULL PRIMARY KEY,
    pname VARCHAR(100) NOT NULL,
	weight INT NOT NULL CHECK(weight >= 0)
)engine = innodb;

CREATE TABLE store (
    storeID VARCHAR(40) NOT NULL PRIMARY KEY,
    sname VARCHAR(100) NOT NULL,
    revenue decimal(12, 2) NOT NULL CHECK (revenue >= 0),
    manager VARCHAR(40) Not Null,
    CONSTRAINT fk7 FOREIGN KEY (manager) REFERENCES store_worker(uname)
)engine = innodb;


CREATE TABLE drone (
    droneTag VARCHAR(40) Not Null,
    storeID VARCHAR(40) Not Null,
    rem_trips INT NOT NULL CHECK(rem_trips >= 0), 
    capacity INT NOT NULL CHECK (capacity >= 0),  
    pilot_name VARCHAR(40) Not Null,
    primary key (droneTag, StoreID),
    CONSTRAINT fk8 FOREIGN KEY (storeID) REFERENCES store(storeID),
    CONSTRAINT fk9 FOREIGN KEY (pilot_name) REFERENCES drone_pilot(uname)
)engine = innodb;

CREATE TABLE `order`(
    orderID VARCHAR(40) NOT NULL PRIMARY KEY,
    sold_on DATE NOT NULL,
    uname VARCHAR(40) NOT NULL,
    droneTag VARCHAR(40) NOT NULL,
    storeID varchar(40) NOT NULL,
    CONSTRAINT fk5 FOREIGN KEY(uname) REFERENCES customer(uname), 
    CONSTRAINT fk6 FOREIGN KEY(droneTag, storeID) REFERENCES drone(droneTag, storeID)
)engine = innodb;




CREATE TABLE contain (
    orderID VARCHAR(40) NOT NULL,
    pBarcode VARCHAR(40) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >=0),
    quantity INT NOT NULL,
    CONSTRAINT fk10 FOREIGN KEY (orderID) REFERENCES `order`(orderID),
    CONSTRAINT fk11 FOREIGN KEY (pBarcode) REFERENCES product(barcode)
)engine = innodb;

CREATE TABLE employ (
	storeID varchar(40) NOT NULL,  
    employee_name varchar(40) NOT NULL,  
    PRIMARY KEY (storeID, employee_name),  
    CONSTRAINT fk12 FOREIGN KEY (storeID) REFERENCES store (storeID),  
    CONSTRAINT fk13 FOREIGN KEY (employee_name) REFERENCES employee (uname)  
)engine = innodb;

INSERT INTO user (uname, fname, lname, address, birthdate) VALUES
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19');

INSERT INTO customer (uname, rating, credit) VALUES
('awilson5', 2, 100),  
('csoares8', NULL, NULL), 
('echarles19', NULL, NULL),
('eross10', NULL, NULL),  
('hstark16', NULL, NULL),  
('jstone5', 4, 40),  
('lrodriguez5', 4, 60),  
('sprince6', 5, 30),  
('tmccall5', NULL, NULL);

INSERT INTO employee (uname, taxID, service, salary) VALUES
('awilson5', '111-11-1111', 9, 46000.00),
('csoares8', '888-88-8888', 26, 57000.00),
('echarles19', '777-77-7777', 3, 27000.00),
('eross10', '444-44-4444', 10, 61000.00),
('hstark16', '555-55-5555', 20, 59000.00),
('jstone5', NULL, NULL, NULL),
('lrodriguez5', '222-22-2222', 20, 58000.00),
('sprince6', NULL, NULL, NULL),
('tmccall5', '333-33-3333', 29, 33000.00);

INSERT INTO drone_pilot (uname, licenseID, experience) VALUES
('awilson5', 314159, 41),  
('lrodriguez5', 287182, 67),
('tmccall5', 181633, 10); 

INSERT INTO store_worker (uname) VALUES
('echarles19'),
('eross10'),
('tmccall5');
-- ('hstark16')

INSERT INTO product (barcode, pname, weight) VALUES
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);


INSERT INTO store (storeID, sname, revenue, manager) VALUES
('pub', 'Publix', 200.00, 'hstark16'),
('krg', 'Kroger', 300.00, 'echarles19');


INSERT INTO drone (droneTag, storeID, rem_trips, capacity, pilot_name) VALUES
('Drone#1', 'pub', 3, 10, 'awilson5'),
('Drone#2', 'pub', 2, 20, 'tmccall5'),
('Drone#1', 'krg', 4, 15, 'lrodriguez5');

INSERT INTO `order` (orderID, sold_on, uname, droneTag, storeID) VALUES
('pub_306', '2021-05-22', 'awilson5', 'Drone#2', 'pub'),
('krg_217', '2021-05-23', 'jstone5', 'Drone#1', 'krg'),
('pub_305', '2021-05-22', 'sprince6', 'Drone#2', 'pub'),
('pub_303', '2021-05-23', 'sprince6', 'Drone#1', 'pub');


INSERT INTO contain (orderID, pBarcode, price, quantity) VALUES
('pub_303', 'ap_9T25E36L', 4, 1),
('krg_217', 'pr_3C6A9R', 15, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_306', 'ap_9T25E36L', 10, 1);

INSERT INTO employ (storeID, employee_name) VALUES
('pub', 'eross10'),  
('pub', 'hstark16'),  
('krg', 'echarles19'),
('krg', 'eross10'); 
