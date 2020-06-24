USE MASTER
DROP DATABASE ex06

CREATE DATABASE ex06

USE ex06

CREATE TABLE motorista(
codigo			INT IDENTITY(12341, 1) PRIMARY KEY,
nome			VARCHAR(30) NOT NULL,
idade			INT NOT NULL,
naturalidade	VARCHAR(15) NOT NULL
)

CREATE TABLE onibus(
placa		CHAR(7) PRIMARY KEY,
marca		VARCHAR(15) NOT NULL,
ano			INT NOT NULL,
descri�ao	VARCHAR(30) NOT NULL
)

CREATE TABLE viagem(
codigo			INT IDENTITY (101, 1) PRIMARY KEY,
onibus			CHAR(7) NOT NULL,
motorista		INT NOT NULL,
hora_saida		CHAR(3) NOT NULL,
hora_chegada	CHAR(3) NOT NULL,
destino			VARCHAR(20) NOT NULL,
FOREIGN KEY (onibus) REFERENCES onibus(placa),
FOREIGN KEY (motorista) REFERENCES motorista(codigo)
)

INSERT INTO motorista VALUES
	('Julio Cesar', 48, 'S�o Paulo'),
	('Mario Carmo', 27, 'Americana'),
	('Lucio Castro', 53, 'Campinas'),
	('Andr� Figueiredo', 33, 'S�o Paulo'),
	('Luiz Carlos', 23, 'S�o Paulo')

INSERT INTO onibus VALUES
	('adf0965', 'Mercedes', 1999, 'Leito'),
	('bhg7654', 'Mercedes', 2002, 'Sem Banheiro'),
	('dtr2093', 'Mercedes', 2001, 'Ar Condicionado'),
	('gui7625', 'Volvo', 2001, 'Ar Condicionado')

INSERT INTO viagem VALUES
	('adf0965', 12343, '10h', '12h', 'Campinas'),
	('gui7625', 12341, '07h', '12h', 'Araraquara'),
	('bhg7654', 12345, '14h', '22h', 'Rio de Janeiro'),
	('dtr2093', 12344, '18h', '21h', 'Sorocaba')

-- Consultar, da tabela viagem, todas as horas de chegada e sa�da, convertidas em formato HH:mm (108) e seus destinos

SELECT	SUBSTRING(hora_chegada, 1, 2) + ':00' AS hora_chegada,
		SUBSTRING(hora_saida, 1, 2) + ':00' AS hora_saida,
		destino
FROM	viagem 


-- Consultar, com subquery, o nome do motorista que viaja para Sorocaba

SELECT	nome
FROM	motorista 
WHERE	codigo IN
	(SELECT	motorista 
	 FROM	viagem
	 WHERE	destino = 'Sorocaba')

-- Consultar, com subquery, a descri��o do �nibus que vai para o Rio de Janeiro

SELECT	descri�ao
FROM	onibus 
WHERE	placa IN
	(SELECT	onibus 
	 FROM	viagem
	 WHERE	destino = 'Rio de Janeiro')

-- Consultar, com Subquery, a descri��o, a marca e o ano do �nibus dirigido por Luiz Carlos

SELECT	descri�ao,
		marca,
		ano
FROM	onibus 
WHERE	placa IN
	(SELECT	v.onibus 
	 FROM	viagem v, motorista m
	 WHERE	v.motorista = m.codigo AND
			m.nome = 'Luiz Carlos')

--Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos

SELECT	nome,
		idade,
		naturalidade
FROM	motorista 
WHERE	idade > 30
ORDER BY idade ASC

