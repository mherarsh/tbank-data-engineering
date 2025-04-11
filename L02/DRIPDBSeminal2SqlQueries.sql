CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password VARCHAR(255) NOT NULL,
	age INTEGER,
	avatar VARCHAR(255),
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE users 
ADD COLUMN phone_number VARCHAR(15);

CREATE INDEX users_age_idx ON users (age);

INSERT INTO users (name, email, password, age, avatar)
VALUES 
('Иван Иванов', 'ivan@example.com', 'd131dd02c5e6eec4', 31, '/pictures/ivan.jpeg'),
('Мария Петрова', 'maria@example.com', '55ad340609f4b302', null, null),
('Алексей Смирнов', 'alex@example.com', 'd8823e3156348f5b', 15, '/root/alex.png'),
('Кек Лолов', 'kek@example.com', 'f131df02c5e6eec4', null, null),
('Эрик Картман', 'eric@southpark.com', '44ad440609f4b302', null, '/southpark/cartman.png');

UPDATE users
SET PHONE_NUMBER = '88005553535'
WHERE email = 'eric@southpark.com';

DELETE FROM users
WHERE name = 'Алексей Смирнов';

SELECT 1+3;

SELECT id, name, age FROM users;

SELECT * FROM users
WHERE avatar IS NOT NULL;

SELECT * FROM users
WHERE avatar IS NOT NULL AND age > 20;

SELECT id, name, email, created_at FROM users 
WHERE email LIKE '%@southpark.com';

SELECT id, name, created_at FROM users 
ORDER BY id 
LIMIT 2 OFFSET 0;

SELECT id, name, created_at FROM users 
ORDER BY id 
LIMIT 2 OFFSET 2;

ALTER TABLE users 
ADD COLUMN company VARCHAR(15);

SELECT id, name, company FROM users;

SELECT company, count(*) FROM users
GROUP BY company;

SELECT id, name, avatar, age FROM users;

WITH users_with_avatar AS (
    SELECT id, name, age, email 
    FROM users 
    WHERE avatar IS NOT NULL
)
SELECT * FROM users_with_avatar 
WHERE age > 20;


SELECT id, name, company FROM users;

CREATE TABLE companies (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

INSERT INTO companies (name)
VALUES 
('hse'), 
('meme factory'),
('southpark');

ALTER TABLE users 
ADD COLUMN company_id INTEGER;

ALTER TABLE users
DROP COLUMN company;

SELECT id, name, created_at FROM users;

SELECT MAX(created_at) AS last_registered 
FROM users;

SELECT id, name, age, company_id FROM users;

SELECT id, name, age, company_id, avg(age) OVER (PARTITION BY company_id) FROM users;


SELECT id, name, age, company_id FROM users;
SELECT id, name FROM COMPANIES ;

SELECT u.id, u.name AS user_name, c.name AS company_name
FROM users u
INNER JOIN companies c 
  ON u.company_id = c.id;

SELECT u.id, u.name AS user_name, c.name AS company_name
FROM users u
FULL JOIN companies c 
  ON u.company_id = c.id;
 
SELECT u.id, u.name AS user_name, c.name AS company_name
FROM users u
CROSS JOIN companies c;
 
SELECT u.id, u.name AS user_name, c.name AS company_name
FROM users u
FULL JOIN companies c 
  ON u.company_id = c.id
WHERE age > 10;

SELECT 
  c.name AS company_name,
  COUNT(u.id) AS total_users,
  ROUND(AVG(u.age)) AS avg_age,
  (
    SELECT u2.name 
    FROM users u2 
    WHERE u2.company_id = c.id 
    ORDER BY u2.created_at DESC 
    LIMIT 1
  ) AS last_registered_user
FROM companies c
LEFT JOIN users u ON u.company_id = c.id
GROUP BY c.id
HAVING COUNT(u.id) > 0
ORDER BY total_users DESC;