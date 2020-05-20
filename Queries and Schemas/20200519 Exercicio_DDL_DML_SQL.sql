USE MASTER
DROP DATABASE Projects

CREATE DATABASE Projects
GO
USE Projects

CREATE TABLE users (
	id			INT PRIMARY KEY,
	name		VARCHAR(45) NOT NULL,
	username	VARCHAR(45) NOT NULL,
	password	VARCHAR(45) NOT NULL,
	email		VARCHAR(45) NOT NULL
)

CREATE TABLE projects (
	id			INT PRIMARY KEY,
	name		VARCHAR(45) NOT NULL,
	description	VARCHAR(45) NOT NULL,
	date		VARCHAR(45) NOT NULL
)

CREATE TABLE users_have_projects (
	users_id	INT NOT NULL,
	projects_id	INT NOT NULL,
	PRIMARY KEY(users_id, projects_id),
	FOREIGN KEY(users_id) REFERENCES users(id),
	FOREIGN KEY(projects_id) REFERENCES projects(id)
)

/**/

ALTER TABLE users ALTER COLUMN username VARCHAR(10)
ALTER TABLE users ALTER COLUMN password VARCHAR(8)

/**/

DROP TABLE	users_have_projects,
			users,
			projects 

CREATE TABLE users (
	id			INT IDENTITY(1,1) PRIMARY KEY,
	name		VARCHAR(45) NOT NULL,
	username	VARCHAR(45) UNIQUE,
	password	VARCHAR(45) DEFAULT('123mudar'),
	email		VARCHAR(45) NOT NULL
)

CREATE TABLE projects (
	id			INT IDENTITY (10001, 1) PRIMARY KEY,
	name		VARCHAR(45) NOT NULL,
	description	VARCHAR(45) NOT NULL,
	date		DATE CHECK(date > CONVERT(DATE, '01/09/2014'))
)

CREATE TABLE users_have_projects (
	users_id	INT NOT NULL,
	projects_id	INT NOT NULL,
	PRIMARY KEY(users_id, projects_id),
	FOREIGN KEY(users_id) REFERENCES users(id),
	FOREIGN KEY(projects_id) REFERENCES projects(id)
)

/**/

INSERT INTO users (name, username, email)
	VALUES	('Maria', 'Rh_maria', 'maria@empresa.com'),
			('Ana', 'Rh_ana', 'ana@empresa.com'),
			('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO users 
	VALUES	('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com'),
			('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

INSERT INTO projects
	VALUES	('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
			('Manutenção PC''s', 'Manutenção PC''s', '06/09/2014'),
			('Auditoria', 'NULL', '07/09/2014')

INSERT INTO users_have_projects 
	VALUES	(1, 10001),
			(5, 10001),
			(3, 10003),
			(4, 10002),
			(2, 10002)

/**/

UPDATE projects SET date = '12/09/2014'
WHERE id = 10002

UPDATE users SET username = 'Rh_cido'
WHERE name = 'Aparecido'

UPDATE users SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar' 

DELETE FROM users_have_projects 
WHERE users_id = 2

ALTER TABLE projects ADD budget DECIMAL(7,2)

UPDATE projects SET budget = 5750.00
WHERE id = 10001

UPDATE projects SET budget = 7850.00
WHERE id = 10002

UPDATE projects SET budget = 9530.00
WHERE id = 10003

/**/

SELECT username + password FROM users
WHERE name = 'Ana'

SELECT name, budget, (budget * 1.25) AS bonus_budget  FROM projects

SELECT id, name, email, username FROM users
WHERE password = '123mudar'

SELECT id, name FROM projects
WHERE budget >= 2000.00 AND budget <= 8000.00