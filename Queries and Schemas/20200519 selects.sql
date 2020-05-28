USE MASTER
DROP DATABASE selects

CREATE DATABASE selects
GO
USE selects
GO
 
CREATE TABLE funcionario(
id          INT				NOT NULL	IDENTITY(1,1),
nome        VARCHAR(100)    NOT NULL,
sobrenome   VARCHAR(200)    NOT NULL,
logradouro  VARCHAR(200)    NOT NULL,
numero      INT             NOT NULL	CHECK(numero > 0 AND numero < 100000),
bairro      VARCHAR(100)    NULL,
cep         CHAR(8)         NULL		CHECK(LEN(cep) = 8),
ddd         CHAR(2)         NULL		DEFAULT('11'),
telefone    CHAR(8)         NULL		CHECK(LEN(telefone) = 8),
data_nasc   DATE	        NOT NULL	CHECK(data_nasc < GETDATE()),
salario     DECIMAL(7,2)    NOT NULL	CHECK(salario > 0.00)
PRIMARY KEY(id)
)
GO
CREATE TABLE projeto(
codigo      INT             NOT NULL	IDENTITY(1001,1),
nome        VARCHAR(200)    NOT NULL	UNIQUE,
descricao   VARCHAR(300)    NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE funcproj(
id_funcionario  INT         NOT NULL,
codigo_projeto  INT         NOT NULL,
data_inicio     DATETIME    NOT NULL,
data_fim        DATETIME    NOT NULL,
CONSTRAINT chk_dt CHECK(data_fim > data_inicio),
PRIMARY KEY (id_funcionario, codigo_projeto),
FOREIGN KEY (id_funcionario) REFERENCES funcionario (id),
FOREIGN KEY (codigo_projeto) REFERENCES projeto (codigo)
)

INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, telefone, data_nasc, salario) VALUES
('Fulano',  'da Silva', 'R. Volunt�rios da Patria',    8150,   'Santana',  '05423110', '76895248', '15/05/1974',   4350.00),
('Cicrano', 'De Souza', 'R. Anhaia', 353,   'Barra Funda',  '03598770', '99568741', '25/08/1984',   1552.00),
('Beltrano',    'Dos Santos',   'R. ABC', 1100, 'Artur Alvim',  '05448000', '25639854', '02/06/1963',   2250.00)
 
INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Tirano',  'De Souza', 'Avenida �guia de Haia', 4430, 'Artur Alvim',  '05448000', NULL,   NULL,   '15/10/1975',   2804.00)
 
INSERT INTO projeto VALUES
('Implanta��o de Sistemas ','Colocar o sistema no ar'),
('Implanta��o de Sistemas Novos','Colocar o sistema novo no ar'),
('Modifica��o do m�dulo de cadastro','Modificar CRUD'),
('Teste de Sistema de Cadastro',NULL)
 
INSERT INTO funcproj VALUES
(1, 1001, '18/04/2015', '30/04/2015'),
(3, 1001, '18/04/2015', '30/04/2015'),
(1, 1002, '06/05/2015', '10/05/2015'),
(2, 1002, '06/05/2015', '10/05/2015'),
(3, 1003, '11/05/2015', '13/05/2015')

INSERT INTO funcionario VALUES 
('Fulano', 'da Silva Jr.', 'R. Volunt�rios da Patria', 8150, NULL, '05423110', '11','32549874', '09/09/1990', 1235.00),
('Jo�o', 'dos Santos', 'R. Anhaia', 150, NULL,'03425000', '11', '45879852', '19/08/1973', 2352.00),
('Maria', 'dos Santos', 'R. Pedro de Toledo', 18, NULL, '04426000', '11', '32568974', '03/05/1982', 4550.00)

--Exerc�cios
 
--Nomes completos dos Funcion�rios que est�o no
--projeto Modifica��o do M�dulo de Cadastro

SELECT	nome + ' ' + sobrenome AS nome_completo 
FROM	funcionario 
WHERE	id IN
		(SELECT DISTINCT id_funcionario 
			FROM funcproj
			WHERE codigo_projeto =
				(SELECT DISTINCT codigo
				FROM projeto
				WHERE nome = 'Modifica��o do m�dulo de cadastro'))

--Nomes completos e Idade, em anos (considere se fez ou ainda far�
--anivers�rio esse ano), dos funcion�rios

SELECT	nome + ' ' + sobrenome AS nome_completo,
		CASE WHEN (DATEDIFF(MONTH, data_nasc, GETDATE()) < 0) THEN
			DATEDIFF(YEAR, data_nasc, GETDATE()) 
		ELSE CASE WHEN (DATEDIFF(MONTH, data_nasc, GETDATE()) = 0) THEN
			(CASE WHEN (DATEDIFF(DAY, data_nasc, GETDATE()) = 0) THEN
				DATEDIFF(YEAR, data_nasc, GETDATE()) 
			ELSE (CASE WHEN (DATEDIFF(DAY, data_nasc, GETDATE()) > 0) THEN
				DATEDIFF(YEAR, data_nasc, GETDATE())
				ELSE DATEDIFF(YEAR, data_nasc, GETDATE()) -1
				END AS idade)
			END AS idade)
		END AS idade
FROM	funcionario

-- /\ PS EU DESISTO
