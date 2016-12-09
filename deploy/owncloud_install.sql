-- mysql create db for owncloud with user e password
CREATE DATABASE owncloud ;
CREATE USER 'owncloud'@'localhost' IDENTIFIED BY 'owncloud' ;
GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost' ;
FLUSH PRIVILEGES ;