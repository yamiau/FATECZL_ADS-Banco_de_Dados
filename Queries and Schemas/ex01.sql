CREATE DATABASE ex01

CREATE TABLE aluno (
ra			INT PRIMARY KEY,
nome		VARCHAR(12) NOT NULL,
sobrenome	VARCHAR(30) NOT NULL,
rua			VARCHAR(30) NOT NULL,
numero		INT NOT NULL,
bairro		VARCHAR(30) NOT NULL,
cep			CHAR(9) NOT NULL, 
telefone	VARCHAR(9)
)

CREATE TABLE curso (
codigo		INT IDENTITY(1,1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
carga_hora	INT NOT NULL, 
turno		CHAR(5) NOT NULL
)

CREATE TABLE disciplina (
codigo		INT IDENTITY(1,1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
carga_hora	INT NOT NULL, 
turno		CHAR(5) NOT NULL,
semestre	INT NOT NULL
)

INSERT INTO aluno VALUES
	(12345, 'Jos�', 'Silva', 'Almirante Noronha', 236, 'Jardim S�o Paulo', '01589-000', '6987-5287'),
	(12346, 'Ana', 'Maria Bastos', 'Anhaia', 21568, 'Barra Funda', '03569-000', '2569-8526'),
	(12347, 'Mario', 'Santos', 'XV de Novembro', 1841, 'Centro', '01020-030', NULL),
	(12348, 'Marcia', 'Neves', 'Volunt�rios da P�tria', 225, 'Santana', '02785-090', '7896-4152')

INSERT INTO curso VALUES
	('Inform�tica', 2800, 'Tarde'),
	('Inform�tica', 2800, 'Noite'),
	('Log�stica', 2650, 'Tarde'),
	('Log�stica', 2650, 'Noite'),
	('Pl�sticos', 2500, 'Tarde'),
	('Pl�sticos', 2500, 'Noite')

INSERT INTO disciplina VALUES
	('Inform�tica', 4, 'Tarde', 1),
	('Inform�tica', 4, 'Noite', 1),
	('Qu�mica', 4, 'Tarde', 1),
	('Qu�mica', 4, 'Noite', 1),
	('Banco de Dados I', 2, 'Tarde', 3),
	('Banco de Dados I', 2, 'Noite', 3),
	('Estrutura de Dados', 4, 'Tarde', 4),
	('Estrutura de Dados', 4, 'Noite', 4)

--Consultar:

--Nome e sobrenome, como nome completo dos Alunos Matriculados

SELECT	nome + ' ' + sobrenome AS nome_completo
FROM	aluno
WHERE	ra IS NOT NULL

--Rua, n� , Bairro e CEP como Endere�o do aluno que n�o tem telefone

SELECT	rua + ', ' + CAST(numero AS CHAR(4)) + ', ' + bairro + ' (CEP ' + cep + ')' AS endere�o
FROM	aluno
WHERE	telefone IS NULL

--Telefone do aluno com RA 12348

SELECT	telefone
FROM	aluno
WHERE	ra = 12348

--Nome e Turno dos cursos com 2800 horas

SELECT	nome, turno
FROM	curso
WHERE	carga_hora = 2800

--O semestre do curso de Banco de Dados I noite

SELECT	semestre
FROM	disciplina
WHERE	nome LIKE '%Dados I%' AND
		turno = 'Noite'