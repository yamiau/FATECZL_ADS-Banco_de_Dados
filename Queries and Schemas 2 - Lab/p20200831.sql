CREATE DATABASE p20200831
USE p20200831

-- 1) Criar um database, fazer uma tabela cadastro (cpf, nome, rua, numero e cep) 
-- com uma procedure que só permitirá a inserção dos dados se o CPF for válido, caso contrário retornar uma mensagem de erro

CREATE TABLE cadastro(
cpf		CHAR(11) PRIMARY KEY,
nome	VARCHAR(100) NOT NULL,
rua		VARCHAR(100) NOT NULL,
numero	VARCHAR(5) NOT NULL,
cep		CHAR(8)
)

CREATE PROCEDURE sp_cadastrar(@cpf CHAR(11), @nome VARCHAR(100), @rua VARCHAR(100), @numero VARCHAR(5), @cep CHAR(8))

AS

	DECLARE @sum INT, @counter INT
	SET @counter = 1
	SET @sum = 0

	WHILE ( @counter <= LEN(@cpf) )
	BEGIN
		SET @sum += CONVERT(INT, SUBSTRING(@cpf, @counter, 1))
		SET @counter += 1
	END

	DECLARE @result INT = CASE 
		WHEN ((@sum % 11) = 0 ) 
		THEN 1
		ELSE 0
	END

	IF (@result = 1)
	BEGIN
		INSERT INTO cadastro VALUES(@cpf, @nome, @rua, @numero, @cep)
	END
	ELSE
	BEGIN
		PRINT 'CPF inválido não pôde ser cadastrado!'
	END

EXEC sp_cadastrar '35393129432', 'Mario Silva', 'Av. Paranaguá', '120', ''
EXEC sp_cadastrar '35393129430', 'Elisa Paiva', 'Rua Solária', '47', '08062131'

SELECT * FROM cadastro


-- 2) Criar uma nova database e resolver o exercicio Aula_03a_-_Exercicio_Stored_Procedures.txt do site do professor.

CREATE TABLE aluno(
codigoAluno	INT PRIMARY KEY,
nome		VARCHAR(100) NOT NULL
)

CREATE TABLE atividade(
codigo		INT PRIMARY KEY,
descricao	VARCHAR(MAX) NOT NULL,
imc			DECIMAL(3,1) NOT NULL
)

INSERT INTO atividade VALUES
	(1, 'Corrida + Step', 18.5),
	(2, 'Biceps + Costas + Pernas', 24.9),
	(3, 'Esteira + Biceps + Costas + Pernas', 29.9),
	(4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
	(5, 'Esteira + Bicicleta', 39.9)

CREATE TABLE aluno_atividade(
codigoAluno	INT NOT NULL,
altura		DECIMAL(3,2) NOT NULL,
peso		DECIMAL(5,2) NOT NULL,
imc			DECIMAL(3,1) NOT NULL,
atividade	INT NOT NULL,

PRIMARY KEY (codigoAluno, atividade),
FOREIGN KEY(codigoAluno) REFERENCES aluno(codigoAluno), 
FOREIGN KEY(atividade) REFERENCES atividade(codigo), 
)

CREATE PROCEDURE sp_alunoatividade(@codigoAluno INT, @nome VARCHAR(100), @altura(DECIMAL(3,2), @peso DECIMAL(5,2))

AS	
	DECLARE @imc INT = ( @peso / POWER(@altura, 2) ),
			@query VARCHAR(MAX),
			@atividade INT
