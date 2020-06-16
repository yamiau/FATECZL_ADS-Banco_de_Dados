CREATE DATABASE ex_16_06

USE MASTER 
DROP DATABASE ex_16_06

USE ex_16_06

CREATE TABLE cliente (
cod		INT IDENTITY(1001, 1) PRIMARY KEY,
nome		VARCHAR(20),
logradouro	VARCHAR(30),
numero		VARCHAR(5),
telefone	VARCHAR(9)
)

CREATE TABLE autor (
cod	INT IDENTITY(10001, 1) PRIMARY KEY,
nome		VARCHAR(30),
pais		VARCHAR(20),
biografia	VARCHAR(250)
)

CREATE TABLE corredor (
cod		INT IDENTITY(3251, 1) PRIMARY KEY,
tipo	VARCHAR(20)
)

CREATE TABLE livro (
cod				INT IDENTITY(1, 1) PRIMARY KEY,
nome			VARCHAR(40),
cod_autor		INT NOT NULL,
pag				INT,
idioma			VARCHAR(15),
cod_corredor	INT NOT NULL,
)

CREATE TABLE emprestimo (
cod_cli		INT NOT NULL,
cod_livro	INT NOT NULL,
data		DATE,
CONSTRAINT pk_emprestimo PRIMARY KEY (cod_cli, cod_livro)
)

INSERT INTO cliente VALUES
	('Luis Augusto', 'R. 25 de Mar�o', '250', '996529632'),
	('Maria Luisa', 'R. XV de Novembro', '890', '998526541'),
	('Claudio Batista', 'R. Anhaia', '112', '996547896'),
	('Wilson Mendes', 'R. do Hip�dromo', '1250', '991254789'),
	('Ana Maria', 'R. Augusta', '896', '999365589'),
	('Cinthia Souza', 'R. Volunt�rios da P�tria', '1023', '984256398'),
	('Luciano Britto', NULL, NULL, '995678556'),
	('Ant�nio do Valle', 'R. Sete de Setembro', '1894', NULL)

INSERT INTO autor VALUES
	('Ramez E. Elmasri', 'EUA', 'Professor da Universidade do Texas'),
	('Andrew Tannenbaum', 'Holanda', 'Desenvolvedor do Minix'),
	('Diva Mar�lia Flemming', 'Brasil', 'Professora Adjunta da UFSC'),
	('David Halliday', 'EUA', 'Ph.D. da University of Pittsburgh'),
	('Marco Antonio Furlan de Souza', 'Brasil', 'Prof. do IMT'),
	('Alfredo Steinbruch', 'Brasil', 'Professor de Matem�tica da UFRS e da PUCRS')

INSERT INTO corredor VALUES
	('Inform�tica'),
	('Matem�tica'),
	('F�sica'),
	('Qu�mica')

INSERT INTO livro VALUES
	('Sistemas de Banco de dados', 10001, 720, 'Portugu�s', 3251),
	('Sistemas Operacionais Modernos', 10002, 580, 'Portugu�s', 3251),
	('Calculo A', 10003, 290, 'Portugu�s', 3252),
	('Fundamentos de F�sica I', 10004, 185, 'Portugu�s', 3253),
	('Algoritmos e L�gica de Programa��o', 10005, 90, 'Portugu�s', 3251 ),
	('Geometria Anal�tica', 10006, 75, 'Portugu�s', 3252),
	('Fundamentos de F�sica II', 10004, 150, 'Portugu�s', 3253),
	('Redes de Computadores', 10002, 493, 'Ingl�s', 3251),
	('Organiza��o Estruturada de Computadores', 10002, 576, 'Portugu�s', 3251)

INSERT INTO emprestimo(cod_cli, data, cod_livro) VALUES
	(1001, '2012-05-10', 1),
	(1001, '2012-05-10', 2),
	(1001, '2012-05-10', 8),
	(1002, '2012-05-11', 4),
	(1002, '2012-05-11', 7),
	(1003, '2012-05-12', 3),
	(1004, '2012-05-14', 5),
	(1001, '2012-05-15', 9)

-- Fazer uma consulta que retorne o nome do cliente e a data do empr�stimo formatada padr�o BR (dd/mm/yyyy)

SELECT	c.nome,
		--FORMAT(e.data, 'dd/MM/yyyy') AS data,
		CONVERT(VARCHAR, e.data, 103) AS data
FROM	cliente c, emprestimo e
WHERE	c.cod = e.cod_cli

-- Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor, ordenado pelo n�mero de livros.
--Se o nome do autor tiver mais de 25 caracteres, mostrar s� os 13 primeiros.

SELECT		SUBSTRING(a.nome, 0, 14) AS nome,
			COUNT(l.cod_autor) AS obras
