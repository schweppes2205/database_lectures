drop database if exists shop;
create database shop;
use shop;
drop table if exists catalogs;
create table catalogs (
	id int unsigned not null,
	name varchar(255) comment 'catalog name'
) comment = 'shop\'s catalogs';

drop table if exists users;
create table users (
	id int unsigned not null,
	name varchar(255) comment 'user name'
) comment = 'user table';

drop table if exists products;
create table products(
	id int unsigned not null,
	name varchar(255) comment 'product name',
	description text comment 'product description',
	price decimal(11,2) comment 'price',
	catalog_id int unsigned not null
) comment = 'products';

drop table if exists orders;
create table orders(
	id int unsigned not null,
	user_id int unsigned not null
) comment = 'orders';

drop table if exists orders_products;
create table orders_products(
	id int unsigned not null,
	product_id int unsigned not null,
	order_id int unsigned not null,
	total int unsigned default 1 comment 'amount of products in an order'
) comment = 'match orders and products';

drop table if exists discount;
create table discount(
	id int unsigned not null,
	product_id int unsigned not null,
	user_id int unsigned not null,
	discount float unsigned comment 'discount value'
)comment = 'discounts table';

drop table if exists storehouse;
create table storehouse(
	id int unsigned not null,
	name varchar(255) comment 'warehouse name'
) comment = 'warehouse table';

drop table if exists storehouse_product;
create table storehouse_product(
	id int unsigned not null,
	storehouse_id int unsigned not null,
	product_id int unsigned not null,
	value int unsigned comment 'amount of product in database'
) comment = 'match product and warehouse';