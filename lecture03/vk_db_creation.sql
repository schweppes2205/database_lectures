DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Р¤Р°РјРёР»СЊ', -- COMMENT РЅР° СЃР»СѓС‡Р°Р№, РµСЃР»Рё РёРјСЏ РЅРµРѕС‡РµРІРёРґРЅРѕРµ
    email VARCHAR(120) UNIQUE,
    phone BIGINT, 
    -- INDEX users_phone_idx(phone), -- РїРѕРјРЅРёРј: РєР°Рє РІС‹Р±РёСЂР°С‚СЊ РёРЅРґРµРєСЃС‹
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- РїРѕРєР° СЂР°РЅРѕ, С‚.Рє. С‚Р°Р±Р»РёС†С‹ media РµС‰Рµ РЅРµС‚
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (Р·РЅР°С‡РµРЅРёРµ РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ)
    ON DELETE restrict; -- (Р·РЅР°С‡РµРЅРёРµ РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- РјРѕР¶РЅРѕ Р±СѓРґРµС‚ РґР°Р¶Рµ РЅРµ СѓРїРѕРјРёРЅР°С‚СЊ СЌС‚Рѕ РїРѕР»Рµ РїСЂРё РІСЃС‚Р°РІРєРµ

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL PRIMARY KEY, -- РёР·РјРµРЅРёР»Рё РЅР° СЃРѕСЃС‚Р°РІРЅРѕР№ РєР»СЋС‡ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    -- `status` TINYINT UNSIGNED,
    `status` ENUM('requested', 'approved', 'unfriended', 'declined'),
    -- `status` TINYINT UNSIGNED, -- РІ СЌС‚РѕРј СЃР»СѓС‡Р°Рµ РІ РєРѕРґРµ С…СЂР°РЅРёР»Рё Р±С‹ С†РёС„РёСЂРЅС‹Р№ enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME on update now(),
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),

	INDEX communities_name_idx(name)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- С‡С‚РѕР±С‹ РЅРµ Р±С‹Р»Рѕ 2 Р·Р°РїРёСЃРµР№ Рѕ РїРѕР»СЊР·РѕРІР°С‚РµР»Рµ Рё СЃРѕРѕР±С‰РµСЃС‚РІРµ
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

    -- Р·Р°РїРёСЃРµР№ РјР°Р»Рѕ, РїРѕСЌС‚РѕРјСѓ РёРЅРґРµРєСЃ Р±СѓРґРµС‚ Р»РёС€РЅРёРј (Р·Р°РјРµРґР»РёС‚ СЂР°Р±РѕС‚Сѓ)!
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),

    primary key (id),
    foreign key (user_id) references users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
    
);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL PRIMARY KEY,
	`album_id` BIGINT unsigned NOT NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);


-- Написать крипт, добавляющий в БД vk, которую создали на занятии, 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
-- таблица news - новости, которые может публиковать пользователь. может вставлять туда медиа.
DROP TABLE IF EXISTS news;
CREATE TABLE news (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	content text,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_id) references media(id)
);

-- таблица items - магазин услуг.

drop table if exists items;
create table items(
	id serial primary key,
	content text,

	FOREIGN KEY (user_id) REFERENCES users(id)
);

-- таблица users_items - связь М х М элементов каталога и пользователей.

drop table if exists users_items;
create table users_items(
	user_id bigint unsigned not null,
	item_id bigint unsigned not null,
	
	primary key (user_id, item_id),
	foreign key (user_id) references users(id),
	foreign key (item_id) references items(id)
);

-- таблица permissions - доступ к публикациями 

drop table if exists permissions;
create table permissions(
	owner bigint unsigned not null,
	news_permitted_user_id bigint unsigned,
	news_id bigint unsigned,
	items_permitted_user_id bigint unsigned,
	items_id bigint unsigned,
	
	foreign key (owner) references users(id),
	foreign key (news_permitted_user_id) references users(id),
	foreign key (items_permitted_user_id) references users(id),
	foreign key (news_id) references news(id),
	foreign key (items_id) references items(id)
);