FROM		autor a, livro l
WHERE		a.cod = l.cod_autor
GROUP BY	a.nome
ORDER BY	obras

-- Fazer uma consulta que retorne o nome do autor e o pa�s de origem do livro com maior n�mero de p�ginas cadastrados no sistema

SELECT		a.nome,
			a.pais
FROM		autor a, livro l
WHERE		a.cod = l.cod_autor AND
			l.pag IN
			(SELECT MAX(pag)
			 FROM	livro)

-- Fazer uma consulta que retorne nome e endere�o concatenado dos clientes que tem livros emprestados

SELECT DISTINCT	c.nome,
				c.logradouro + ', ' + c.numero AS endere�o
FROM			cliente c, emprestimo e
WHERE			c.cod = e.cod_cli 

/*
Nome dos Clientes, sem repetir e, concatenados como ender�o_telefone, o logradouro, o numero e o telefone) dos clientes que N�o pegaram livros. 
Se o logradouro e o n�mero forem nulos e o telefone n�o for nulo, mostrar s� o telefone. 
Se o telefone for nulo e o logradouro e o n�mero n�o forem nulos, mostrar s� logradouro e n�mero. 
Se os tr�s existirem, mostrar os tr�s.
O telefone deve estar mascarado XXXXX-XXXX
*/

SELECT DISTINCT	c.nome,
				CASE WHEN ( (c.logradouro IS NULL) OR (c.numero IS NULL)  OR (c.telefone IS NULL) ) THEN 
					CASE WHEN (c.telefone IS NULL) THEN 
						CASE WHEN ((c.logradouro IS NULL) OR (c.numero IS NULL)) THEN ''
						ELSE c.logradouro + ', ' + c.numero
						END
					ELSE  SUBSTRING(c.telefone, 0, 6) + '-' + SUBSTRING(c.telefone, 6, LEN(c.telefone))
					END
				ELSE c.logradouro + ', ' + c.numero + ' (' + SUBSTRING(c.telefone, 0, 6) + '-' + SUBSTRING(c.telefone, 6, LEN(c.telefone))  + ')'
				END AS contato
FROM			cliente c
LEFT JOIN		emprestimo e
ON				e.cod_cli = c.cod 
WHERE			e.cod_cli IS NULL

-- Fazer uma consulta que retorne Quantos livros n�o foram emprestados

SELECT		l.nome
FROM		livro l
LEFT JOIN	emprestimo e
ON			e.cod_livro = l.cod
WHERE		e.cod_livro IS NULL

-- Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro

SELECT		a.nome,
			c.tipo,
			COUNT(l.cod) AS qtd_livros
FROM		autor a, livro l, corredor c
WHERE		a.cod = l.cod_autor AND	
			c.cod = l.cod_corredor
GROUP BY	a.nome, c.tipo
ORDER BY	qtd_livros

-- Considere que hoje � dia 18/05/2012, fa�a uma consulta que apresente o nome do cliente, o nome do livro, o total de dias que cada um est� com o livro,
--e uma coluna que apresente, caso o n�mero de dias seja superior a 4, apresente 'Atrasado', caso contr�rio, apresente 'No Prazo'

SELECT	c.nome,
		l.nome,
		DATEDIFF(DAY, e.data, CONVERT(DATE, '18/05/2012', 103)) AS total_dias,
		CASE WHEN (DATEDIFF(DAY, e.data, CONVERT(DATE, '18/05/2012', 103)) > 4) THEN 'Atrasado' 
		ELSE 'No prazo'
		END AS status
FROM	cliente c, livro l, emprestimo e
WHERE	c.cod = e.cod_cli AND
		l.cod = e.cod_livro


-- Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor


/*Note to self: descobrir como incluir o corredor com 0 livros*/
SELECT		c.cod,
			c.tipo,
			COUNT(l.cod) AS qtd_livros
FROM		corredor c, livro l
WHERE		c.cod = l.cod_corredor
GROUP BY	c.cod, c.tipo 

-- Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado � maior ou igual a 2.

SELECT		a.nome
FROM		autor a, livro l
WHERE		a.cod = l.cod_autor
GROUP BY	a.nome
HAVING		COUNT(l.cod) >= 2

-- Considere que hoje � dia 18/05/2012, fa�a uma consulta que apresente o nome do cliente, o nome do livro dos empr�stimos que tem 7 dias ou mais

SELECT		c.nome,
			l.nome
FROM		cliente c, livro l, emprestimo e
WHERE		c.cod = e.cod_cli AND
			l.cod = e.cod_livro
GROUP BY	c.nome, l.nome, e.data
HAVING		DATEDIFF(DAY, e.data, CONVERT(DATE, '18/05/2012', 103)) >= 7
