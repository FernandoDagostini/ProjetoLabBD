-- Conecting into database "formativa1" with user "admin"
\c formativa1 admin;

-- Inserting information in table "estado"
INSERT INTO estado (uf, nome) VALUES
    ('PR', 'Paraná');

-- Inserting information in table "cidade"
INSERT INTO cidade (uf, nome) VALUES
    ('PR', 'Arapongas');

-- Inserting information in table "bairro"
INSERT INTO bairro (id_cidade, nome) VALUES
    (1, 'Vila Araponguinha'),
    (1, 'Palmares'),
    (1, 'Jd. Baroneza');

-- Inserting information in table "usuario"
INSERT INTO usuario (id_bairro, primeiro_nome, segundo_nome, sexo, data_nascimento, cpf, rg) VALUES 
	(1, 'Pedro', 'Aloisio', 'M', '1970-06-07 12:12:12', 18912552121, 123456789), 
	(1, 'João', 'Amoedo', 'M', '1962-01-18 12:12:12', 28311132121, 224456789), 
	(3, 'Ana', 'Clara', 'F', '1990-06-09 12:12:12', 32911122123, 166451789), 
	(3, 'Murilo', 'Chianfa', 'M', '2002-03-10 12:12:12', 28922552122, 233456119), 
	(3, 'Henrique', 'Basana', 'M', '2002-06-11 12:12:12', 31921512121, 341472789);

-- Inserting information in table "telefone"
INSERT INTO telefone (id_usuario, tipo, numero) VALUES 
    (1, 'C', 43999903212),
    (1, 'R', 4332521252),
    (2, 'C', 43999903214),
    (2, 'R', 4332526242),
    (3, 'C', 43999903216),
	(4, 'C', 43999903217),
	(5, 'C', 43999903218);

-- Inserting information in table "paciente"
INSERT INTO paciente (id_usuario, num_sus) VALUES 				
	(4, 898000085774482),
	(5, 898000085773405);

-- Inserting information in table "funcionario"
INSERT INTO funcionario (id_usuario, email, senha) VALUES 
	(1, 'pedro@hotmail.com', 'pedro12345'),	
	(2, 'joao@hotmail.com', 'joao12345'),
	(3, 'ana@hotmail.com', 'ana12345');  

-- Inserting information in table "medico"
INSERT INTO medico (id_funcionario, crm) VALUES 
	(1, '521323PR'),
	(2, '211252PR');

-- Inserting information in table "enfermeira"
INSERT INTO enfermeira (id_funcionario, coren) VALUES
    (3, '612421PR');

-- Inserting information in table "agendamento"
INSERT INTO agendamento (id_paciente, data_hora) VALUES 
	(4, '2021-05-28 14:35:00'),
	(5, '2021-06-03 08:35:00'),
	(5, '2021-07-03 08:35:00');

-- Inserting information in table "consulta"
INSERT INTO consulta (id_agendamento, id_medico) VALUES
    (1, 1),
    (2, 2),
    (3, 2);

-- Inserting information in table "receita"
INSERT INTO receita (id_consulta) VALUES		
    (1),
    (2);

-- Inserting information in table "remedio"
INSERT INTO remedio (nome, tarja, miligrama) VALUES
    ('Ibuprofeno', 'preta', 120),
    ('Diazepan', 'sem tarja', 100),
    ('Anfetamina', 'sem tarja', 15);

-- Inserting information in table "receita_remedio"
INSERT INTO receita_remedio (id_receita, id_remedio, orientacao) VALUES   
    (1, 1, '60mg a cada 2 horas'),
    (2, 3, '15mg antes de dormir'),
    (2, 2, '1 comprimido a cada 3 dias');

-- Inserting information in table "estoque"
INSERT INTO estoque (id_remedio, id_enfermeira, quantidade) VALUES 
    (1, 3, 0),
    (2, 3, 12),
    (3, 3, 67);
