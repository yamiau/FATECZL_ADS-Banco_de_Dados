CREATE DATABASE ex12

USE ex12

CREATE TABLE plano(
cod		INT IDENTITY PRIMARY KEY,
nome	VARCHAR(11) NOT NULL,
valor	SMALLINT NOT NULL
)

INSERT INTO plano VALUES
	('100 Minutos', 80),
	('150 Minutos', 130),
	('200 Minutos', 160),
	('250 Minutos', 220),
	('300 Minutos', 260),
	('600 Minutos', 350)

CREATE TABLE servico(
cod		INT IDENTITY PRIMARY KEY,
nome	VARCHAR(30) NOT NULL,
valor	SMALLINT NOT NULL
)

INSERT INTO servico VALUES
	('100 SMS', 10),
	('SMS Ilimitado', 30),
	('Internet 500 MB', 40),
	('Internet 1 GB', 60),
	('Internet 2 GB', 70)

CREATE TABLE cliente(
cod			INT IDENTITY(1234, 1234) PRIMARY KEY,
nome		VARCHAR(30) NOT NULL,
dataInicio	DATE
)

INSERT INTO cliente VALUES
	('Cliente A', '15/10/2012'),
	('Cliente B', '20/11/2012'),
	('Cliente C', '25/11/2012'),
	('Cliente D', '01/12/2012'),
	('Cliente E', '18/12/2012'),
	('Cliente F', '20/01/2013'),
	('Cliente G', '25/01/2013')


CREATE TABLE contrato(
cod_cliente	INT NOT NULL,
cod_plano	INT	NOT NULL,
cod_servico	INT NOT NULL,
status		CHAR(1) NOT NULL,
data		DATE,
CONSTRAINT pk_contrato PRIMARY KEY (cod_cliente, cod_plano, cod_servico, status),
FOREIGN KEY (cod_cliente) REFERENCES cliente(cod),
FOREIGN KEY (cod_plano) REFERENCES plano(cod),
FOREIGN KEY (cod_servico) REFERENCES servico(cod)
)

INSERT INTO contrato VALUES
	(1234, 3, 1, 'E', '15/10/2012'),
	(1234, 3, 3, 'E', '15/10/2012'),
	(1234, 3, 3, 'A', '16/10/2012'),
	(1234, 3, 1, 'A', '16/10/2012'),
	(2468, 4, 4, 'E', '20/11/2012'),
	(2468, 4, 4, 'A', '21/11/2012'),
	(6170, 6, 2, 'E', '18/12/2012'),
	(6170, 6, 5, 'E', '19/12/2012'),
	(6170, 6, 2, 'A', '20/12/2012'),
	(6170, 6, 5, 'A', '21/12/2012'),
	(1234, 3, 1, 'D', '10/01/2013'),
	(1234, 3, 3, 'D', '10/01/2013'),
	(1234, 2, 1, 'E', '10/01/2013'),
	(1234, 2, 1, 'A', '11/01/2013'),
	(2468, 4, 4, 'D', '25/01/2013'),
	(7404, 2, 1, 'E', '20/01/2013'),
	(7404, 2, 5, 'E', '20/01/2013'),
	(7404, 2, 5, 'A', '21/01/2013'),
	(7404, 2, 1, 'A', '22/01/2013'),
	(8638, 6, 5, 'E', '25/01/2013'),
	(8638, 6, 5, 'A', '26/01/2013'),
	(7404, 2, 5, 'D', '03/02/2013')

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato 
--(sem repetições) por contrato, dos planos cancelados, ordenados pelo nome do cliente	

SELECT 
DISTINCT 
	cl.nome,
	p.nome,
	COUNT(co.status) AS qtd_estados
FROM	
	cliente cl, plano p, contrato co
WHERE	
	co.cod_cliente = cl.cod AND
	co.cod_plano = p.cod AND
	co.status = 'D'
GROUP BY
	cl.nome, 
	p.nome 
ORDER BY 
	cl.nome		

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato 
--(sem repetições) por contrato, dos planos não cancelados, ordenados pelo nome do cliente	

SELECT
DISTINCT 
	cl.nome,
	p.nome,
	COUNT(co.status) AS qtd_estados
FROM	
	cliente cl, plano p, contrato co
WHERE	
	co.cod_cliente = cl.cod AND
	co.cod_plano = p.cod AND
	co.status = 'A' OR
	co.status = 'E'
GROUP BY
	cl.nome, 
	p.nome 
ORDER BY 
	cl.nome	
	

-- Consultar o nome do cliente, o nome do plano, e o valor da conta de cada contrato 
--que está ou esteve ativo, sob as seguintes condições:	
	-- A conta é o valor do plano, somado à soma dos valores de todos os serviços
	-- Caso a conta tenha valor superior a R$400.00, deverá ser incluído um desconto de 8%
	-- Caso a conta tenha valor entre R$300,00 a R$400.00, deverá ser incluído um desconto de 5%
	-- Caso a conta tenha valor entre R$200,00 a R$300.00, deverá ser incluído um desconto de 3%
	-- Contas com valor inferiores a R$200,00 não tem desconto

-- Consultar o nome do cliente, o nome do serviço, e a duração, em meses (até a data de hoje) 
--do serviço, dos cliente que nunca cancelaram nenhum plano	

SELECT
	cl.nome,
	s.nome,
	DATEDIFF(MONTH, co.data, GETDATE()) AS duracao_servico
FROM
	cliente cl, servico s, contrato co
WHERE	
	cl.cod = co.cod_cliente AND
	s.cod = co.cod_servico AND
	cl.cod NOT IN (
		SELECT	cl.cod
		FROM	cliente cl, contrato co
		WHERE	cl.cod = co.cod_cliente AND
				co.status = 'D')