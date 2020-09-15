USE MASTER	
DROP DATABASE p20200914

CREATE DATABASE p20200914
USE p20200914

CREATE TABLE produto(
idProduto INT NOT NULL,
nome VARCHAR(100),
valor DECIMAL(7,2),
tipo CHAR(1) DEFAULT('e')
PRIMARY KEY (idProduto))

CREATE TABLE compra(
codigo INT IDENTITY(1,1),
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)

PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))

CREATE TABLE venda(
codigo INT IDENTITY(1,1),
produto INT NOT NULL,
qtd INT NOT NULL,
vl_total DECIMAL(7,2)

PRIMARY KEY (codigo, produto)
FOREIGN KEY (produto) REFERENCES produto (idProduto))


-- Inserir produto e transação 

DROP PROCEDURE sp_insere
CREATE PROCEDURE sp_insere(@idProduto INT, @nome VARCHAR(100), @valor DECIMAL(7,2), @tipo CHAR(1), @qtd INT)

AS
	BEGIN TRY
	INSERT INTO produto VALUES(@idProduto, @nome, @valor, @tipo)
	END TRY

	BEGIN CATCH
	PRINT 'Erro ao inserir o produto!'
	END CATCH

	DECLARE @tabela VARCHAR(10),
			@query	VARCHAR(MAX)

	IF (LOWER(@tipo) = 'e')
	BEGIN 
		SET @tabela = 'compra'
	END
	ELSE
	BEGIN
		IF (LOWER(@tipo) = 's')
		BEGIN
			SET @tabela = 'venda'
		END
	END

	SET @query = 'INSERT INTO ' + @tabela + ' VALUES(' +
												CAST(@idProduto AS VARCHAR(MAX)) + ', ''' +
												CAST(@qtd AS VARCHAR(MAX)) + ''', ''' + 
												CAST( (@qtd * @valor) AS VARCHAR(MAX) ) + ''')'
		EXEC (@query)
		

EXEC sp_insere 001, 'Colher', 0.5, 'e', 20
EXEC sp_insere 002, 'Garfo', 0.6, 'e', 20
EXEC sp_insere 003, 'Faca', 0.7, 'e', 30
EXEC sp_insere 010, 'Copo', 2.3, 's', 102
EXEC sp_insere 011, 'Prato', 5.2, 's', 39

SELECT * FROM produto 
SELECT * FROM compra
SELECT * FROM venda
