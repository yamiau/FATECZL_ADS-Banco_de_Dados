CREATE DATABASE ex11

USE ex11

CREATE TABLE plano (
codigo		INT IDENTITY(1234, 1111) PRIMARY KEY,
nome		VARCHAR(30) NOT NULL,
telefone	VARCHAR(9) NOT NULL
)

INSERT INTO plano VALUES 
	('Amil', '41599856'),
	('Sul América', '45698745'),
	('Unimed', '48759836'),
	('Bradesco Saúde', '47265897'),
	('Intermédica', '41415269')

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
	('859874589-20', 'Maria Paula', 'R. Voluntários da Pátria', '589', 'Santana', '98458741', 2345),
	('874521369-00', 'Ana Julia', 'R. XV de Novembro', '657', 'Centro', '69857412', 5678),
	('236598741-00', 'João Carlos', 'R. Sete de Setembro', '12', 'República', '74859632', 1234),
	('632598741-00', 'José Lima', 'R. Anhaia', '768', 'Barra Funda', '96524156', 2345)


CREATE TABLE medico (
codigo			INT IDENTITY(1, 1) PRIMARY KEY,
nome			VARCHAR(20) NOT NULL,
especialidade	VARCHAR(30) NOT NULL,
plano			INT NOT NULL,
FOREIGN KEY (plano) REFERENCES plano(codigo)
)

INSERT INTO medico VALUES
	('Claudio', 'Clínico Geral', 1234),
	('Larissa', 'Ortopedista', 2345),
	('Juliana', 'Otorrinolaringologista', 4567),
	('Sérgio', 'Pediatra', 1234),
	('Julio', 'Clínico Geral', 4567),
	('Samara', 'Cirurgião', 1234)

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
	(2, '236598741-00', '10-02-2010', '11:00', 'Pé Fraturado'),
	(4, '859874589-20', '11-02-2010', '14:00', 'Pneumonia'),
	(1, '236598741-00', '11-02-2010', '15:00', 'Asma'),
	(3, '874521369-00', '11-02-2010', '16:00', 'Sinusite'),
	(5, '632598741-00', '11-02-2010', '17:00', 'Rinite'),
	(4, '236598741-00', '11-02-2010', '18:00', 'Asma'),
	(5, '632598741-00', '12-02-2010', '10:00', 'Rinoplastia')

--Nome e especialidade dos médicos da Amil

SELECT	m.nome,
		m.especialidade
FROM	medico m, plano p
WHERE	m.plano = p.codigo AND
		p.nome = 'Amil'

--Nome, Endereço concatenado, Telefone e Nome do Plano de Saúde de todos os pacientes

SELECT	pa.nome,
		pa.rua + ', ' + pa.numero + '(' + pa.bairro + ')' AS endereço,
		pa.telefone,
		pl.nome
FROM	paciente pa, plano pl
WHERE	pa.plano = pl.codigo

--Telefone do Plano de  Saúde de Ana Júlia

SELECT		pl.telefone
FROM		plano pl
LEFT JOIN	paciente pa
ON			pa.plano = pl.codigo
WHERE		pa.nome LIKE '%Ana Julia%'

--Plano de Saúde que não tem pacientes cadastrados

SELECT		pl.nome
FROM		plano pl
LEFT JOIN	paciente pa
ON			pa.plano = pl.codigo
WHERE		pa.plano IS NULL

--Planos de Saúde que não tem médicos cadastrados

SELECT		p.nome
FROM		plano p
LEFT JOIN	medico m
ON			m.plano = p.codigo
WHERE		m.plano IS NULL

--Data da consulta, Hora da consulta, nome do médico, nome do paciente e diagnóstico de todas as consultas

SELECT	c.data,
		c.hora,
		m.nome AS medico,
		p.nome AS paciente,
		c.diagnostico
FROM	consulta c, medico m, paciente p
WHERE	c.medico = m.codigo AND
		c.paciente = p.cpf

--Nome do médico, data e hora de consulta e diagnóstico de José Lima

SELECT	m.nome AS medico,
		c.data,
		c.hora,
		c.diagnostico
FROM	medico m, consulta c, paciente p
WHERE	m.codigo = c.medico AND
		c.paciente = p.cpf AND
		p.nome = 'José Lima'

--Alterar o nome de João Carlos para João Carlos da Silva

UPDATE	paciente
SET		nome = 'João Carlos da Silva'
WHERE	nome = 'João Carlos'

--Deletar o plano de Saúde Unimed

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


