CREATE DATABASE ex09

USE ex09

CREATE TABLE editora (
codigo	INT IDENTITY(1, 1) PRIMARY KEY,
nome	VARCHAR(30) NOT NULL,
site	VARCHAR(30)
)

INSERT INTO editora VALUES
	('Pearson', 'www.pearson.com.br'),
	('Civilização Brasileira', NULL),
	('Makron Books', 'www.mbooks.com.br'),
	('LTC', 'www.ltceditora.com.br'),
	('Atual', 'www.atualeditora.com.br')

CREATE TABLE autor (
codigo	INT IDENTITY(101, 1) PRIMARY KEY,
nome	VARCHAR(30) NOT NULL,
bio		VARCHAR(250) NOT NULL
)

INSERT INTO autor VALUES
	('Andrew Tannenbaun', 'Desenvolvedor do Minix'),
	('Fernando Henrique Cardoso', 'Ex-Presidente do Brasil'),
	('Diva Marília Flemming', 'Professora adjunta da UFSC'),
	('David Halliday', 'Ph.D. da University of Pittsburgh'),
	('Alfredo Steinbruch', 'Professor de Matemática da UFRS e da PUCRS'),
	('Willian Roberto Cereja', 'Doutorado em Lingüística Aplicada e Estudos da Linguagem')

CREATE TABLE estoque (
codigo		INT IDENTITY(10001, 1) PRIMARY KEY,
nome		VARCHAR(30) NOT NULL,
qtd			INT NOT NULL,
valor		DECIMAL(7,2) NOT NULL,
cod_editora	INT NOT NULL,
cod_autor	INT NOT NULL,
FOREIGN KEY (cod_editora)	REFERENCES editora(codigo),
FOREIGN KEY (cod_autor)		REFERENCES autor(codigo)
)

INSERT INTO estoque VALUES
	('Sistemas Operacionais Modernos', 4, 108, 1, 101),
	('A Arte da Política', 2, 55.00, 2, 102),
	('Calculo A', 12, 79.00, 3, 103),
	('Fundamentos de Física I', 26, 68.00, 4, 104),
	('Geometria Analítica', 1, 95.00, 3, 105),
	('Gramática Reflexiva', 10, 49.00, 5, 106),
	('Fundamentos de Física III', 1, 78.00, 4, 104),
	('Calculo B', 3, 95.00, 3, 103)

CREATE TABLE compra (
codigo		INT NOT NULL,
cod_livro	INT NOT NULL,
qtd			INT NOT NULL,
valor		DECIMAL(7,2) NOT NULL,
CONSTRAINT pk_compra	PRIMARY KEY (codigo, cod_livro),
FOREIGN KEY (cod_livro) REFERENCES estoque(codigo)
)

INSERT INTO compra VALUES
	(15051, 10003, 2, 158.00),
	(15051, 10008, 1, 95.00),
	(15051, 10004, 1, 68.00),
	(15051, 10007, 1, 78.00),
	(15052, 10006, 1, 49.00),
	(15052, 10002, 3, 165.00),
	(15053, 10001, 1, 108.00),
	(15054, 10003, 1, 79.00),
	(15054, 10008, 1, 95.00)

--Pede-se:
--Consultar quais livros do estoque foram vendidos

SELECT DISTINCT	e.nome
FROM			estoque e
LEFT JOIN		compra c
ON				c.cod_livro = e.codigo
WHERE			c.cod_livro IS NOT NULL

--Consultar nome do livro, quantidade comprada e valor de compra da compra 15051

SELECT	e.nome,
		c.qtd,
		c.valor
FROM	estoque e, compra c
WHERE	e.codigo = c.cod_livro AND
		c.codigo = 15051
ORDER BY c.valor

--Consultar Nome do livro e site da editora dos livros da Makron books
--(Caso o site tenha mais de 20 dígitos, remover o www.).

SELECT	es.nome,
		CASE WHEN (LEN(ed.site) <= 20) THEN ed.site
		ELSE SUBSTRING(ed.site, 5, LEN(ed.site)) 
		END AS site
FROM	estoque es, editora ed
WHERE	es.cod_editora = ed.codigo AND
		ed.nome LIKE '%makron%'

--Consultar nome do livro e Breve Biografia do David Halliday

SELECT	e.nome,
		a.bio
FROM	estoque e, autor a
WHERE	e.cod_autor = a.codigo AND
		a.nome = 'David Halliday'


--Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos

SELECT		c.codigo,
			c.qtd
FROM		compra c
LEFT JOIN	estoque e
ON			c.cod_livro = e.codigo
WHERE		e.nome LIKE '%sistemas operacionais modernos%'

--Consultar quais livros não foram vendidos

SELECT 		e.nome
FROM		compra c
RIGHT JOIN	estoque e
ON			c.cod_livro = e.codigo
WHERE		c.cod_livro IS NULL

--Consultar quais livros foram vendidos e não estão cadastrados

SELECT		e.nome
FROM		estoque e
LEFT JOIN	compra c
ON			e.codigo = c.cod_livro
WHERE		c.cod_livro IS NULL


--Consultar Nota Fiscal e Valor Total da Compra (Verificar que alguns livros foram comprados em mais de 1 unidade)

SELECT		c.codigo,
			SUM(c.valor) AS valor_total
FROM		compra c
GROUP BY	c.codigo

