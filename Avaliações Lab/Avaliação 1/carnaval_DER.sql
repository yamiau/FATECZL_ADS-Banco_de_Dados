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
	('Acadêmicos do Tatuapé', NULL),
	('Rosas de Ouro', NULL),
	('Mancha Verde', NULL),
	('Vai-Vai', NULL),
	('X-9 Paulistana', NULL),
	('Dragões da Real', NULL),
	('Águia de Ouro', NULL),
	('Nenê de Vila Matilde', NULL),
	('Gaviões da Fiel', NULL),
	('Mocidade Alegre', NULL),
	('Tom Maior', NULL),
	('Unidos de Vila Maria', NULL),
	('Acadêmicos do Tucuruvi', NULL),
	('Império de Casa Verde', NULL)

INSERT INTO quesito VALUES
	('Comissão de Frente'),
	('Evolução'),
	('Fantasia'),
	('Bateria'),
	('Alegoria'),
	('Harmonia'),
	('Samba-Enredo'),
	('Mestre-Sala e Porta-Bandeira'),
	('Enredo')

INSERT INTO jurado VALUES 
	('Gleice Ribeiro', 1), 
	('Paulo César Morato', 1), 
	('Rafaela Riveiro Ribeiro', 1), 
	('Raffael Araujo', 1), 
	('Raphael David', 1), 
	('Gerson Martins', 2), 
	('Gustavo Paso', 2), 
	('Lucila de Beaurepaire', 2), 
	('Mateus Dutra', 2), 
	('Verônica Torres', 2), 
	('Helenice Gomes', 3), 
	('Paulo Paradela', 3), 
	('Regina Oliva', 3), 
	('Sérgio Henrique da Silva', 3), 
	('Wagner Louza', 3), 
	('Ary Jayme Cohen', 4), 
	('Cláudio Luiz Matheus', 4), 
	('Leandro Luís Oliveira', 4), 
	('Philipe Galdino', 4), 
	('Rafael Barros Castro', 4), 
	('Fernando Lima', 5), 
	('Madson Oliveira', 5), 
	('Soter Bentes', 5), 
	('Teresa Piva', 5), 
	('Walber Ângelo de Freitas', 5), 
	('Bruno Marques', 6), 
	('Célia Souto', 6), 
	('Deborah Levy', 6), 
	('Jardel Maia Rodrigues', 6), 
	('Miriam Orofino Gomes', 6), 
	('Alfredo Del-Penho', 7), 
	('Alice Serrano', 7), 
	('Clayton Fábio Oliveira', 7), 
	('Eri Galvão', 7), 
	('Felipe Trotta', 7), 
	('Áurea Hämmerli', 8), 
	('Beatriz Badejo', 8), 
	('João Wlamir', 8), 
	('Mônica Barbosa', 8), 
	('Paulo Rodrigues', 8), 
	('Artur Nunes Gomes', 9), 
	('Johnny Soares', 9), 
	('Marcelo Antonio Masô', 9), 
	('Marcelo Figueira', 9), 
	('Pérsio Gomyde Brasil', 9)

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

