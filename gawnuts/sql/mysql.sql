CREATE TABLE gawnuts_news (
  news_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  news_date DATE NOT NULL,
  news_user_name VARCHAR(50) NOT NULL,
  message VARCHAR(120) NOT NULL,
  news_time TIME NOT NULL,
  news_day_of_the_week VARCHAR(15) NOT NULL,
  PRIMARY KEY(news_id)
);

CREATE TABLE gawnuts_users (
  user_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  user_date VARCHAR(100) NULL,
  ip VARCHAR(45) NULL,
  description VARCHAR(100) NULL,
  level INTEGER UNSIGNED NULL,
  email VARCHAR(45) NULL,
  site_web VARCHAR(45) NULL,
  bday VARCHAR(15) NULL,
  gender VARCHAR(10) NULL,
  icq INTEGER UNSIGNED NULL,
  name VARCHAR(45) NULL,
  user_time INTEGER UNSIGNED NULL,
  PRIMARY KEY(user_id)
);

CREATE TABLE gawnuts_user_smail (
  user_smail_id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  gawnuts_users_user_id INTEGER UNSIGNED NOT NULL,
  user_id INTEGER UNSIGNED NULL,
  smail_date DATE NULL,
  user_send INTEGER UNSIGNED NULL,
  smail_text TEXT NULL,
  smail_status VARCHAR(5) NULL,
  PRIMARY KEY(user_smail_id),
  INDEX gawnuts_user_smail_FKIndex1(gawnuts_users_user_id)
);


