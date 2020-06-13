CREATE DATABASE exJoinAgr


USE MASTER 
DROP DATABASE exJoinAgr 

USE exJoinAgr

CREATE TABLE cliente (
codigo			INT IDENTITY(33601, 1) PRIMARY KEY, 
nome			VARCHAR(20) NOT NULL,
endereço		VARCHAR(40) NOT NULL,
numero_porta	VARCHAR(5) NOT NULL,
telefone		VARCHAR(9) NOT NULL,
data_nascimento	DATE NOT NULL
)

CREATE TABLE fornecedor (
codigo		INT IDENTITY(1001, 1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
atividade	VARCHAR(30) NOT NULL,
telefone	VARCHAR(9) NOT NULL
)

CREATE TABLE produto (
codigo				INT IDENTITY(1, 1) PRIMARY KEY,
nome				VARCHAR(30) NOT NULL,
valor_unitario		DECIMAL(7,2) NOT NULL,
quantidade_estoque	INT NOT NULL,
descriçao			VARCHAR(30) NOT NULL,
codigo_fornecedor	INT NOT NULL,
FOREIGN KEY (codigo_fornecedor) REFERENCES fornecedor(codigo)
)

CREATE TABLE pedido (
codigo				INT NOT NULL,
codigo_cliente		INT NOT NULL,
codigo_produto		INT NOT NULL,
quantidade			INT NOT NULL,
previsao_entrega	DATE NOT NULL,
CONSTRAINT pk_pedido PRIMARY KEY (codigo, codigo_cliente, codigo_produto)
)

INSERT INTO cliente VALUES
	('Maria Clara', 'R. 1° de Abril', '870', '96325874', '1990-04-15'),
	('Alberto Souza', 'R. XV de Novembro', '987', '95873625', '1975-12-25'),
	('Sonia Silva', 'R. Voluntários da Pátria', '1152', '75418596', '1944-06-03'),
	('José Sobrinho', 'Av. Paulista', '250', '85236547', '1982-10-12'),
	('Carlos Camargo', 'Av. Tiquatira', '9652', '75896325', '1975-02-27')

INSERT INTO fornecedor VALUES
	('Estrela', 'Brinquedo', '41525898'),
	('Lacta', 'Chocolate', '42698596'),
	('Asus', 'Informática', '52014596'),
	('Tramontina', 'Utensílios Domésticos', '50563985'),
	('Grow	', 'Brinquedos', '47896325'),
	('Mattel', 'Bonecos	', '59865898')

INSERT INTO produto VALUES
	('Banco Imobiliário', 65.00, 15, 'Versão Super Luxo', 1001),
	('Puzzle 5000 peças', 50.00, 5, 'Mapas Mundo', 1005),
	('Faqueiro', 350.00, 0, '120 peças', 1004),
	('Jogo para churrasco', 75.00, 3, '7 peças', 1004),
	('Eee Pc', 750.00, 29, 'Netbook com 4 Gb de HD', 1003),
	('Detetive', 49.00, 0, 'Nova Versão do Jogo', 1001),
	('Chocolate com Paçoquinha', 6.00, 0, 'Barra	', 1002),
	('Galak', 5.00, 65, 'Barra	', 1002)

INSERT INTO pedido VALUES
	(99001, 33601, 1, 1, '2017-07-07'),
	(99001, 33601, 2, 1, '2017-07-07'),
	(99001, 33601, 8, 3, '2017-07-07'),
	(99002, 33602, 2, 1, '2017-07-09'),
	(99002, 33602, 4, 3, '2017-07-09'),
	(99003, 33605, 5, 1, '2017-07-15')

--Informações:
--Considera-se um estoque confortável, aqueles produtos que tem valor acima de 20.
--Considera-se um bom estoque, aqueles produtos que tem valor entre 10 e 20.
--Considera-se um estoque baixo, aqueles produtos que tem valor entre 0 e 10.

--9 Questões:
--Codigo do produto, nome do produto, quantidade em estoque,
--uma coluna dizendo se está baixo, bom ou confortável,
--uma coluna dizendo o quanto precisa comprar para que o estoque fique minimamente confortável

SELECT	p.codigo,
		p.nome,
		p.quantidade_estoque,
		CASE WHEN (p.quantidade_estoque >= 20) THEN 'confortável'
		ELSE
			CASE WHEN (p.quantidade_estoque >= 10) THEN 'bom'
				ELSE 'baixo'
				END
		END AS nivel_estoque,
		CASE WHEN (p.quantidade_estoque >= 20) THEN 'N/A' 
		ELSE CAST(20 - p.quantidade_estoque AS CHAR)
		END AS falta_estoque
FROM	produto p

--Consultar o nome e o telefone dos fornecedores que não tem produtos cadastrados

SELECT		f.nome, 
			f.telefone
FROM		fornecedor f 
LEFT JOIN	produto p 
ON			f.codigo = p.codigo_fornecedor
WHERE		p.codigo_fornecedor IS NULL

--Consultar o nome e o telefone dos clientes que não tem pedidos cadastrados

SELECT		c.nome, 
			c.telefone
FROM		cliente c 
LEFT JOIN	pedido p 
ON			c.codigo = p.codigo_cliente
WHERE		p.codigo_cliente IS NULL

--Considerando a data do sistema, consultar o nome do cliente, 
--endereço concatenado com o número de porta
--o código do pedido e quantos dias faltam para a data prevista para a entrega
--criar, também, uma coluna que escreva ABAIXO para menos de 25 dias de previsão de entrega,
--ADEQUADO entre 25 e 30 dias e ACIMA para previsão superior a 30 dias
--as linhas de saída não devem se repetir e ordenar pela quantidade de dias

SELECT DISTINCT	c.nome,
				c.endereço + ', ' + c.numero_porta AS endereço_completo,
				p.codigo,
				DATEDIFF(DAY, p.previsao_entrega, GETDATE()) AS dias_ate_entrega,
				CASE WHEN ( DATEDIFF(DAY, p.previsao_entrega, GETDATE()) < 25) THEN 'ABAIXO'
				ELSE	CASE WHEN ( DATEDIFF(DAY, p.previsao_entrega, GETDATE()) <= 30) THEN 'ADEQUADO'
						ELSE 'ACIMA'
						END
				END AS classe_prazo
FROM			cliente c, pedido p
WHERE			c.codigo = p.codigo_cliente
ORDER BY		dias_ate_entrega ASC

--Consultar o Nome do cliente, o código do pedido, 
--a soma do gasto do cliente no pedido e a quantidade de produtos por pedido
--ordenar pelo nome do cliente

SELECT		c.nome,
			pe.codigo,
			pe.quantidade AS quantidade_produtos,
			SUM (pe.quantidade * pr.valor_unitario) AS gasto_total
FROM		cliente c, pedido pe, produto pr
WHERE		c.codigo = pe.codigo_cliente AND
			pr.codigo = pe.codigo_produto
GROUP BY	c.nome, pe.codigo, pe.quantidade
ORDER BY	c.nome ASC

--Consultar o Código e o nome do Fornecedor e 
--a contagem de quantos produtos ele fornece

SELECT		f.codigo,
			f.nome,
			COUNT(p.codigo_fornecedor)
FROM		fornecedor f, produto p
WHERE		f.codigo = p.codigo_fornecedor
GROUP BY	f.nome, f.codigo

--Consultar o nome e o telefone dos clientes que tem menos de 2 compras feitas
--A query não deve considerar quem fez 2 compras

SELECT		c.nome, 
			c.telefone
FROM		cliente c
LEFT JOIN	pedido pe
ON			c.codigo = pe.codigo_cliente
WHERE		pe.codigo_cliente IN
			(SELECT CASE WHEN ( COUNT(codigo_cliente) < 2) THEN codigo_cliente 
					ELSE NULL
					END
			FROM pedido
			GROUP BY codigo_cliente)

--Consultar o Codigo do pedido que tem o maior valor unitário de produto

SELECT		pe.codigo
FROM		pedido pe
LEFT JOIN	produto pr 
ON			pe.codigo_produto = pr.codigo
WHERE		pr.valor_unitario IN
			(SELECT MAX(valor_unitario)
			 FROM	produto)	 

--Consultar o Codigo_Pedido, o Nome do cliente e o valor total da compra do pedido
--O valor total se dá pela somatória de valor_Unitário * quantidade comprada

SELECT		pe.codigo,
			c.nome,
			SUM(pe.quantidade * pr.valor_unitario) AS valor_total
FROM		cliente c, pedido pe, produto pr
WHERE		c.codigo = pe.codigo_cliente AND
			pr.codigo = pe.codigo_produto
GROUP BY	pe.codigo, c.nome