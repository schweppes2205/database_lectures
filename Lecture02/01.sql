drop database if exists shop;
create database shop;
use shop;
drop table if exists catalogs;
create table catalogs (
	id serial primary key,
	name varchar(255) comment 'catalog name',
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp,
	unique unique_name(name(10))
) comment = 'shop\'s catalogs';


drop table if exists users;
create table users (
	id serial primary key,
	name varchar(255) comment 'user name',
	birthday_at date comment 'birthday date',
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp 
) comment = 'user table';

drop table if exists products;
create table products(
	id serial primary key,
	name varchar(255) comment 'product name',
	description text comment 'product description',
	price decimal(11,2) comment 'price',
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp,
	catalog_id int unsigned not null,
	key index_of_catalog_id(catalog_id)
) comment = 'products';
-- create index index_of_catalog_id on products(catalog_id);

drop table if exists orders;
create table orders(
	id serial primary key,
	user_id int unsigned not null,
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp,
	key index_of_user_id(user_id)
) comment = 'orders';

drop table if exists orders_products;
create table orders_products(
	id serial primary key,
	product_id int unsigned not null,
	order_id int unsigned not null,
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp,
	total int unsigned default 1 comment 'amount of products in an order'
-- 	key order_id(order_id),
-- 	key product_id(product_id)
) comment = 'match orders and products';

drop table if exists discount;
create table discount(
	id serial primary key,
	product_id int unsigned not null,
	user_id int unsigned not null,
	discount float unsigned comment 'discount value',
	start_date datetime,
	finish_date datetime,
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp,
	key user_id(user_id),
	key product_id(product_id)
)comment = 'discounts table';

drop table if exists storehouse;
create table storehouse(
	id serial primary key,
	name varchar(255) comment 'warehouse name',
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp
) comment = 'warehouse table';

drop table if exists storehouse_product;
create table storehouse_product(
	id serial primary key,
	storehouse_id int unsigned not null,
	product_id int unsigned not null,
	value int unsigned comment 'amount of product in database',
	created datetime default current_timestamp,
	updated datetime default current_timestamp on update current_timestamp
) comment = 'match product and warehouse';