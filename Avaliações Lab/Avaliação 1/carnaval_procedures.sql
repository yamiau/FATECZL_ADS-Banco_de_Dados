USE MASTER
USE avaliacao1

DROP PROCEDURE sp_validar_jurado
DROP PROCEDURE sp_ja_votou
DROP PROCEDURE sp_ordem_nota
DROP PROCEDURE sp_calcular_media
DROP PROCEDURE sp_inserir_nota


-- Definir procedimentos

CREATE PROCEDURE sp_validar_jurado (@quesito INT, @jurado INT, @validade BIT OUTPUT)
AS
BEGIN
	DECLARE @quesito_valido INT			 

	SET @quesito_valido = (SELECT quesito FROM jurado WHERE id = @jurado)

	IF (@quesito = @quesito_valido)
	BEGIN
		SET @validade = 1
	END
	ELSE
	BEGIN
		SET @validade = 0
	END
	RETURN @validade
END


CREATE PROCEDURE sp_ja_votou (@escola INT, @quesito INT, @jurado INT, @ja_votou BIT OUTPUT)
AS
BEGIN
	DECLARE @notas_dadas INT
			
	SET @notas_dadas = (SELECT COUNT(*) FROM nota WHERE @escola = escola AND @quesito = quesito AND @jurado = jurado)

	IF(@notas_dadas > 0)
	BEGIN
		SET @ja_votou = 1
	END
	ELSE
	BEGIN
		SET @ja_votou = 0
	END
	RETURN @ja_votou
END

CREATE PROCEDURE sp_ordem_nota (@escola INT, @quesito INT, @jurado INT, @ordem INT OUTPUT)
AS
BEGIN
	DECLARE @notas_quesito INT

	SET @notas_quesito = (SELECT COUNT(nota) FROM nota WHERE @escola = escola AND @quesito = quesito)

	IF (@notas_quesito = 0)
	BEGIN
		SET @ordem = 1
	END
	ELSE 
	BEGIN
		SET @ordem = @notas_quesito + 1
	END

	RETURN @ordem
END

CREATE PROCEDURE sp_calcular_media (@escola INT, @quesito INT, @nota DECIMAL(3,1), @ordem INT)
AS
BEGIN
	DECLARE @maior_nota DECIMAL(3,1),
			@menor_nota DECIMAL(3,1),
			@total_notas DECIMAL(3,1),
			@nota_final DECIMAL(3,1)

	SET		@maior_nota = (SELECT MAX(nota) FROM nota WHERE escola = @escola AND quesito = @quesito)
	SET		@menor_nota = (SELECT MIN(nota) FROM nota WHERE escola = @escola AND quesito = @quesito)

	IF (@ordem < 4)
	BEGIN 
		IF (@ordem = 1)
		BEGIN 
			INSERT INTO media_quesito VALUES (@escola, @quesito, @nota, @ordem)
		END
		ELSE
		BEGIN
			SET @total_notas = (SELECT SUM(nota) FROM nota WHERE escola = @escola AND quesito = @quesito)
			SET @nota_final = @total_notas / (@ordem)
			UPDATE media_quesito SET media = @nota_final WHERE escola = @escola AND quesito = @quesito
		END
	END
	ELSE
	BEGIN
		SET @total_notas = (SELECT SUM(nota) FROM nota WHERE escola = @escola AND quesito = @quesito)
		SET @total_notas = @total_notas - (@maior_nota + @menor_nota)
		SET @nota_final = @total_notas / (@ordem - 2)
		UPDATE media_quesito SET media = @nota_final WHERE escola = @escola AND quesito = @quesito
	END
	UPDATE media_quesito SET notas = @ordem WHERE escola = @escola AND quesito = @quesito
END

CREATE PROCEDURE sp_inserir_nota (@escola INT, @quesito INT, @jurado INT, @nota DECIMAL(3,1))
AS
BEGIN
	DECLARE @valido BIT,
			@ja_votou BIT,
			@notas_quesito INT,
			@ordem INT,
			@nota_final DECIMAL(3,1)

	EXEC sp_validar_jurado @quesito, @jurado, @valido OUTPUT
	IF (@valido = 0)
	BEGIN
		RAISERROR('Este jurado não pode avaliar este quesito!', 16, 1)
		RETURN
	END

	EXEC sp_ja_votou @escola, @quesito, @jurado, @ja_votou OUTPUT
	IF (@ja_votou = 1)
	BEGIN
		RAISERROR('Jurado repetido!', 16, 1) 
		RETURN
	END

	EXEC sp_ordem_nota @escola, @quesito, @jurado, @ordem OUTPUT

	INSERT INTO nota VALUES (@escola, @quesito, @jurado, @nota, @ordem)

	EXEC sp_calcular_media @escola, @quesito, @nota, @ordem
END

-- Definir queries necessárias

-- Jurados que não votaram
CREATE PROCEDURE sp_jurados_faltando
AS
BEGIN
	SELECT		j.id,
				j.nome	
	FROM		jurado j
	LEFT JOIN	nota n
	ON			j.id = n.jurado
	WHERE		n.jurado IS NULL
END

-- Quesitos sem nota de uma determinada escola

DROP PROCEDURE sp_quesitos_faltando

CREATE PROCEDURE sp_quesitos_faltando (@escola INT)
AS
BEGIN
	SELECT		q.nome
	FROM		quesito q
	LEFT JOIN	media_quesito m
	ON			q.id = m.quesito  
	WHERE		m.quesito NOT IN
				(SELECT	quesito
				 FROM	media_quesito
				 WHERE	escola = 
				)

END

EXEC sp_quesitos_faltando 1

-- Escolas sem notas em todos os quesitos

CREATE PROCEDURE sp_escolas_faltando
AS
BEGIN
	SELECT		e.id,
				e.nome
	FROM		escola e
	LEFT JOIN	nota n
	ON			e.id = n.escola
	WHERE		n.escola IS NULL
END

