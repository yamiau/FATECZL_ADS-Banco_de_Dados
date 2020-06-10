CREATE DATABASE ex02

--Fazer:				
--Como Chaves das tabelas, as colunas pintadas em amarelo				
--Como Chaves Estrangeiras, as colunas pintadas em vermelho	

CREATE TABLE carro (
placa		CHAR(8) PRIMARY KEY,
marca		VARCHAR(10) NOT NULL,
modelo		VARCHAR(10) NOT NULL,
cor			VARCHAR(10) NOT NULL,
ano			INT NOT NULL
)

CREATE TABLE cliente (
nome		VARCHAR(20) NOT NULL,
logradouro	VARCHAR(30) NOT NULL,
numero		INT NOT NULL,
bairro		VARCHAR(20) NOT NULL,
telefone	VARCHAR(9) NOT NULL,
carro		CHAR(8) NOT NULL,
PRIMARY KEY (nome, carro),
FOREIGN KEY (carro) REFERENCES carro(placa)
)

CREATE TABLE pe�a (
codigo		INT IDENTITY(1,1) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
valor		INT NOT NULL
)

CREATE TABLE servi�o (
carro		CHAR(8) NOT NULL,
pe�a		INT NOT NULL,
quantidade	INT NOT NULL,
valor		INT NOT NULL,
data		DATE NOT NULL,
PRIMARY KEY (carro, pe�a),
FOREIGN KEY (carro) REFERENCES carro(placa),
FOREIGN KEY (pe�a) REFERENCES pe�a(codigo)
)

INSERT INTO carro VALUES
	('AFT-9087', 'VW', 'Gol', 'Preto', 2007),
	('DXO-9876', 'Ford', 'Ka', 'Azul', 2000),
	('EGT-4631', 'Renault', 'Clio', 'Verde', 2004),
	('LKM-7380', 'Fiat', 'Palio', 'Prata', 1997),
	('BCD-7521', 'Ford', 'Fiesta', 'Preto', 1999)

INSERT INTO cliente VALUES
	('Jo�o Alves', 'R. Pereira Barreto', 1258, 'Jd. Oliveiras', '2154-9658', 'DXO-9876'),
	('Ana Maria', 'R. 7 de Setembro', 259, 'Centro', '9658-8541', 'LKM-7380' ),
	('Clara Oliveira', 'Av. Na��es Unidas', 10254, 'Pinheiros', '2458-9658', 'EGT-4631' ),
	('Jos� Sim�es', 'R. XV de Novembro', 36, '�gua Branca', '7895-2459', 'BCD-7521' ),
	('Paula Rocha', 'R. Anhaia', 548, 'Barra Funda', '6958-2548', 'AFT-9087' )

INSERT INTO pe�a VALUES
	('Vela', 70),
	('Correia Dentada', 125),
	('Trambulador', 90),
	('Filtro de Ar', 30)

INSERT INTO servi�o VALUES
	('DXO-9876', 1, 4, 280, '01/08/2009'),
	('DXO-9876', 4, 1, 30, '01/08/2009'),
	('EGT-4631', 3, 1, 90, '02/08/2009'),
	('DXO-9876', 2, 1, 125, '07/08/2009')
	
				
--Consultar em diversas fases: (2 consultas, 1� achar o que eles t�m em comum e depois fazer a consulta)				
--Telefone do dono do carro Ka, Azul				

SELECT	telefone
FROM	cliente
WHERE	carro IN
	(SELECT	placa
	 FROM	carro 
	 WHERE	cor = 'Azul' AND
			modelo = 'Ka')

--Endere�o concatenado do cliente que fez o servi�o do dia 02/08/2009	

SELECT	logradouro + ', ' + CONVERT(CHAR, numero) + ', ' + bairro AS endere�o
FROM	cliente
WHERE	carro IN
	(SELECT	carro
	 FROM	servi�o 
	 WHERE data = '02/08/2009')
				
--Consultar:				
--Placas dos carros de anos anteriores a 2001			

SELECT	placa 
FROM	carro 
WHERE	ano < 2001

--Marca, modelo e cor, concatenado dos carros posteriores a 2005	

SELECT	 marca + ' ' + modelo + ' ' + cor AS marca_modelo_cor
FROM	carro
WHERE	ano > 2005

--C�digo e nome das pe�as que custam menos de R$80,00				

SELECT	codigo, nome 
FROM	pe�a 
WHERE	valor < 80 