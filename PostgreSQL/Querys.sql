-------------------------------------------------------------------------------- Agregação ----------------------------------------------------------------------------------
-- Distribuição Fixo-Celular
SELECT 
	(CASE 
  	WHEN tipo = 'R' THEN 'Residencial'
    WHEN tipo = 'C' THEN 'Celular'
  	ELSE 'Desconhecido'
  END) AS tipo_telefone,
	COUNT(tipo) AS quantidade 
FROM telefone
GROUP BY tipo;

-- Distribuição entre Homens-Mulheres
SELECT
	(CASE 
  	WHEN sexo = 'M' THEN 'Homens'
    WHEN sexo = 'F' THEN 'Mulheres'
  	ELSE 'Outros'
  END) AS sexo,
  COUNT(sexo) AS quantidade
FROM usuario
GROUP BY sexo;

-- Quantidade de telefones que uma pessoa possui
SELECT
	CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome) AS usuario,
  COUNT(telefone.id_telefone) AS quant_telefones
FROM telefone
	RIGHT JOIN usuario 
		ON usuario.id_usuario = telefone.id_usuario
GROUP BY usuario.id_usuario
ORDER BY COUNT(telefone.id_telefone) DESC, usuario.primeiro_nome ASC;

-- Quantidade de consultas por dia
SELECT
	TO_CHAR(agendamento.data_hora, 'dd/mm/yyyy') AS data,
  COUNT(agendamento.id_agendamento) AS numero_consultas
FROM agendamento
GROUP BY agendamento.data_hora
ORDER BY agendamento.data_hora ASC;

-- Quantidades de Pacientes por bairro
SELECT 
	bairro.nome AS bairro,
	COUNT(DISTINCT usuario.id_bairro) AS quantidade_pacientes
FROM bairro
	RIGHT JOIN usuario
		ON bairro.id_bairro = usuario.id_bairro
GROUP BY bairro.id_bairro;

-------------------------------------------------------------------------------- Join ---------------------------------------------------------------------------------------
-- Somar todos os remédios no estoque
SELECT 
	remedio.nome,
	estoque.quantidade 
FROM remedio 
	RIGHT JOIN estoque 
  	ON estoque.id_remedio = remedio.id_remedio;

-- Ficha completa
SELECT
	CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome) AS nome,
  TO_CHAR(usuario.data_nascimento, 'dd/mm/yyyy hh:ii') AS data_de_nascimento,
  usuario.sexo,
  usuario.cpf,
  usuario.rg,
  bairro.nome AS bairro,
  estado.nome AS estado,
  cidade.nome AS cidade
FROM usuario 
	INNER JOIN bairro 
  	ON usuario.id_bairro = bairro.id_bairro 
  INNER JOIN cidade 
  	ON cidade.id_cidade = bairro.id_cidade 
  INNER JOIN estado 
  	ON cidade.uf = estado.uf;
   
-- Telefones com proprietarios
SELECT 
	telefone.numero, 
  CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome) AS nome
FROM telefone 
	RIGHT JOIN usuario 
  	ON telefone.id_usuario = usuario.id_usuario;
   
   
-- Agendamento das Consultas
SELECT 
	TO_CHAR(agendamento.data_hora, 'dd/mm/yyyy hh:ii') AS data_da_consulta,
	(
    SELECT 
      CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome)
    FROM medico 
      INNER JOIN funcionario 
        ON funcionario.id_usuario = medico.id_funcionario
      INNER JOIN usuario 
        ON funcionario.id_usuario = usuario.id_usuario
    WHERE medico.id_funcionario = consulta.id_medico 
	) AS medico_responsavel,
	CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome) AS paciente,
  TO_CHAR(usuario.data_nascimento, 'dd/mm/yyyy hh:ii') AS data_de_nascimento,
  usuario.sexo,
  usuario.cpf,
  bairro.nome AS bairro
FROM consulta 
	INNER JOIN agendamento 
  	ON agendamento.id_agendamento = consulta.id_agendamento
  INNER JOIN paciente
  	ON paciente.id_usuario = agendamento.id_paciente
  INNER JOIN usuario
  	ON paciente.id_usuario = usuario.id_usuario
  INNER JOIN bairro 
  	ON usuario.id_bairro = bairro.id_bairro;
    
-- Relação remedio-paciente
SELECT 
	CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome) AS paciente,
  remedio.nome AS remedio,
  receita_remedio.orientacao
FROM receita_remedio
	INNER JOIN receita
  	ON receita.id_receita = receita_remedio.id_receita
  INNER JOIN remedio
  	ON remedio.id_remedio = receita_remedio.id_remedio
	INNER JOIN consulta
  	ON receita.id_consulta = consulta.id_agendamento
  INNER JOIN agendamento
  	ON consulta.id_agendamento = agendamento.id_agendamento
  INNER JOIN  paciente
  	ON agendamento.id_paciente = paciente.id_usuario
  INNER JOIN usuario
  	ON usuario.id_usuario = paciente.id_usuario;
    
-------------------------------------------------------------------------------- Filtros ------------------------------------------------------------------------------------
-- Selecionar o remédio com maior miligrama
SELECT 
	nome, 
  miligrama 
FROM remedio 
ORDER BY miligrama DESC 
LIMIT 1;

-- Telefones Móveis para Notificação pelo APP/SMS
SELECT 
	telefone.numero,
  telefone.tipo,
  usuario.primeiro_nome,
  usuario.segundo_nome 
FROM telefone 
	RIGHT JOIN usuario 
  	ON telefone.id_usuario = usuario.id_usuario 
WHERE telefone.tipo = 'C';

-- Consultas pendentes
SELECT 
	TO_CHAR(agendamento.data_hora, 'dd/mm/yyyy hh:ii') AS data_da_consulta,
	(
    SELECT 
      CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome)
    FROM medico 
      INNER JOIN funcionario 
        ON funcionario.id_usuario = medico.id_funcionario
      INNER JOIN usuario 
        ON funcionario.id_usuario = usuario.id_usuario
    WHERE medico.id_funcionario = consulta.id_medico 
	) AS medico_responsavel,
	CONCAT(usuario.primeiro_nome, ' ', usuario.segundo_nome) AS paciente,
  TO_CHAR(usuario.data_nascimento, 'dd/mm/yyyy hh:ii') AS data_de_nascimento,
  usuario.sexo,
  usuario.cpf,
  bairro.nome AS bairro
FROM consulta 
	INNER JOIN agendamento 
  	ON agendamento.id_agendamento = consulta.id_agendamento
  INNER JOIN paciente
  	ON paciente.id_usuario = agendamento.id_paciente
  INNER JOIN usuario
  	ON paciente.id_usuario = usuario.id_usuario
  INNER JOIN bairro 
  	ON usuario.id_bairro = bairro.id_bairro
WHERE agendamento.data_hora > NOW();

-- Remedios Tarja preta
SELECT
	remedio.nome,
  remedio.miligrama,
  remedio.tarja
FROM remedio 
WHERE tarja = 'preta';

-- Pacientes maiores de 18 anos
SELECT 
	CONCAT(primeiro_nome, ' ', segundo_nome) AS nome,
  DATE_PART('year', AGE(NOW(), data_nascimento)) AS idade
FROM usuario
WHERE DATE_PART('year', AGE(NOW(), data_nascimento)) >= 18
ORDER BY idade DESC, nome ASC;