/*
Consideramos um torneio de basquete masculino e feminino, 
onde os jogadores devem ser cadastrados por um código único auto incremental, 
onde o primeiro jogador é o número 900101 e incrementa-se de 1 em 1, o nome, o sexo (M ou F),
a altura (que deve ser acima de 1.70m para homens e acima de 1.60 para mulheres),
seu apelido que deve ser único e o código do time em que jogarão (
1 time tem muitos jogadores, porém 1 jogador só pode jogar por 1 time). 
É sabido que a procura pelos times tem sido maior pelos homens.
Por ser um campeonato para adultos, apenas podem se inscrever jogadores com data 
de nascimento superior a 01/01/1993. O time deve ser cadastrado por um id,
também auto incremental, iniciado em 4001, incrementando de 1 em 1, nome, que
deve ser único e sua cidade.
Fazer a estrutura DDL do esquema acima.
*/

create table times(
id int identity(4001,1) not null,
nome varchar(100) not null UNIQUE,
cidade varchar(100)
primary key (id))
go
CREATE TABLE jogador(
codigo int identity(900101,1) not null,
nome varchar(200) not null,
sexo char(1) DEFAULT('M') not null CHECK (sexo = 'M' OR sexo = 'F'),
altura DECIMAL(7,2) not null,
apelido varchar(50) UNIQUE,
dt_nasc datetime not null CHECK (dt_nasc <= '01/01/1993'),
time_jogador int not null
primary key (codigo)
FOREIGN KEY (time_jogador) REFERENCES times(id),
CONSTRAINT chk_sx_alt CHECK ((sexo = 'M' AND altura >= 1.70) OR (sexo = 'F' AND altura >= 1.60)))

exec sp_help jogador
exec sp_help tecnicos


insert into times (nome, cidade) values
('Hawks','São José'),
('Lakers','Pindamonhangaba')

insert into times 
values ('Lakers','Santo André')
insert into jogador (nome, altura, apelido, dt_nasc, time_jogador) 
values ('Fulano', 1.95, 'Fulaninho', '15/05/1990', 4001)
insert into jogador (nome, altura, apelido, dt_nasc, time_jogador) 
values ('Beltrano', 1.65, 'Bert', '12/04/1990', 4001)
insert into jogador (nome, altura, apelido, dt_nasc, time_jogador) 
values ('Beltrano', 1.75, 'Bert', '12/04/1994', 4001)
insert into jogador (nome, altura, sexo, apelido, dt_nasc, time_jogador) 
values ('Cicrana', 1.75, 'P', 'Cix', '12/04/1984', 4001)
insert into jogador (nome, altura, sexo, apelido, dt_nasc, time_jogador) 
values ('Cicrana', 1.55, 'F', 'Cix', '12/04/1984', 4001)
insert into jogador (nome, altura, sexo, apelido, dt_nasc, time_jogador) 
values ('Cicrana', 1.75, 'F', 'Cix', '12/04/1984', 4001)
insert into jogador (nome, altura, sexo, apelido, dt_nasc, time_jogador) 
values ('Malana', 1.78, 'F', 'Mal', '01/10/1989', 4004)
insert into jogador (nome, altura, sexo, apelido, dt_nasc, time_jogador) 
values ('Dalana', 1.75, 'F', 'Dal', '01/10/1989', 4004)

insert into times (nome, cidade) values
('Bulls','Aparecida')

update times set nome = 'SJ Hawks' where nome = 'Hawks'
delete times where id = 4002

--A fita estava errada. Todos são 5 cm maiores
update jogador
set altura = altura + 0.05

update jogador 
set time_jogador = 4001
where codigo = 900109 or codigo = 900110

create table tecnicos(
codigo int identity(601,1) not null,
nome varchar(100) not null,
time_tecnico int not null)

ALTER TABLE tecnicos
ADD PRIMARY KEY (codigo)

ALTER TABLE tecnicos
ADD dt_nasc varchar(10)

ALTER TABLE tecnicos
ADD FOREIGN KEY (time_tecnico) REFERENCES times(id)

ALTER TABLE tecnicos
ALTER COLUMN dt_nasc datetime

ALTER TABLE tecnicos
DROP COLUMN dt_nasc

EXEC sp_rename 'dbo.tecnicos','tecnico'
EXEC sp_rename 'dbo.tecnico.nome','nome_tecnico','column'

select * from times
select * from jogador
select * from tecnico

CREATE TABLE inscricao(
id_time				INT not null,
cod_tecnico			INT not null,
cod_jogador			INT not null UNIQUE,
data_nasc_jogador	DATE CHECK(
)

/*
Consideramos um torneio de basquete masculino e feminino, 
onde os jogadores devem ser cadastrados por um código único auto incremental, 
onde o primeiro jogador é o número 900101 e incrementa-se de 1 em 1, o nome, o sexo (M ou F),
a altura (que deve ser acima de 1.70m para homens e acima de 1.60 para mulheres),
seu apelido que deve ser único e o código do time em que jogarão (
1 time tem muitos jogadores, porém 1 jogador só pode jogar por 1 time). 
É sabido que a procura pelos times tem sido maior pelos homens.
Por ser um campeonato para adultos, apenas podem se inscrever jogadores com data 
de nascimento superior a 01/01/1993. O time deve ser cadastrado por um id,
também auto incremental, iniciado em 4001, incrementando de 1 em 1, nome, que
deve ser único e sua cidade.
Fazer a estrutura DDL do esquema acima.
*/