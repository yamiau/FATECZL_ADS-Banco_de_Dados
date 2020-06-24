CREATE DATABASE ex_23_06

USE ex_23_06

CREATE TABLE cliente (
cpf			VARCHAR(11) PRIMARY KEY,
nome		VARCHAR(30) NOT NULL,
telefone	VARCHAR(9) NOT NULL
)

INSERT INTO cliente VALUES
	('25186533710', 'Maria Antonia', '87652314'),
	('34578909290', 'Julio Cesar', '82736541'),
	('79182639800', 'Paulo Cesar', '90765273'),
	('87627315416', 'Luiz Carlos', '61289012'),
	('36587498700', 'Paula Carla', '23547888')

CREATE TABLE fornecedor (
id			INT IDENTITY(1, 1) PRIMARY KEY,
nome		VARCHAR(30) NOT NULL,
logradouro	VARCHAR(40) NOT NULL,
numero		VARCHAR(5) NOT NULL,
complemento	VARCHAR(15),
cidade		VARCHAR(20) NOT NULL
)

INSERT INTO fornecedor VALUES
	('LG', 'Rod. Bandeirantes', '70000', 'Km 70', 'Itapeva'),
	('Asus', 'Av. Nações Unidas', '10206', 'Sala 225', 'São Paulo'),
	('AMD', 'Av. Nações Unidas', '10206', 'Sala 1095', 'São Paulo'),
	('Leadership', 'Av. Nações Unidas', '10206', 'Sala 87', 'São Paulo'),
	('Inno', 'Av. Nações Unidas', '10206', 'Sala 34', 'São Paulo'),
	('Kingston', 'Av. Nações Unidas', '10206', 'Sala 18', 'São Paulo')


CREATE TABLE produto (
codigo		INT IDENTITY(1, 1) PRIMARY KEY,
descriçao	VARCHAR(50) NOT NULL,
fornecedor	INT NOT NULL,
preço		DECIMAL(7,2) NOT NULL,
FOREIGN KEY (fornecedor) REFERENCES fornecedor(id)
)

INSERT INTO produto VALUES
	('Monitor 19 pol.', 1, 449.99),
	('Zenfone', 2, 1599.99),
	('Gravador de DVD - Sata', 1, 99.99),
	('Leitor de CD', 1, 49.99),
	('Processador - Ryzen 5', 3, 599.99),
	('Mouse', 4, 19.99),
	('Teclado', 4, 25.99),
	('Placa de Video - RTX 2060', 2, 2399.99),
	('Pente de Memória 4GB DDR 4 2400 MHz', 5, 259.99)

CREATE TABLE venda (
codigo		INT NOT NULL,
produto		INT NOT NULL,
cliente		VARCHAR(11) NOT NULL,
quantidade	INT NOT NULL,
valor_total	DECIMAL(7,2) NOT NULL,
data		DATE NOT NULL,
CONSTRAINT pk_venda PRIMARY KEY (codigo, produto, cliente, data),
FOREIGN KEY (produto) REFERENCES produto(codigo),
FOREIGN KEY (cliente) REFERENCES cliente(cpf)
)

INSERT INTO venda VALUES
	(1, 1, '25186533710', 1, 449.99, '2009-09-03'),
	(1, 4, '25186533710', 1, 49.99, '2009-09-03'),
	(1, 5, '25186533710', 1, 349.99, '2009-09-03'),
	(2, 6, '79182639800', 4, 79.96, '2009-09-06'),
	(3, 3, '87627315416', 1, 99.99, '2009-09-06'),
	(3, 7, '87627315416', 1, 25.99, '2009-09-06'),
	(3, 8, '87627315416', 1, 599.99, '2009-09-06'),
	(4, 2, '34578909290', 2, 1399.98, '2009-09-08')

--Consultas:	
	
--Quantos produtos não foram vendidos ?	

SELECT		p.descriçao
FROM		produto p
LEFT JOIN	venda v
ON			p.codigo = v.produto
WHERE		v.produto IS NULL

--Nome do produto, Nome do fornecedor, count() do produto nas vendas	

SELECT		p.descriçao,
			f.nome,
			COUNT(v.produto) * v.quantidade AS total_vendido
FROM		produto p, fornecedor f, venda v
WHERE		p.fornecedor = f.id AND
			p.codigo = v.produto
GROUP BY	f.nome, p.descriçao, v.quantidade

--Nome do cliente e Quantos produtos cada um comprou ordenado pela quantidade	

SELECT		c.nome,
			SUM(v.quantidade) AS qtd_comprada
FROM		cliente c, venda v
WHERE		c.cpf = v.cliente
GROUP BY	c.nome 
ORDER BY	qtd_comprada

--Nome do produto e Quantidade de vendas do produto com menor valor do catálogo de produtos	

SELECT		p.descriçao,
			SUM(v.produto)
FROM		produto p, venda v
WHERE		p.codigo = v.produto AND
			p.preço IN
			(SELECT	MIN(preço)
			 FROM	produto)
GROUP BY	p.descriçao

--Nome do Fornecedor e Quantos produtos cada um fornece	

SELECT		f.nome,
			COUNT(p.fornecedor) AS qtd_produtos
FROM		fornecedor f, produto p
WHERE		f.id = p.fornecedor
GROUP BY	f.nome

--Considerando que hoje é 20/10/2009, consultar o código da compra, nome do cliente, telefone do cliente e quantos dias da data da compra	

SELECT 
DISTINCT 	v.codigo,
			c.nome, 
			c.telefone,
			DATEDIFF(DAY, v.data, CONVERT(DATE, '20/10/2009', 103)) AS dias_desde_compra
FROM		venda v, cliente c
WHERE		v.cliente = c.cpf

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do cliente e quantidade que comprou mais de 2 produtos	

SELECT		SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS cpf,
			c.nome,
			COUNT(v.produto) * v.quantidade AS total_produtos
FROM		cliente c, venda v
WHERE		c.cpf = v.cliente
GROUP BY	cpf, c.nome, v.quantidade
HAVING		COUNT(v.produto) > 2

--CPF do cliente, mascarado (XXX.XXX.XXX-XX), Nome do Cliente e Soma do valor_total gasto	

SELECT		SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' + SUBSTRING(c.cpf, 7, 3) + '-' + SUBSTRING(c.cpf, 10, 2) AS cpf,
			c.nome,
			SUM(v.valor_total) AS total_gasto
FROM		cliente c, venda v
WHERE		c.cpf = v.cliente
GROUP BY	cpf, c.nome

--Código da compra, data da compra em formato (DD/MM/AAAA) e uma coluna, chamada dia_semana, que escreva o dia da semana por extenso
--Exemplo: Caso dia da semana 1, escrever domingo. Caso 2, escrever segunda-feira, assim por diante, até caso dia 7, escrever sábado

SELECT
DISTINCT	v.codigo,
			CONVERT(CHAR, v.data, 103) AS data,
			DATENAME(WEEKDAY, v.data) AS dia_da_semana
FROM		venda v


