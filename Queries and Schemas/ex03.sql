CREATE DATABASE ex03

--Fazer:						
--Amarelo como Chave Prim�ria						
--Vermelho como chave estrangeira						

CREATE TABLE paciente (
cpf		CHAR(11) PRIMARY KEY,
nome	VARCHAR(20) NOT NULL,
rua		VARCHAR(20) NOT NULL, 
numero	CHAR(5) NOT NULL,
bairro	VARCHAR(20) NOT NULL, 
fone	VARCHAR(9),
idade	INT NOT NULL
)

INSERT INTO paciente VALUES
	('35454562890', 'Jos� Rubens', 'Campos Salles', '2750', 'Centro', '21450998', 56),
	('29865439810', 'Ana Claudia', 'Sete de Setembro', '178', 'Centro', '97382764', 12),
	('82176534800', 'Marcos Aur�lio', 'Tim�teo Penteado', '236', 'Vila Galv�o', '68172651', 26),
	('12386758770', 'Maria Rita', 'Castello Branco', '7765', 'Vila Ros�lia', NULL, 19),
	('92173458910', 'Joana de Souza', 'XV de Novembro', '298', 'Centro', '21276578', 70)

CREATE TABLE medico (
codigo			INT IDENTITY(1,1) PRIMARY KEY,
nome			VARCHAR(20) NOT NULL,
especialidade	VARCHAR(20) NOT NULL
)

INSERT INTO medico VALUES 
	('Wilson Cesar', 'Pediatra'), 
	('Marcia Matos', 'Geriatra'), 
	('Carolina Oliveira', 'Ortopedista'), 
	('Vinicius Araujo', 'Cl�nico Geral')

CREATE TABLE prontuario (
data			CHAR(6) NOT NULL,
cpf_paciente	CHAR(11) NOT NULL,
codigo_medico	INT NOT NULL,
diagnostico		VARCHAR(30) NOT NULL,
medicamento		VARCHAR(20) NOT NULL,
PRIMARY KEY (data, cpf_paciente, codigo_medico),
FOREIGN KEY (cpf_paciente) REFERENCES paciente(cpf),
FOREIGN KEY (codigo_medico) REFERENCES medico(codigo)
)

INSERT INTO prontuario VALUES
	('10/set', '35454562890', 2, 'Reumatismo', 'Celebra'),
	('10/set', '92173458910', 2, 'Rinite Al�rgica', 'Allegra'),
	('12/set', '29865439810', 1, 'Inflama��o de garganta', 'Nimesulida'),
	('13/set', '35454562890', 2, 'H1N1', 'Tamiflu'),
	('15/set', '82176534800', 4, 'Gripe', 'Resprin'),
	('19/set', '12386758770', 3, 'Bra�o Quebrado', 'Dorflex + Gesso')


--Consultar:						
--Nome e Endere�o (concatenado) dos pacientes com mais de 50 anos	

SELECT	nome + ' - Rua ' + rua + + ', ' + numero + ', ' + bairro 
FROM	paciente
WHERE	idade > 50

--Qual a especialidade de Carolina Oliveira						

SELECT	especialidade
FROM	medico
WHERE	nome = 'Carolina Oliveira'

--Qual medicamento receitado para reumatismo						

SELECT	medicamento 
FROM	prontuario 
WHERE	diagnostico LIKE '%reumatismo%'
						
--Consultar em 2 fases:						
--Diagn�stico e Medicamento do paciente Jos� Rubens em suas consultas

SELECT	diagnostico, medicamento
FROM	prontuario 
WHERE	cpf_paciente IN
	(SELECT	cpf 
	 FROM	paciente
	 WHERE	nome = 'Jos� Rubens')
						
--Alterar o telefone da paciente Maria Rita, para 98345621						

UPDATE	paciente
SET		fone = '98345621'
WHERE	nome = 'Maria Rita'

SELECT	fone 
FROM	paciente 
WHERE	nome = 'Maria Rita' 

--Alterar a idade de todos os paciente, tornando-os 1 ano mais velhos

UPDATE	paciente
SET		idade = idade +1

SELECT	idade 
FROM	paciente 

--Alterar o Endere�o de Joana de Souza para Volunt�rios da P�tria, 1980, Jd. Aeroporto						

SELECT	nome + ' - Rua ' + rua + + ', ' + numero + ', ' + bairro 
FROM	paciente
WHERE	nome = 'Joana de Souza'	

ALTER TABLE	paciente
ALTER COLUMN rua VARCHAR(40)

UPDATE	paciente
SET		rua = 'Volunt�rios da P�tria',
		numero = '1980' ,
		bairro = 'Jd. Aeroporto'
WHERE	nome = 'Joana de Souza'

SELECT	nome + ' - Rua ' + rua + + ', ' + numero + ', ' + bairro 
FROM	paciente
WHERE	nome = 'Joana de Souza'

