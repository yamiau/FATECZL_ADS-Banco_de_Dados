USE MASTER 
DROP DATABASE controlecomputdores

CREATE DATABASE controlecomputdores
GO
USE controlecomputdores

CREATE TABLE tipoMaquina (
idTipo			INT				NOT NULL,
tipo			VARCHAR(30)		NOT NULL
PRIMARY KEY (idTipo))

INSERT INTO tipoMaquina VALUES 
(1, 'Desktop'),
(2, 'Notebook'),
(3, 'Tablet')

CREATE TABLE maquina (
idMaquina		INT				NOT NULL,
tipo			INT				NOT NULL,
clockCpu		DECIMAL(7,2)	NOT NULL,
capacidadeHd	INT				NOT NULL,
txRede			VARCHAR(20)		NULL,
memoriaRam		INT				NOT NULL
PRIMARY KEY (idMaquina)
FOREIGN KEY (tipo) REFERENCES tipoMaquina(idTipo))

INSERT INTO maquina VALUES 
(1, 1, 2.8, 500, NULL, 8),
(2, 1, 2, 1000, '10/100', 8),
(3, 1, 1.7, 500, '10/100', 16),
(4, 1, 3.2, 2000, '10/100/1000', 12),
(5, 1, 1.5, 500, NULL, 4),
(6, 2, 2.2, 1000, NULL, 8),
(7, 2, 1.2, 500, '10/100', 4),
(8, 2, 1.7, 500, NULL, 8),
(9, 2, 2.4, 1000, '10/100/1000', 16),
(10, 2, 2.2, 500, NULL, 16),
(11, 2, 2, 1000, NULL, 8),
(12, 3, 1.8, 64, '802.11', 3),
(13, 3, 1.6, 32, '802.11', 2),
(14, 3, 1.8, 128, '802.11', 3)

CREATE TABLE depto (
idDepto			INT				NOT NULL,
depto			VARCHAR(100)	NOT NULL
PRIMARY KEY (idDepto))

INSERT INTO depto VALUES
(11, 'Desenvolvimento'),
(12, 'Manuten��o'),
(13, 'Banco de Dados'),
(14, 'Frontend'),
(15, 'Gr�ficos')

CREATE TABLE usuario (
idUsuario		INT				NOT NULL,
senha			CHAR(8)			NOT NULL	CHECK(LEN(senha)=8),
nome			VARCHAR(100)	NOT NULL,
ramal			INT				NOT NULL,
depto			INT				NOT NULL
PRIMARY KEY	(idUsuario)
FOREIGN KEY (depto) REFERENCES depto (idDepto))

INSERT INTO usuario VALUES
(1001, '123Mudar', 'Pedro Oliveira Barros', 100, 11),
(1002, '123Mudar', 'F�bio Dias Barbosa', 100, 11),
(1003, '123Mudar', 'Kau� Correia Araujo', 100, 11),
(1004, '123Mudar', 'Diego Lima Ferreira', 101, 11),
(1005, '123Mudar', 'Cau� Fernandes Rodrigues', 101, 11),
(1006, '123Mudar', 'Vinicius Alves Rocha', 200, 12),
(1007, '123Mudar', 'Miguel Castro Rocha', 201, 12),
(1008, '123Mudar', 'Kau� Barros Fernandes', 202, 12),
(1009, '123Mudar', 'Thiago Cunha Santos', 300, 13),
(1010, '123Mudar', 'Kai Sousa Cavalcanti', 300, 13),
(1011, '123Mudar', 'Alex Sousa Alves', 301, 13),
(1012, '123Mudar', 'Vitor Martins Correia', 401, 14),
(1013, '123Mudar', 'Vin�cius Gomes Rodrigues', 402, 14),
(1014, '123Mudar', 'Vin�cius Martins Pinto', 403, 14),
(1015, '123Mudar', 'Renan Carvalho Cunha', 403, 14)


CREATE TABLE software (
idSoftware		INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
tamanhoHd		DECIMAL(7,2)	NOT NULL,
usoRam			DECIMAL(7,2)	NULL
PRIMARY KEY (idSoftware))

INSERT INTO software VALUES
(1, 'Google Chrome', 2, 1.5),
(2, 'Microsoft Teams', 1.5, 1.7),
(3, 'Mozilla Firefox', 1, 0.4),
(4, '7zip', 0.4, NULL),
(5, 'Java JDK 8', 1.2, NULL),
(6, 'Eclipse', 1, 0.32),
(7, 'Python', 0.7, NULL),
(8, 'VSCode', 1, NULL),
(9, 'Adobe Photoshop', 5, 1),
(10, 'SQL Server', 10, 0.5),
(11, 'Management Studio', 1, 0.2)

