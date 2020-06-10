CREATE DATABASE ex05

USE ex05

CREATE TABLE cliente (
codigo		INT IDENTITY(33601, 1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
endereço	VARCHAR(40) NOT NULL,
telefone	VARCHAR(9) NOT NULL,
idade		INT NOT NULL
)

INSERT INTO cliente VALUES 
	('Maria Clara', 'R. 1° de Abril, 870', '96325874', 21), 
	('Alberto Souza', 'R. XV de Novembto, 987', '95873625', 35),
	('Sonia Silva', 'R. Voluntários da Pátria, 1152', '75418596', 63),
	('José Sobrinho', 'Av. Paulista, 250', '85236547', 34),
	('Carlos Camargo', 'Av. Tiquatira, 9652', '75896325', 55)

CREATE TABLE fornecedor (
codigo		INT IDENTITY(1001,1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
atividade	VARCHAR(30) NOT NULL,
telefone	VARCHAR(9) NOT NULL,
)

INSERT INTO fornecedor VALUES 
	('Estrela', 'Brinquedo', '41525898'),
	('Lacta', 'Chocolate', '42698596'),
	('Asus', 'Informática', '52014596'),
	('Tramontina', 'Utensílios Domésticos', '50563985'),
	('Grow', 'Brinquedos', '47896325'),
	('Mattel', 'Bonecos', '59865898')

CREATE TABLE produto (
codigo				INT IDENTITY(1,1) PRIMARY KEY,
nome				VARCHAR(30) NOT NULL,
valor_unitario		DECIMAL(7,2) NOT NULL,
quantidade_estoque	INT NOT NULL,
descriçao			VARCHAR(30) NOT NULL,
codigo_fornecedor	INT NOT NULL
FOREIGN KEY (codigo_fornecedor) REFERENCES fornecedor(codigo)
)

INSERT INTO produto VALUES 
	('Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001),
	('Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005),
	('Faqueiro', 350.00, 0, '120 peças', 1004),
	('Jogo para churrasco', 75.00, 3, '7 peças', 1004),
	('Eee Pc', 750.00, 29, 'Netbook com 4 Gb de HD', 1003),
	('Detetive', 49.00, 0, 'Nova Versão do Jogo', 1001),
	('Chocolate com Paçoquinha', 6.00, 0, 'Barra', 1002),
	('Galak', 5.00, 65, 'Barra', 1002)


CREATE TABLE pedido (
codigo				INT NOT NULL,
codigo_cliente		INT NOT NULL,
codigo_produto		INT NOT NULL,
quantidade			INT NOT NULL,
valor_total			DECIMAL(7,2) NOT NULL,
previsao_entrega	DATE NOT NULL,
PRIMARY KEY (codigo, codigo_cliente, codigo_produto),
FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo),
FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)

INSERT INTO pedido VALUES 
	(99001, 33601, 1, 1, 65.00, '07/06/2012' ),
	(99001, 33601, 2, 1, 50.00, '07/06/2012' ),
	(99001, 33601, 8, 3, 15.00, '07/06/2012' ),
	(99002, 33602, 2, 1, 50.00, '09/06/2012' ),
	(99002, 33602, 4, 3, 225.00, '09/06/2012' ),
	(99003, 33605, 5, 1, 750.00, '15/06/2012' )

--Consultar, em duas fases, a quantidade, valor total e valor total com desconto (25%) dos itens comprados par Maria Clara.

SELECT	quantidade,
		valor_total,
		valor_total * 0.75 AS valor_total_25pc_desconto
FROM	pedido 
WHERE	codigo_cliente IN
		(SELECT	codigo
		 FROM	cliente 
		 WHERE	nome = 'Maria Clara')


--Verificar quais brinquedos não tem itens em estoque.						

SELECT	p.nome 
FROM	produto p, fornecedor f
WHERE	p.quantidade_estoque < 1 AND
		f.atividade LIKE '%Brinquedo%' AND
		p.codigo_fornecedor = f.codigo



--Alterar para reduzir em 10% o valor das barras de chocolate.	

UPDATE	produto
SET		valor_unitario = valor_unitario * 0.9
WHERE	descriçao = 'Barra'

SELECT	valor_unitario 
FROM	produto 
WHERE	descriçao = 'Barra'

--Alterar a quantidade em estoque do faqueiro para 10 peças.	

UPDATE	produto
SET		descriçao = '10 peças'
WHERE	nome = 'Faqueiro'

SELECT	descriçao
FROM	produto 
WHERE	nome = 'Faqueiro'

--Consultar quantos clientes tem mais de 40 anos.						

SELECT	COUNT(codigo) AS quantidade
FROM	cliente 
WHERE	idade > 40

--Consultar Nome e telefone dos fornecedores de Brinquedos e Chocolate.						

SELECT	nome, 
		telefone 
FROM	fornecedor
WHERE	atividade LIKE '%Brinquedo%' OR 
		atividade LIKE '%Chocolate%'
ORDER BY atividade ASC

--Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00						

SELECT	nome, 
		valor_unitario * 0.75 AS valor_25pc_desconto
FROM	produto
WHERE	valor_unitario < 50.00

--Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00						

SELECT	nome, 
		valor_unitario * 1.1 AS valor_10pc_aumento
FROM	produto 
WHERE	valor_unitario > 100.00

--Consultar desconto de 15% no valor total de cada produto da venda 99001.

SELECT	pd.valor_total * 0.85 AS valor_total_15pc_desconto
FROM	produto p, pedido pd
WHERE	pd.codigo_produto = p.codigo AND
		pd.codigo = 99001