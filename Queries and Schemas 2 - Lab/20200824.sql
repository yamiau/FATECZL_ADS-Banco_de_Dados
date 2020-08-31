-- Fazer um algoritmo que, dado 1 n�mero, mostre se � m�ltiplo de 2,3,5 ou nenhum deles

DECLARE @num INT, @rem2 INT, @rem3 INT, @rem5 INT
DECLARE @res2 VARCHAR(30), @res3 VARCHAR(30), @res5 VARCHAR(30)
SET @num = 20

SET @rem2 = @num % 2
SET @rem3 = @num % 3
SET @rem5 = @num % 5

SET @res2 = CASE WHEN (@rem2 = 0)
	THEN '� m�ltiplo de 2!'
	ELSE 'N�o � m�ltiplo de 2!'
	END

SET @res3 = CASE WHEN (@rem3 = 0)
	THEN '� m�ltiplo de 3!'
	ELSE 'N�o � m�ltiplo de 3!'
	END

SET @res5 = CASE WHEN (@rem5 = 0)
	THEN '� m�ltiplo de 5!'
	ELSE 'N�o � m�ltiplo de 5!'
	END

PRINT 'O n�mero ' + CONVERT(VARCHAR, @num) + ':'
PRINT @res2
PRINT @res3
PRINT @res5



-- Fazer um algoritmo que, dados 3 n�meros, mostre o maior e o menor

DECLARE @n1 INT, @n2 INT, @n3 INT, @min INT, @max INT
SET @n1 = 11
SET @n2 = 10
SET @n3 = 8

SET @min = CASE 
	WHEN (@n2 < @n1 OR @n3 < @n1) THEN 
		CASE 
			WHEN(@n2 < @n3) THEN
				@n2 
			ELSE
				@n3 
		END
	ELSE 
		@n1
	END

SET @max = CASE 
	WHEN (@n2 > @n1 OR @n3 > @n1) THEN 
		CASE 
			WHEN(@n2 > @n3) THEN
				@n2 
			ELSE
				@n3 
		END
	ELSE 
		@n1
	END

PRINT 'Smallest: ' + CONVERT(CHAR, @min)
PRINT 'Greatest: '+ CONVERT(CHAR, @max)

--Fazer um algoritmo que calcule os 15 primeiros termos da s�rie de Fibonacci e a soma dos 15 primeiros termos

DECLARE @f1 INT, @f2 INT, @counter INT, @sum INT
SET @f1 = 0
SET @f2 = 1
SET @counter = 1
SET @sum = 0

PRINT '15 primeiros termos da S�rie Fibonacci :' 

WHILE (@counter <= 15)
BEGIN
	SET @sum += @f2
	PRINT @f2

	DECLARE @dummy INT = @f2
	SET @f2 += @f1 
	SET @f1 = @dummy

	SET @counter += 1
END

PRINT 'Soma dos 15 primeiros termos da S�rie Fibonacci: ' 
PRINT @sum


-- Fazer um algoritmo que separa uma frase, imprimindo todas as letras em mai�sculo e, depois imprimindo todas em min�sculo

DECLARE @sentence VARCHAR(30), @char INT
SET @sentence = 'It''s me, Dio!'
SET @char = 1

WHILE ( @char <= LEN(@sentence) )
BEGIN 
	PRINT UPPER(SUBSTRING(@sentence, @char, 1))
	SET @char += 1
END
	
SET @char = 1

WHILE ( @char <= LEN(@sentence) )
BEGIN 
	PRINT LOWER(SUBSTRING(@sentence, @char, 1))
	SET @char += 1
END



-- Fazer um algoritmo que verifica, dada uma palavra, se �, ou n�o, pal�ndromo

DECLARE @word VARCHAR(20), @dummy VARCHAR(20), @counter INT, @result VARCHAR(50)
SET @word = 'arara'
SET @dummy = ''
SET @counter = LEN(@word)

WHILE ( @counter > 0 )
BEGIN
	SET @dummy += SUBSTRING(@word, @counter, 1)
	SET @counter -= 1
END

SET @result = CASE 
	WHEN (@word = @dummy)
	THEN 'A palavra ' + @word + ' � um pal�ndromo!'
	ELSE 'A palavra ' + @word + ' n�o � um pal�ndromo!'
	END

PRINT @result



--Fazer um algoritmo que, dado um CPF diga se � v�lido

DECLARE @cpf CHAR(11), @sum INT, @counter INT
SET @cpf = '00393970841' 
SET @counter = 1
SET @sum = 0

WHILE ( @counter <= LEN(@cpf) )
BEGIN
	SET @sum += CONVERT(INT, SUBSTRING(@cpf, @counter, 1))
	SET @counter += 1
END

PRINT	'A soma dos d�gitos do cpf ' + 
		SUBSTRING(@cpf, 1, 3) + '.' + 
		SUBSTRING(@cpf, 3, 3) + '.' + 
		SUBSTRING(@cpf, 6, 3) + '/' +
		SUBSTRING(@cpf, 9, 2) + ' � ' + CONVERT(CHAR, @sum)

DECLARE @result VARCHAR(15) = CASE 
	WHEN ((@sum % 11) = 0 ) 
	THEN 'CPF v�lido!' 
	ELSE 'CPF inv�lido!'
END

PRINT @result
