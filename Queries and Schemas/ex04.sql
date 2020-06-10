CREATE DATABASE ex04

CREATE TABLE cliente4 (
cpf			CHAR(11) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
telefone	VARCHAR(9) NOT NULL
)

INSERT INTO cliente4 VALUES 
	('34578909290', 'Julio Cesar', '8273-6541'), 
	('25186533710', 'Maria Antonia', '8765-2314'),
	('87627315416', 'Luiz Carlos', '6128-9012'),
	('79182639800', 'Paulo Cesar', '9076-5273')

CREATE TABLE fornecedor (
id			INT IDENTITY(1,1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
logradouro	VARCHAR(30) NOT NULL,
numero		VARCHAR(5) NOT NULL,
complemento	VARCHAR(15) NOT NULL,
cidade		VARCHAR(15) NOT NULL
)

INSERT INTO fornecedor VALUES 
	('LG', 'Rod. Bandeirantes', '70000', 'Km 70', 'Itapeva'),
	('Asus', 'Av. Nações Unidas', '10206', 'Sala 225', 'São Paulo'),
	('AMD', 'Av. Nações Unidas', '10206', 'Sala 1095', 'São Paulo'),
	('Leadership', 'Av. Nações Unidas', '10206', 'Sala 87', 'São Paulo'),
	('Inno', 'Av. Nações Unidas', '10206', 'Sala 34', 'São Paulo')

CREATE TABLE produto (
codigo		INT IDENTITY(1,1) PRIMARY KEY,
descriçao	VARCHAR(30) NOT NULL,
fornecedor	INT NOT NULL,
preço		DECIMAL(7,2) NOT NULL,
FOREIGN KEY (fornecedor) REFERENCES fornecedor(id)
)

ALTER TABLE produto
ALTER COLUMN descriçao VARCHAR(60)

INSERT INTO produto VALUES 
	('Monitor 19 pol.', 1, 449.99),
	('Netbook 1GB Ram 4 Gb HD', 2, 699.99),
	('Gravador de DVD', 1, 99.99),
	('Leitor de CD.', 1, 49.99),
	('Processador - Phenom X3 - 2.1GHz', 3, 349.99),
	('Mouse', 4, 19.99),
	('Teclado', 4, 25.99),
	('Placa de Video - Nvidia 9800 GTX - 256MB/256 bits', 5, 599.99)

CREATE TABLE venda (
codigo		INT NOT NULL,
produto		INT NOT NULL,
cliente		CHAR(11) NOT NULL,
quantidade	INT NOT NULL,
valor_total	DECIMAL(7,2) NOT NULL,
data		DATE NOT NULL,
PRIMARY KEY (codigo, produto, cliente),
FOREIGN KEY (produto) REFERENCES produto(codigo),
FOREIGN KEY (cliente) REFERENCES cliente4(cpf)
)

INSERT INTO venda VALUES 
	(1, 1, '25186533710', 1, 449.99, '03/09/2009'),
	(1, 4, '25186533710', 1, 49.99, '03/09/2009'),
	(1, 5, '25186533710', 1, 349.99, '03/09/2009'),
	(2, 6, '79182639800', 4, 79.96, '06/09/2009'),
	(3, 8, '87627315416', 1, 599.99, '06/09/2009'),
	(3, 3, '87627315416', 1, 99.99, '06/09/2009'),
	(3, 7, '87627315416', 1, 25.99, '06/09/2009'),
	(4, 2, '34578909290', 2, 1399.98, '08/09/2009')

--Consultar no formato dd/mm/aaaa:						
--Data da Venda 4			

SELECT  FORMAT(data, 'dd/MM/yyyy') as data
FROM	venda
WHERE	codigo = 4
						
--Inserir na tabela Fornecedor, a coluna Telefone						
--e os seguintes dados:						
--1	7216-5371					
--2	8715-3738					
--4	3654-6289					

ALTER TABLE fornecedor
ADD telefone VARCHAR(9)

UPDATE	fornecedor 
SET		telefone = '7216-5371'
WHERE	id = 1

UPDATE	fornecedor 
SET		telefone = '8715-3738'
WHERE	id = 2

UPDATE	fornecedor 
SET		telefone = '3654-6289'
WHERE	id = 4

SELECT *
FROM fornecedor
						
--Consultar por ordem alfabética de nome, o nome, o endereço concatenado e 
--o telefone dos fornecedores						

SELECT	nome, 
		logradouro + ', ' + numero + ' (' + complemento + ') ' + ', ' + cidade AS endereço
FROM	fornecedor
ORDER BY nome ASC

						
--Consultar:						
--Produto, quantidade e valor total do comprado por Julio Cesar		

SELECT	v.produto, v.quantidade, v.valor_total	
FROM	venda v, cliente4 c
WHERE	v.cliente = c.cpf AND
		c.nome = 'Julio Cesar'

--Data, no formato dd/mm/aaaa e valor total do produto comprado por  Paulo Cesar	

SELECT	FORMAT(v.data, 'dd/MM/yyyy') AS data,
		v.valor_total
FROM	venda v, cliente4 c
WHERE	v.cliente = c.cpf AND
		c.nome = 'Paulo Cesar'

--Consultar, em ordem decrescente, o nome e o preço de todos os produtos 						

SELECT	descriçao, 
		preço
FROM	produto
ORDER BY descriçao DESC