CREATE TABLE horario (
idHorario		INT				NOT NULL,
horario			VARCHAR(15)		NOT NULL
PRIMARY KEY	(idHorario))

INSERT INTO horario VALUES
(1, 'Manh�'),
(2, 'Tarde'),
(3, 'Noite')

CREATE TABLE usuarioMaquina (
idUsuario		INT				NOT NULL,
idMaquina		INT				NOT NULL,
horario			INT				NOT NULL
PRIMARY KEY (idUsuario, idMaquina)
FOREIGN KEY (idUsuario) REFERENCES usuario (idUsuario),
FOREIGN KEY (idMaquina) REFERENCES maquina (idMaquina),
FOREIGN KEY (horario) REFERENCES horario(idHorario))

INSERT INTO usuarioMaquina VALUES
(1001, 1, 1),
(1002, 1, 2),
(1003, 2, 1),
(1004, 3, 2),
(1005, 4, 1),
(1006, 5, 1),
(1007, 5, 2),
(1008, 6, 1),
(1009, 7, 1),
(1010, 7, 2),
(1011, 8, 1),
(1012, 8, 2),
(1012, 12, 2),
(1013, 10, 1),
(1013, 14, 2),
(1014, 11, 1),
(1015, 11, 2),
(1015, 14, 1)

CREATE TABLE softwareMaquina (
idSoftware		INT				NOT NULL,
idMaquina		INT				NOT NULL
PRIMARY KEY (idSoftware, idMaquina)
FOREIGN KEY (idSoftware) REFERENCES software (idSoftware),
FOREIGN KEY (idMaquina) REFERENCES maquina (idMaquina))

INSERT INTO softwareMaquina VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(1, 3),
(2, 3),
(3, 3),
(4, 3),
(5, 3),
(6, 3),
(7, 3),
(8, 3),
(1, 4),
(2, 4),
(3, 4),
(4, 4),
(5, 4),
(6, 4),
(7, 4),
(8, 4),
(1, 5),
(2, 5),
(3, 5),
(4, 5),
(5, 5),
(6, 5),
(7, 5),
(8, 5),
(1, 6),
(2, 6),
(3, 6),
(4, 6),
(5, 6),
(6, 6),
(7, 6),
(8, 6),
(1, 7),
(2, 7),
(9, 7),
(10, 7),
(1, 8),
(2, 8),
(9, 8),
(10, 8),
(1, 9),
(2, 9),
(3, 9),
(5, 9),
(6, 9),
(1, 10),
(2, 10),
(3, 10),
(5, 10),
(6, 10),
(1, 11),
(2, 11),
(3, 11),
(5, 11),
(6, 11),
(1, 13),
(2, 13),
(1, 14),
(2, 14)


--1) A Quantidade de maquinas que est�o sem nenhum usu�rio alocado em uma coluna chamada qtdNaoAlocada

SELECT		COUNT(m.idMaquina) AS qtdNaoAlocada
FROM		maquina m
LEFT JOIN	usuarioMaquina um
ON			um.idMaquina = m.idMaquina
WHERE		um.idMaquina IS NULL


--2) Nome do software (nomeSoftware), usoRam do software, contagem de m�quinas em que est� instalado em uma coluna qtdInstalacoes. Caso o usoRam seja NULL, mostrar -1

SELECT		s.nome AS nomeSoftware,
			CASE WHEN (s.usoRam IS NULL) 
			THEN -1
			ELSE s.usoRam 
			END AS usoRam,
			COUNT(sm.idMaquina) AS qtdInstalacoes
FROM		software s, softwareMaquina sm
WHERE		s.idSoftware = sm.idSoftware
GROUP BY	s.nome, s.usoRam


--3) Nome de usu�rio (nomeUsuario), nome do Depto (nomeDepto), capacidadeHd dos usu�rios de tablet no per�odo da tarde. Usar os termos tablet e tarde para filtrar a busca.

SELECT		u.nome AS nomeUsuario,
			d.depto AS nomeDepto,
			m.capacidadeHd
FROM		usuario u, depto d, maquina m, usuarioMaquina um, tipoMaquina tm, horario h
WHERE		u.idUsuario = um.idUsuario AND
			m.idMaquina = um.idMaquina AND
			um.horario = h.idHorario AND
			h.horario LIKE '%Tarde%' AND
			m.tipo = tm.idTipo AND
			tm.tipo LIKE 'Tablet'


--4) A quantidade de m�quinas com o software que tem o maior usoRam em uma coluna de nome qtdMaxUsoRam

SELECT
DISTINCT	COUNT(sm.idMaquina) AS qtdMaxUsoRam
FROM		softwareMaquina sm, software s
WHERE		sm.idSoftware = s.idSoftware AND
			s.usoRam IN (
			SELECT	MAX(s.usoRam)
			FROM	software s)