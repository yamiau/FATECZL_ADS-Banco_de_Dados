CREATE DATABASE ex11

USE ex11

CREATE TABLE plano (
codigo		INT IDENTITY(1234, 1111) PRIMARY KEY,
nome		VARCHAR(30) NOT NULL,
telefone	VARCHAR(9) NOT NULL
)

INSERT INTO plano VALUES 
	('Amil', '41599856'),
	('Sul Am�rica', '45698745'),
	('Unimed', '48759836'),
	('Bradesco Sa�de', '47265897'),
	('Interm�dica', '41415269')

CREATE TABLE paciente (
cpf			VARCHAR(12) PRIMARY KEY,
nome		VARCHAR(20) NOT NULL,
rua			VARCHAR(40) NOT NULL,
numero		VARCHAR(5) NOT NULL,
bairro		VARCHAR(20) NOT NULL,
telefone	VARCHAR(9) NOT NULL,
plano		INT NOT NULL,
FOREIGN KEY (plano) REFERENCES plano(codigo)
)

INSERT INTO paciente VALUES
	('859874589-20', 'Maria Paula', 'R. Volunt�rios da P�tria', '589', 'Santana', '98458741', 2345),
	('874521369-00', 'Ana Julia', 'R. XV de Novembro', '657', 'Centro', '69857412', 5678),
	('236598741-00', 'Jo�o Carlos', 'R. Sete de Setembro', '12', 'Rep�blica', '74859632', 1234),
	('632598741-00', 'Jos� Lima', 'R. Anhaia', '768', 'Barra Funda', '96524156', 2345)


CREATE TABLE medico (
codigo			INT IDENTITY(1, 1) PRIMARY KEY,
nome			VARCHAR(20) NOT NULL,
especialidade	VARCHAR(30) NOT NULL,
plano			INT NOT NULL,
FOREIGN KEY (plano) REFERENCES plano(codigo)
)

INSERT INTO medico VALUES
	('Claudio', 'Cl�nico Geral', 1234),
	('Larissa', 'Ortopedista', 2345),
	('Juliana', 'Otorrinolaringologista', 4567),
	('S�rgio', 'Pediatra', 1234),
	('Julio', 'Cl�nico Geral', 4567),
	('Samara', 'Cirurgi�o', 1234)

CREATE TABLE consulta (
medico		INT NOT NULL,
paciente	VARCHAR(12) NOT NULL,
data		DATE NOT NULL,
hora		TIME NOT NULL,
diagnostico	VARCHAR(30) NOT NULL,
CONSTRAINT pk_consulta PRIMARY KEY (medico, paciente, data, hora),
FOREIGN KEY (medico) REFERENCES medico(codigo),
FOREIGN KEY (paciente) REFERENCES paciente(cpf)
)

INSERT INTO consulta VALUES
	(1, '859874589-20', '10-02-2010', '10:30', 'Gripe'),
	(2, '236598741-00', '10-02-2010', '11:00', 'P� Fraturado'),
	(4, '859874589-20', '11-02-2010', '14:00', 'Pneumonia'),
	(1, '236598741-00', '11-02-2010', '15:00', 'Asma'),
	(3, '874521369-00', '11-02-2010', '16:00', 'Sinusite'),
	(5, '632598741-00', '11-02-2010', '17:00', 'Rinite'),
	(4, '236598741-00', '11-02-2010', '18:00', 'Asma'),
	(5, '632598741-00', '12-02-2010', '10:00', 'Rinoplastia')

--Nome e especialidade dos m�dicos da Amil

SELECT	m.nome,
		m.especialidade
FROM	medico m, plano p
WHERE	m.plano = p.codigo AND
		p.nome = 'Amil'

--Nome, Endere�o concatenado, Telefone e Nome do Plano de Sa�de de todos os pacientes

SELECT	pa.nome,
		pa.rua + ', ' + pa.numero + '(' + pa.bairro + ')' AS endere�o,
		pa.telefone,
		pl.nome
FROM	paciente pa, plano pl
WHERE	pa.plano = pl.codigo

--Telefone do Plano de  Sa�de de Ana J�lia

SELECT		pl.telefone
FROM		plano pl
LEFT JOIN	paciente pa
ON			pa.plano = pl.codigo
WHERE		pa.nome LIKE '%Ana Julia%'

--Plano de Sa�de que n�o tem pacientes cadastrados

SELECT		pl.nome
FROM		plano pl
LEFT JOIN	paciente pa
ON			pa.plano = pl.codigo
WHERE		pa.plano IS NULL

--Planos de Sa�de que n�o tem m�dicos cadastrados

SELECT		p.nome
FROM		plano p
LEFT JOIN	medico m
ON			m.plano = p.codigo
WHERE		m.plano IS NULL

--Data da consulta, Hora da consulta, nome do m�dico, nome do paciente e diagn�stico de todas as consultas

SELECT	c.data,
		c.hora,
		m.nome AS medico,
		p.nome AS paciente,
		c.diagnostico
FROM	consulta c, medico m, paciente p
WHERE	c.medico = m.codigo AND
		c.paciente = p.cpf

--Nome do m�dico, data e hora de consulta e diagn�stico de Jos� Lima

SELECT	m.nome AS medico,
		c.data,
		c.hora,
		c.diagnostico
FROM	medico m, consulta c, paciente p
WHERE	m.codigo = c.medico AND
		c.paciente = p.cpf AND
		p.nome = 'Jos� Lima'

--Alterar o nome de Jo�o Carlos para Jo�o Carlos da Silva

UPDATE	paciente
SET		nome = 'Jo�o Carlos da Silva'
WHERE	nome = 'Jo�o Carlos'

--Deletar o plano de Sa�de Unimed

DELETE FROM		plano 
WHERE			nome = 'Unimed'

--Renomear a coluna Rua da tabela Paciente para Logradouro

exec.sp_rename 'paciente.rua', 'logradouro', 'column'

--Inserir uma coluna, na tabela Paciente, de nome idade e inserir os valores (28,39,14 e 33) respectivamente

ALTER TABLE		paciente
ADD				idade INT

UPDATE	paciente 
SET		idade = 28
WHERE	cpf = '859874589-20'

UPDATE	paciente 
SET		idade = 39
WHERE	cpf = '874521369-00'

UPDATE	paciente 
SET		idade = 14
WHERE	cpf = '236598741-00'

UPDATE	paciente 
SET		idade = 33
WHERE	cpf = '632598741-00'


