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

DROP TABLE	users_have_projects,
			users,
			projects 

CREATE TABLE users (
	id			INT IDENTITY(1,1) PRIMARY KEY,
	name		VARCHAR(45) NOT NULL,
	username	VARCHAR(45) CONSTRAINT username_unique UNIQUE,
	password	VARCHAR(45) DEFAULT('123mudar'),
	email		VARCHAR(45) NOT NULL
)

CREATE TABLE projects (
	id			INT IDENTITY (10001, 1) PRIMARY KEY,
	name		VARCHAR(45) NOT NULL,
	description	VARCHAR(45) NOT NULL,
	date		DATE CHECK(date > CONVERT(DATE, '01/09/2014'))
)
ALTER TABLE users DROP CONSTRAINT username_unique
ALTER TABLE users ALTER COLUMN username VARCHAR(10)
ALTER TABLE users ADD CONSTRAINT username_unique UNIQUE (username)
ALTER TABLE users ALTER COLUMN password VARCHAR(8)

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
--a)
INSERT INTO users(name, username, email) 
	VALUES('Joao', 'Ti_joao', 'joao@empresa.com')

--b)
INSERT INTO projects(name, description, date)
	VALUES('Atualização de Sistemas', 'Modificação de Sistemas Operacionais nos PC''s', '12/09/2014')


--c1)
SELECT	u.id AS user_id,
		u.name AS user_name,
		u.email AS user_email,
		p.id AS project_id,
		p.name AS project_name,
		p.description AS project_description,
		p.date AS project_date
FROM	users u, projects p, users_have_projects up
WHERE	u.id = up.users_id AND
	    p.id = up.projects_id AND
		p.name = 'Re-folha'
ORDER BY u.name ASC

--c2)
SELECT p.name AS project_name
FROM projects p
LEFT JOIN users_have_projects up ON p.id = up.projects_id
WHERE up.users_id IS NULL
ORDER BY p.name ASC

--c3)
SELECT u.name AS user_name
FROM users_have_projects up
RIGHT JOIN users u ON up.users_id = u.id
WHERE up.projects_id IS NULL
ORDER BY u.name ASC