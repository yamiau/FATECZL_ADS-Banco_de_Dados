CREATE DATABASE ex08

USE ex08

CREATE TABLE cliente (
codigo			INT IDENTITY(1, 1) PRIMARY KEY,
nome			VARCHAR(30) NOT NULL,
endereço		VARCHAR(40) NOT NULL,
fone			VARCHAR(9) NOT NULL,
fone_comercial	VARCHAR(11)
)

INSERT INTO cliente VALUES
	('Luis Paulo', 'R. Xv de Novembro, 100', '45657878', NULL),
	('Maria Fernanda', 'R. Anhaia, 1098', '27289098', '40040090'),
	('Ana Claudia', 'Av. Voluntários da Pátria, 876', '21346548', NULL),
	('Marcos Henrique', 'R. Pantojo, 76', '51425890', '30394540'),
	('Emerson Souza', 'R. Pedro Álvares Cabral, 97', '44236545', '39389900'),
	('Ricardo Santos', 'Trav. Hum, 10', '98789878', NULL)

CREATE TABLE tipo (
codigo	INT IDENTITY(10001, 1) PRIMARY KEY,
nome	VARCHAR(12) NOT NULL
)

INSERT INTO tipo VALUES
	('Pães'),
	('Frios'),
	('Bolacha'),
	('Clorados'),
	('Frutas'),
	('Esponjas'),
	('Massas'),
	('Molhos')

CREATE TABLE corredor (
codigo	INT IDENTITY(101, 1) PRIMARY KEY,
tipo	INT,
nome	VARCHAR(20),
FOREIGN KEY (tipo) REFERENCES tipo(codigo)
)

INSERT INTO corredor VALUES
	(10001, 'Padaria'),
	(10002, 'Calçados'),
	(10003, 'Biscoitos'),
	(10004, 'Limpeza'),
	(NULL, ''),
	(NULL, ''),
	(10007, 'Congelados')

CREATE TABLE mercadoria (
codigo		INT IDENTITY(1001, 1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
corredor	INT NOT NULL,
tipo		INT NOT NULL,
valor		DECIMAL(7,2) NOT NULL,
FOREIGN KEY (corredor) REFERENCES corredor(codigo),
FOREIGN KEY (tipo) REFERENCES tipo(codigo)
)

INSERT INTO mercadoria VALUES
	('Pão de Forma', 101, 10001, 3.5),
	('Presunto', 101, 10002, 2.0),
	('Cream Cracker', 103, 10003, 4.5),
	('Água Sanitária', 104, 10004, 6.5),
	('Maçã', 105, 10005, 0.9),
	('Palha de Aço', 106, 10006, 1.3),
	('Lasanha', 107, 10007, 9.7)

CREATE TABLE compra (
codigo			INT IDENTITY(1234, 1111) PRIMARY KEY,
codigo_cliente	INT NOT NULL,
valor			DECIMAL(7,2) NOT NULL,
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo)
)

INSERT INTO compra VALUES
	(2, 200),
	(4, 156),
	(6, 354),
	(3, 19)

--Pede-se:
--Valor da Compra de Luis Paulo

SELECT	co.valor
FROM	compra co, cliente cl
WHERE	co.codigo_cliente = cl.codigo AND
		cl.nome LIKE '%luis paulo%'

--Valor da Compra de Marcos Henrique

SELECT	co.valor
FROM	compra co, cliente cl
WHERE	co.codigo_cliente = cl.codigo AND
		cl.nome LIKE '%marcos henrique%'

--Endereço e telefone do comprador de Nota Fiscal = 4567

SELECT		cl.endereço,
			cl.fone
FROM		cliente cl
LEFT JOIN	compra co
ON			co.codigo_cliente = cl.codigo
WHERE		co.codigo = 4567

--Valor da mercadoria cadastrada do tipo " Pães"

SELECT		m.valor 
FROM		mercadoria m
LEFT JOIN	tipo t
ON			t.codigo = m.tipo
WHERE		t.nome LIKE '%pães%'

--Nome do corredor onde está a Lasanha

SELECT	co.nome
FROM	corredor co, tipo t, mercadoria m
WHERE	co.tipo = t.codigo AND
		t.codigo = m.tipo AND
		m.nome = 'lasanha'

--Nome do corredor onde estão os clorados

SELECT	co.nome
FROM	corredor co, tipo t
WHERE	co.tipo = t.codigo AND
		t.nome = 'clorados'