CREATE DATABASE ex10

USE ex10 

CREATE TABLE medicamento (
codigo			INT IDENTITY(1, 1) PRIMARY KEY,
nome			VARCHAR(40) NOT NULL,
apresentacao	VARCHAR(30) NOT NULL,
unidade_cad		VARCHAR(20) NOT NULL,
preço_proposto	DECIMAL(7,2) NOT NULL			
)

INSERT INTO medicamento VALUES
	('Acetato de medroxiprogesterona ', '150 mg/ml', 'Ampola', 6.700),
	('Aciclovir', '200mg/comp.', 'Comprimido', 0.280),
	('Ácido Acetilsalicílico ', '500mg/comp.', 'Comprimido ', 0.035),
	('Ácido Acetilsalicílico ', '100mg/comp.', 'Comprimido ', 0.030),
	('Ácido Fólico', '5mg/comp.', 'Comprimido ', 0.054),
	('Albendazol', '400mg/comp. mastigável', 'Comprimido ', 0.560),
	('Alopurinol', '100mg/comp. ', 'Comprimido ', 0.080),
	('Amiodarona', '200mg/comp. ', 'Comprimido ', 0.200),
	('Amitriptilina(Cloridrato)', '25mg/comp.', 'Comprimido', 0.220),
	('Amoxicilina', '500mg/cáps.', 'Cápsula', 0.190)

CREATE TABLE cliente (
cpf		VARCHAR(12) PRIMARY KEY,
nome	VARCHAR(30) NOT NULL,
rua		VARCHAR(40) NOT NULL,
num		VARCHAR(5) NOT NULL,
bairro	VARCHAR(20) NOT NULL,
fone	VARCHAR(9) NOT NULL
)

INSERT INTO cliente VALUES
	('343908987-00', 'Maria Zélia', 'Anhaia', '65', 'Barra Funda', '92103762'), 
	('213459862-90', 'Roseli Silva', 'Xv. De Novembro', '987', 'Centro', '82198763'), 
	('869279818-25', 'Carlos Campos', 'Voluntários da Pátria', '1276', 'Santana', '98172361'), 
	('310981209-00', 'João Perdizes', 'Carlos de Campos', '90', 'Pari', '61982371')

CREATE TABLE venda (
nota_fiscal		INT	NOT NULL,
cpf_cliente		VARCHAR(12) NOT NULL,
cod_medicamento	INT NOT NULL,
quantidade		INT NOT NULL,
valor_total		DECIMAL(7,2) NOT NULL,
data			DATE NOT NULL,
CONSTRAINT pk_venda PRIMARY KEY (nota_fiscal, cpf_cliente, cod_medicamento),
FOREIGN KEY (cpf_cliente) REFERENCES cliente(cpf),
FOREIGN KEY (cod_medicamento) REFERENCES medicamento(codigo)
)

INSERT INTO venda VALUES
	(31501, '869279818-25', 10, 3, 0.57, '01/11/2010'),
	(31501, '869279818-25', 2, 10, 2.8, '01/11/2010'),
	(31501, '869279818-25', 5, 30, 1.05, '01/11/2010'),
	(31501, '869279818-25', 8, 30, 6.6, '01/11/2010'),
	(31502, '343908987-00', 8, 15, 3, '01/11/2010'),
	(31502, '343908987-00', 2, 10, 2.8, '01/11/2010'),
	(31502, '343908987-00', 9, 10, 2.2, '01/11/2010'),
	(31503, '310981209-00', 1, 20, 134, '02/11/2010')

--Consultar

--Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos

SELECT		m.nome,
			m.apresentacao,
			m.unidade_cad,
			m.preço_proposto
FROM		medicamento m
LEFT JOIN	venda v
ON			m.codigo = v.cod_medicamento
WHERE		v.cod_medicamento IS NULL

--Nome dos clientes que compraram Amiodarona

SELECT	c.nome
FROM	cliente c, venda v
WHERE	c.cpf = v.cpf_cliente AND
		v.cod_medicamento IN
		(SELECT codigo
		 FROM	medicamento 
		 WHERE	nome = 'Amiodarona')

--CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  apresentação do remédio, 
--unidade, preço proposto, quantidade vendida e valor total dos remédios vendidos a Maria Zélia

SELECT	c.cpf,
		c.rua + ', ' + c.num AS endereço,
		m.nome AS nome_remedio,
		m.apresentacao,
		m.unidade_cad,
		m.preço_proposto,
		v.quantidade,
		v.valor_total
FROM	cliente c, medicamento m, venda v
WHERE	c.cpf = v.cpf_cliente AND
		v.cod_medicamento = m.codigo AND
		c.nome = 'Maria Zélia'

--Data de compra, convertida, de Carlos Campos

SELECT DISTINCT	CONVERT(CHAR, v.data, 103) AS data_compra
FROM			venda v
LEFT JOIN		cliente c
ON				v.cpf_cliente = c.cpf
WHERE			c.nome = 'Carlos Campos'

--Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina

UPDATE	medicamento 
SET		nome = 'Cloridrato de Amitriptilina'
WHERE	nome LIKE '%amitriptilina%'
