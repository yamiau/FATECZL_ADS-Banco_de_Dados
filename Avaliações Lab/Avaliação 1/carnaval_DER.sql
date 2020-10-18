USE MASTER 
DROP DATABASE avaliacao1
DROP TABLE escola
DROP TABLE quesito
DROP TABLE jurado
DROP TABLE nota
DROP TABLE media_quesito

CREATE DATABASE avaliacao1

USE avaliacao1

--Definir tabelas

CREATE TABLE escola(
id		INT IDENTITY(1,1) PRIMARY KEY,
nome	VARCHAR(50) NOT NULL,
pontos	DECIMAL(3,1) DEFAULT 00.0
)

CREATE TABLE quesito(
id		INT IDENTITY(1,1) PRIMARY KEY,
nome	VARCHAR(30)
)

CREATE TABLE jurado(
id		INT IDENTITY(1,1) PRIMARY KEY,
nome	VARCHAR(50) NOT NULL,
quesito	INT NOT NULL,
FOREIGN KEY (quesito) REFERENCES quesito (id)
)

CREATE TABLE nota(
escola	INT NOT NULL,
quesito	INT NOT NULL,
jurado	INT NOT NULL,
nota	DECIMAL(3,1),
ordem	INT NOT NULL,
FOREIGN KEY (escola) REFERENCES escola (id),
FOREIGN KEY (jurado) REFERENCES jurado (id),
FOREIGN KEY (quesito) REFERENCES quesito (id),
PRIMARY KEY (escola, jurado, quesito)
)

CREATE table media_quesito(
escola	INT NOT NULL, 
quesito	INT NOT NULL,
media	DECIMAL(3,1) NOT NULL,
notas	INT NOT NULL,
FOREIGN KEY (escola) REFERENCES escola (id),
FOREIGN KEY (quesito) REFERENCES quesito (id),
PRIMARY KEY (escola, quesito)
)


--Inserir registros

INSERT INTO escola VALUES
	('Acad�micos do Tatuap�', NULL),
	('Rosas de Ouro', NULL),
	('Mancha Verde', NULL),
	('Vai-Vai', NULL),
	('X-9 Paulistana', NULL),
	('Drag�es da Real', NULL),
	('�guia de Ouro', NULL),
	('Nen� de Vila Matilde', NULL),
	('Gavi�es da Fiel', NULL),
	('Mocidade Alegre', NULL),
	('Tom Maior', NULL),
	('Unidos de Vila Maria', NULL),
	('Acad�micos do Tucuruvi', NULL),
	('Imp�rio de Casa Verde', NULL)

INSERT INTO quesito VALUES
	('Comiss�o de Frente'),
	('Evolu��o'),
	('Fantasia'),
	('Bateria'),
	('Alegoria'),
	('Harmonia'),
	('Samba-Enredo'),
	('Mestre-Sala e Porta-Bandeira'),
	('Enredo')

INSERT INTO jurado VALUES 
	('Gleice Ribeiro', 1), 
	('Paulo C�sar Morato', 1), 
	('Rafaela Riveiro Ribeiro', 1), 
	('Raffael Araujo', 1), 
	('Raphael David', 1), 
	('Gerson Martins', 2), 
	('Gustavo Paso', 2), 
	('Lucila de Beaurepaire', 2), 
	('Mateus Dutra', 2), 
	('Ver�nica Torres', 2), 
	('Helenice Gomes', 3), 
	('Paulo Paradela', 3), 
	('Regina Oliva', 3), 
	('S�rgio Henrique da Silva', 3), 
	('Wagner Louza', 3), 
	('Ary Jayme Cohen', 4), 
	('Cl�udio Luiz Matheus', 4), 
	('Leandro Lu�s Oliveira', 4), 
	('Philipe Galdino', 4), 
	('Rafael Barros Castro', 4), 
	('Fernando Lima', 5), 
	('Madson Oliveira', 5), 
	('Soter Bentes', 5), 
	('Teresa Piva', 5), 
	('Walber �ngelo de Freitas', 5), 
	('Bruno Marques', 6), 
	('C�lia Souto', 6), 
	('Deborah Levy', 6), 
	('Jardel Maia Rodrigues', 6), 
	('Miriam Orofino Gomes', 6), 
	('Alfredo Del-Penho', 7), 
	('Alice Serrano', 7), 
	('Clayton F�bio Oliveira', 7), 
	('Eri Galv�o', 7), 
	('Felipe Trotta', 7), 
	('�urea H�mmerli', 8), 
	('Beatriz Badejo', 8), 
	('Jo�o Wlamir', 8), 
	('M�nica Barbosa', 8), 
	('Paulo Rodrigues', 8), 
	('Artur Nunes Gomes', 9), 
	('Johnny Soares', 9), 
	('Marcelo Antonio Mas�', 9), 
	('Marcelo Figueira', 9), 
	('P�rsio Gomyde Brasil', 9)

-- Teste de notas

EXEC sp_inserir_nota 1, 1, 1, 9
EXEC sp_inserir_nota 1, 1, 2, 8
EXEC sp_inserir_nota 1, 1, 3, 8
EXEC sp_inserir_nota 1, 1, 4, 8
EXEC sp_inserir_nota 1, 1, 5, 6
EXEC sp_inserir_nota 1, 2, 6, 10
EXEC sp_inserir_nota 2, 1, 1, 9


SELECT * FROM nota
SELECT * FROM media_quesito
SELECT MAX(nota) AS maior FROM nota 
SELECT MIN(nota) AS menor FROM nota

