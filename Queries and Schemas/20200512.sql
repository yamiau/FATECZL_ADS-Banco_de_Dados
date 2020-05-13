USE MASTER
DROP DATABASE Livraria

CREATE DATABASE Livraria
GO
USE Livraria

CREATE TABLE Livro (
	cod 		INT PRIMARY KEY,
	nome 		VARCHAR(100), 
	lingua	 	VARCHAR(50),
	ano 		INT
)

CREATE TABLE Edicao (
	isbn		INT PRIMARY KEY,
	preco 		DECIMAL(7, 2),
	ano			INT,
	paginas		INT,
	estoque		INT
	
)

CREATE TABLE Autor (
	cod			INT PRIMARY KEY,
	nome		VARCHAR(100),
	nascimento	DATE,
	pais		VARCHAR(50),
	biografia	VARCHAR(MAX)
)

CREATE TABLE Editora (
	cod			INT PRIMARY KEY, 
	nome		VARCHAR(50),
	logradouro	VARCHAR(255),
	numero		INT, 
	cep			CHAR(8),
	telefone	CHAR(11)
)

CREATE TABLE Livro_Autor (
	cod_livro	INT NOT NULL,
	cod_autor	INT NOT NULL,
	PRIMARY KEY(cod_livro, cod_autor),
	FOREIGN KEY(cod_livro) REFERENCES Livro(cod),
	FOREIGN KEY(cod_autor) REFERENCES Autor(cod),
)	

CREATE TABLE Livro_Edicao_Editora (
	isbn_edicao	INT NOT NULL,
	cod_editora	INT NOT NULL,
	cod_livro	INT NOT NULL,
	PRIMARY KEY(isbn_edicao, cod_editora, cod_livro),
	FOREIGN KEY(isbn_edicao) REFERENCES Edicao(isbn),
	FOREIGN KEY(cod_editora) REFERENCES Editora(cod),
	FOREIGN KEY(cod_livro) REFERENCES Livro(cod)
)

/**/

EXEC sp_rename 'dbo.Edicao.ano', 'anoEdicao', 'column'

ALTER TABLE Editora ALTER COLUMN nome VARCHAR(30)

ALTER TABLE Autor DROP COLUMN nascimento
ALTER TABLE Autor ADD ano INT

/**/

INSERT INTO Livro VALUES(1001, 'CCNA 4.1', 'PT-BR', 2015)
INSERT INTO Livro VALUES(1002, 'HTML  5', 'PT-BR', 2017)
INSERT INTO Livro VALUES(1003, 'Redes de Computadores', 'EN', 2010)
INSERT INTO Livro VALUES(1004, 'Android em Ação', 'PT-BR', 2018)

INSERT INTO Autor VALUES(10001, 'Inácio da Silva', 'Brasil', 'Programador WEB desde 1995', 1975)
INSERT INTO Autor VALUES(10002, 'Andrew Tannenbaum', 'EUA', 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrij', 1944)
INSERT INTO Autor VALUES(10003, 'Luis Rocha', 'Brasil', 'Programador Mobile desde 2000', 1967)
INSERT INTO Autor VALUES(10004, 'David Halliday', 'EUA', 'Físico PH.D desde 1941', 1916)

INSERT INTO Livro_Autor VALUES(1001, 10001)
INSERT INTO Livro_Autor VALUES(1002, 10003)
INSERT INTO Livro_Autor VALUES(1003, 10002)
INSERT INTO Livro_Autor VALUES(1004, 10003)

INSERT INTO Edicao VALUES(0130661023, 189.99, 2018, 653, 10)

UPDATE Autor SET biografia = 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrije'
WHERE cod = 10002

UPDATE Edicao SET estoque -= 2
WHERE isbn = 130661023

DELETE Autor WHERE cod = 10004

SELECT * FROM Livro
SELECT * FROM Autor
SELECT * FROM Livro_Autor
SELECT * FROM Edicao