-- Creating the main database with name "formativa1"
CREATE DATABASE formativa1;

-- Creating the default user named "admin"
CREATE USER admin WITH LOGIN PASSWORD 'admin';

-- Granting all privileges to our user
GRANT ALL PRIVILEGES ON DATABASE formativa1 TO admin;

-- Conecting into database "formativa1" with user "admin"
\c formativa1 admin;

-- Creating table "estado"
CREATE TABLE estado (
	uf VARCHAR(2) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY(uf)
);

-- Creating table "cidade"
CREATE TABLE cidade (
	id_cidade INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	uf  VARCHAR(2) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY(id_cidade),
	FOREIGN KEY (uf)
		REFERENCES estado(uf)
);

-- Creating table "bairro"
CREATE TABLE bairro (
	id_bairro INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_cidade INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_bairro),
	FOREIGN KEY (id_cidade)
		REFERENCES cidade(id_cidade)
);

-- Creating table "usuario"
CREATE TABLE usuario (
	id_usuario INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_bairro INT NOT NULL,
	primeiro_nome VARCHAR(50) NOT NULL,
	segundo_nome VARCHAR(50) NOT NULL,
	sexo VARCHAR(1) NOT NULL DEFAULT 'M',
	data_nascimento TIMESTAMP NOT NULL,
	cpf BIGINT NOT NULL,
	rg BIGINT NOT NULL,
	PRIMARY KEY (id_usuario),
	FOREIGN KEY (id_bairro)
		REFERENCES bairro(id_bairro)
);

-- Creating table "telefone"
CREATE TABLE telefone (
	id_telefone INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_usuario INT NOT NULL,
	tipo VARCHAR(1) NOT NULL DEFAULT 'M',
	numero BIGINT NOT NULL,
	PRIMARY KEY (id_telefone, id_usuario),
	FOREIGN KEY (id_usuario)
		REFERENCES usuario(id_usuario)
);

-- Creating table "paciente"
CREATE TABLE paciente (
	id_usuario INT NOT NULL,
	num_sus BIGINT NOT NULL,
	PRIMARY KEY(id_usuario),
	FOREIGN KEY (id_usuario)
		REFERENCES usuario (id_usuario)
);

-- Creating table "funcionario"
CREATE TABLE funcionario (
	id_usuario INT NOT NULL,
	email VARCHAR(150) NOT NULL,
	senha VARCHAR(150) NOT NULL,
	PRIMARY KEY(id_usuario),
	FOREIGN KEY (id_usuario)
		REFERENCES usuario (id_usuario)
);

-- Creating table "medico"
CREATE TABLE medico (
	id_funcionario INT NOT NULL,
	crm VARCHAR(8) NOT NULL,
	PRIMARY KEY(id_funcionario),
	FOREIGN KEY (id_funcionario)
		REFERENCES funcionario(id_usuario)
);

-- Creating table "enfermeira"
CREATE TABLE enfermeira (
	id_funcionario INT NOT NULL,
	coren VARCHAR(8) NOT NULL,
	PRIMARY KEY(id_funcionario),
	FOREIGN KEY (id_funcionario)
		REFERENCES funcionario(id_usuario)
);

-- Creating table "agendamento"
CREATE TABLE agendamento (
	id_agendamento INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_paciente INT NOT NULL,
	data_hora TIMESTAMP NOT NULL,
	PRIMARY KEY (id_agendamento),
	FOREIGN KEY (id_paciente)
		REFERENCES paciente(id_usuario)
);

-- Creating table "consulta"
CREATE TABLE consulta (
	id_agendamento INT NOT NULL,
	id_medico INT NOT NULL,
	PRIMARY KEY (id_agendamento),
	FOREIGN KEY (id_medico)
		REFERENCES medico(id_funcionario),
	FOREIGN KEY (id_agendamento)
		REFERENCES agendamento(id_agendamento)
);

-- Creating table "receita"
CREATE TABLE receita (
	id_receita INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_consulta INT NOT NULL,
	PRIMARY KEY (id_receita),
	FOREIGN KEY (id_consulta)
		REFERENCES consulta(id_agendamento)
);

-- Creating table "remedio"
CREATE TABLE remedio (
	id_remedio INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	miligrama INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	tarja VARCHAR(50) NOT NULL,
	PRIMARY KEY(id_remedio)
);

-- Creating table "receita_remedio"
CREATE TABLE receita_remedio (
	id_receita INT NOT NULL,
	id_remedio INT NOT NULL,
	orientacao TEXT NOT NULL,
	PRIMARY KEY (id_receita, id_remedio),
	FOREIGN KEY (id_receita)
		REFERENCES receita(id_receita),
	FOREIGN KEY (id_remedio)
		REFERENCES remedio (id_remedio)
);

-- Creating table "estoque"
CREATE TABLE estoque (
	id_remedio INT NOT NULL,
	id_enfermeira INT,
	quantidade INT NOT NULL DEFAULT 0,
	PRIMARY KEY(id_remedio),
	FOREIGN KEY(id_enfermeira)
		REFERENCES enfermeira(id_funcionario),
	FOREIGN KEY(id_remedio)
		REFERENCES remedio(id_remedio)
);
