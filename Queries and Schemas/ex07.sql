CREATE DATABASE ex07

USE ex07

CREATE TABLE cliente (
rg			VARCHAR(13) PRIMARY KEY,
cpf			CHAR(14) NOT NULL,
nome		VARCHAR(20) NOT NULL,
endereço	VARCHAR(30) NOT NULL
)

INSERT INTO cliente VALUES 
	('2.953.184-4', '345.198.780-40', 'Luiz André', 'R. Astorga, 500'),
	('13.514.996-x', '849.842.856-30', 'Maria Luiza', 'R. Piauí, 174'),
	('12.198.554-1', '233.549.973-10', 'Ana Barbara', 'Av. Jaceguai, 1141'),
	('23.987.746-x', '435.876.699-20', 'Marcos Alberto', 'R. Quinze, 22')

CREATE TABLE fornecedor (
codigo		INT IDENTITY (1,1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
endereço	VARCHAR(40) NOT NULL,
telefone	VARCHAR(15),
cgc			CHAR(14),
cidade		VARCHAR(20),
transporte	VARCHAR(10),
pais		VARCHAR(15),
moeda		VARCHAR(5)
)

INSERT INTO fornecedor VALUES
	('Clone', 'Av. Nações Unidas, 12000', '(11)4148-7000', NULL, 'São Paulo', NULL, NULL, NULL),
	('Logitech', '28th Street, 100', '1-800-145990', NULL, NULL, 'Avião', 'EUA', 'US$'),
	('LG', 'Rod. Castello Branco', '0800-664400', '415997810/0001', 'Sorocaba', NULL, NULL, NULL),
	('PcChips', 'Ponte da Amizade', NULL, NULL, NULL, 'Navio', 'Py', 'US$')

CREATE TABLE mercadoria (
codigo			INT IDENTITY(10,1) PRIMARY KEY,
descriçao		VARCHAR(20) NOT NULL,
preço			DECIMAL(7,2) NOT NULL,
qtd				INT NOT NULL,
cod_fornecedor	INT NOT NULL,
FOREIGN KEY (cod_fornecedor) REFERENCES fornecedor(codigo)
)

INSERT INTO mercadoria VALUES
	('Mouse', 24, 30, 1),
	('Teclado', 50, 20, 1),
	('Cx. De Som', 30, 8, 2),
	('Monitor 17', 350, 4, 3),
	('Notebook', 1500, 7, 4)

CREATE TABLE pedido (
nota_fiscal		INT IDENTITY(1001, 1) PRIMARY KEY,
valor			DECIMAL(7,2) NOT NULL,
data			DATE NOT NULL,
rg_cliente		VARCHAR(13) NOT NULL,
FOREIGN KEY (rg_cliente) REFERENCES cliente(rg)
)

INSERT INTO pedido VALUES 
	(754, '01/04/2018', '12.198.554-1'),
	(350, '02/04/2018', '12.198.554-1'),
	(30, '02/04/2018', '2.953.184-4'),
	(1500, '03/04/2018', '13.514.996-x')

--Consultar 10% de desconto no pedido 1003

SELECT	valor * 0.9 AS valor_10pc_desconto
FROM	pedido
WHERE	nota_fiscal = 1003

--Consultar 5% de desconto em pedidos com valor maior de R$700,00

SELECT	valor * 0.95 AS valor_05pc_desconto
FROM	pedido
WHERE	valor > 700

--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10

SELECT	preço
FROM	mercadoria 
WHERE	qtd < 10

UPDATE	mercadoria
SET		preço = preço * 1.2
WHERE	qtd < 10

SELECT	preço
FROM	mercadoria 
WHERE	qtd < 10

--Data e valor dos pedidos do Luiz

SELECT	p.data,
		p.valor 
FROM	pedido p, cliente c
WHERE	p.rg_cliente = c.rg AND
		c.nome LIKE '%Luiz%'

--CPF, Nome e endereço do cliente de nota 1004

SELECT	c.cpf,
		c.nome,
		c.endereço 
FROM	cliente c, pedido p
WHERE	p.rg_cliente = c.rg AND
		p.nota_fiscal = 1004
		
--País e meio de transporte da Cx. De som

SELECT	f.pais,
		f.transporte
FROM	fornecedor f, mercadoria m
WHERE	m.cod_fornecedor = f.codigo AND
		m.descriçao = 'Cx. De som' 

--Nome e Quantidade em estoque dos produtos fornecidos pela Clone

SELECT	m.descriçao,
		m.qtd AS qtd_estoque
FROM	mercadoria m, fornecedor f
WHERE	m.cod_fornecedor = f.codigo AND
		f.nome = 'Clone'

--Endereço e telefone dos fornecedores do monitor

SELECT	f.endereço,
		f.telefone
FROM	fornecedor f, mercadoria m
WHERE	f.codigo = m.cod_fornecedor AND
		m.descriçao LIKE '%monitor%'

--Tipo de moeda que se compra o notebook

SELECT	f.moeda
FROM	fornecedor f, mercadoria m
WHERE	f.codigo = m.cod_fornecedor AND
		m.descriçao LIKE '%notebook%'

--Há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido 
--antigo para pedidos feitos há mais de 6 meses

SELECT	DATEDIFF(DAY, data, GETDATE()) AS dias_passados,
		CASE WHEN ( DATEDIFF(MONTH, data, GETDATE()) > 6)	
			THEN 'sim'
			ELSE 'não'
			END AS pedido_antigo
FROM	pedido 

--Nome e Quantos pedidos foram feitos por cada cliente

SELECT	c.nome,
		COUNT(p.nota_fiscal) AS pedidos_totais
FROM	cliente c, pedido p
WHERE	c.rg = p.rg_cliente
GROUP BY c.nome
ORDER BY pedidos_totais, c.nome ASC

--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos

SELECT		c.rg,
			c.cpf,
			c.nome,
			c.endereço 
FROM		cliente c 
LEFT JOIN	pedido p 
ON			c.rg = p.rg_cliente
WHERE		p.rg_cliente IS NULL