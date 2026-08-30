-- ============================================================
-- PROJETO FINAL - CLINICACARE
-- BANCO DE DADOS
-- ============================================================

-- ============================================================
-- 1. CRIACAO DO BANCO DE DADOS
-- ============================================================

-- Criacao do banco de dados da ClinicaCare
CREATE DATABASE clinica_care;

-- Seleciona o banco de dados
USE clinica_care;


-- ============================================================
-- 2. CRIACAO DAS TABELAS
-- ============================================================

-- ------------------------------------------------------------
-- Criacao da tabela PLANO
-- Armazena os planos e convenios aceitos pela clinica
-- ------------------------------------------------------------
CREATE TABLE plano (
    id_plano INT PRIMARY KEY AUTO_INCREMENT,
    nome_plano VARCHAR(100) NOT NULL,
    tipo_plano VARCHAR(50) NOT NULL,
    cobertura VARCHAR(150),
    coparticipacao DECIMAL(10,2),
    carencia_dias INT,
    status_plano VARCHAR(20),
    data_cadastro DATE NOT NULL
);

-- ------------------------------------------------------------
-- Criacao da tabela PACIENTE
-- Armazena os dados cadastrais dos pacientes
-- ------------------------------------------------------------
CREATE TABLE paciente (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    id_plano INT,
    nome_completo VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    genero VARCHAR(20),
    endereco VARCHAR(150),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    data_cadastro DATE NOT NULL,
    FOREIGN KEY (id_plano) REFERENCES plano(id_plano)
);

-- ------------------------------------------------------------
-- Criacao da tabela MEDICO
-- Armazena os dados dos medicos cadastrados
-- ------------------------------------------------------------
CREATE TABLE medico (
    id_medico INT PRIMARY KEY AUTO_INCREMENT,
    nome_completo VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    data_nascimento DATE,
    genero VARCHAR(20),
    status_ativo VARCHAR(20) NOT NULL,
    data_contratacao DATE
);

-- ------------------------------------------------------------
-- Criacao da tabela ESPECIALIDADE
-- Armazena as especialidades medicas da clinica
-- ------------------------------------------------------------
CREATE TABLE especialidade (
    id_especialidade INT PRIMARY KEY AUTO_INCREMENT,
    codigo_especialidade VARCHAR(20) NOT NULL UNIQUE,
    nome_especialidade VARCHAR(100) NOT NULL,
    valor_base_consulta DECIMAL(10,2),
    valor_particular DECIMAL(10,2),
    valor_convenio DECIMAL(10,2),
    data_cadastro DATE NOT NULL,
    status_especialidade VARCHAR(20) NOT NULL
);

-- ------------------------------------------------------------
-- Criacao da tabela DISPONIBILIDADE
-- Registra os dias e horarios disponiveis de cada medico
-- ------------------------------------------------------------
CREATE TABLE disponibilidade (
    id_disponibilidade INT PRIMARY KEY AUTO_INCREMENT,
    id_medico INT NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    turno_atendimento VARCHAR(20),
    sala_atendimento VARCHAR(30),
    tipo_atendimento VARCHAR(30),
    status_disponibilidade VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

-- ------------------------------------------------------------
-- Criacao da tabela MEDICO_ESPECIALIDADE
-- Resolve o relacionamento entre medicos e especialidades
-- ------------------------------------------------------------
CREATE TABLE medico_especialidade (
    id_medico_especialidade INT PRIMARY KEY AUTO_INCREMENT,
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    registro_especialidade VARCHAR(30),
    especialidade_principal VARCHAR(10),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

-- ------------------------------------------------------------
-- Criacao da tabela CONSULTA
-- Registra os agendamentos e consultas dos pacientes
-- ------------------------------------------------------------
CREATE TABLE consulta (
    id_consulta INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    data_consulta DATE NOT NULL,
    hora_consulta TIME NOT NULL,
    status_consulta VARCHAR(20) NOT NULL,
    valor_consulta DECIMAL(10,2) NOT NULL,
    modalidade_atendimento VARCHAR(30),
    observacoes VARCHAR(255),
    data_agendamento DATE NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    FOREIGN KEY (id_especialidade) REFERENCES especialidade(id_especialidade)
);

-- ------------------------------------------------------------
-- Criacao da tabela PRONTUARIO
-- Armazena diagnostico, historico e anotacoes medicas
-- ------------------------------------------------------------
CREATE TABLE prontuario (
    id_prontuario INT PRIMARY KEY AUTO_INCREMENT,
    id_consulta INT NOT NULL,
    diagnostico VARCHAR(255) NOT NULL,
    queixa_principal VARCHAR(255),
    historico_clinico TEXT,
    conduta_medica TEXT,
    alergias VARCHAR(255),
    observacoes TEXT,
    data_registro DATE NOT NULL,
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta)
);

-- ------------------------------------------------------------
-- Criacao da tabela PRESCRICAO
-- Registra os medicamentos prescritos pelos medicos
-- ------------------------------------------------------------
CREATE TABLE prescricao (
    id_prescricao INT PRIMARY KEY AUTO_INCREMENT,
    id_prontuario INT NOT NULL,
    id_medico INT NOT NULL,
    medicamento VARCHAR(100) NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    frequencia VARCHAR(50),
    duracao_tratamento VARCHAR(50),
    via_administracao VARCHAR(50),
    orientacoes TEXT,
    data_prescricao DATE NOT NULL,
    FOREIGN KEY (id_prontuario) REFERENCES prontuario(id_prontuario),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico)
);

-- ------------------------------------------------------------
-- Criacao da tabela PAGAMENTO
-- Registra os pagamentos das consultas
-- ------------------------------------------------------------
CREATE TABLE pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_consulta INT NOT NULL,
    id_plano INT,
    valor_total DECIMAL(10,2) NOT NULL,
    valor_coberto_plano DECIMAL(10,2),
    valor_pago_paciente DECIMAL(10,2) NOT NULL,
    data_pagamento DATE,
    metodo_pagamento VARCHAR(30),
    status_pagamento VARCHAR(20) NOT NULL,
    numero_recibo VARCHAR(30) UNIQUE,
    FOREIGN KEY (id_consulta) REFERENCES consulta(id_consulta),
    FOREIGN KEY (id_plano) REFERENCES plano(id_plano)
);


-- ============================================================
-- 3. INSERCAO DE DADOS
-- ============================================================

-- ------------------------------------------------------------
-- Insercao de dados na tabela PLANO
-- ------------------------------------------------------------
INSERT INTO plano
(nome_plano, tipo_plano, cobertura, coparticipacao, carencia_dias, status_plano, data_cadastro)
VALUES
('Plano Vida', 'Convenio', 'Consultas e exames', 30.00, 30, 'Ativo', '2026-01-10'),
('Saude Mais', 'Convenio', 'Consultas, exames e internacoes', 40.00, 60, 'Ativo', '2026-01-12'),
('Bem Estar', 'Convenio', 'Consultas e exames basicos', 25.00, 30, 'Ativo', '2026-01-15'),
('Clinica Plus', 'Convenio', 'Consultas especializadas', 35.00, 45, 'Ativo', '2026-01-18'),
('Saude Total', 'Convenio', 'Consultas, exames e cirurgias', 50.00, 90, 'Ativo', '2026-01-20'),
('Vida Plena', 'Convenio', 'Consultas e exames', 20.00, 30, 'Ativo', '2026-02-01'),
('MedSaude', 'Convenio', 'Consultas e exames laboratoriais', 30.00, 60, 'Ativo', '2026-02-03'),
('Saude Familiar', 'Convenio', 'Consultas para toda familia', 25.00, 30, 'Ativo', '2026-02-05'),
('Prime Care', 'Convenio', 'Consultas e exames especializados', 45.00, 60, 'Ativo', '2026-02-08'),
('Mais Saude', 'Convenio', 'Consultas e procedimentos', 30.00, 45, 'Ativo', '2026-02-10'),
('Saude Nordeste', 'Convenio', 'Consultas e exames regionais', 20.00, 30, 'Ativo', '2026-02-12'),
('Particular', 'Particular', 'Pagamento direto pelo paciente', 0.00, 0, 'Ativo', '2026-02-15');

-- ------------------------------------------------------------
-- Insercao de dados na tabela PACIENTE
-- ------------------------------------------------------------
INSERT INTO paciente
(id_plano, nome_completo, cpf, data_nascimento, genero, endereco, cidade, estado, telefone, email, data_cadastro)
VALUES
(1, 'Ana Beatriz Lima', '111.111.111-01', '1990-03-15', 'Feminino', 'Rua das Acacias, 120', 'Joao Pessoa', 'PB', '(83) 99911-1001', 'ana.lima@email.com', '2026-03-01'),
(2, 'Carlos Eduardo Silva', '111.111.111-02', '1985-07-22', 'Masculino', 'Rua das Flores, 245', 'Joao Pessoa', 'PB', '(83) 99911-1002', 'carlos.silva@email.com', '2026-03-02'),
(3, 'Mariana Alves Costa', '111.111.111-03', '1994-11-08', 'Feminino', 'Avenida Epitacio Pessoa, 780', 'Joao Pessoa', 'PB', '(83) 99911-1003', 'mariana.costa@email.com', '2026-03-03'),
(4, 'Joao Pedro Santos', '111.111.111-04', '1978-01-30', 'Masculino', 'Rua Bancario Sergio Guerra, 56', 'Joao Pessoa', 'PB', '(83) 99911-1004', 'joao.santos@email.com', '2026-03-04'),
(5, 'Fernanda Oliveira Melo', '111.111.111-05', '1988-05-19', 'Feminino', 'Avenida Jose Americo, 410', 'Joao Pessoa', 'PB', '(83) 99911-1005', 'fernanda.melo@email.com', '2026-03-05'),
(6, 'Lucas Henrique Souza', '111.111.111-06', '1997-09-12', 'Masculino', 'Rua Manoel Arruda Cavalcanti, 88', 'Joao Pessoa', 'PB', '(83) 99911-1006', 'lucas.souza@email.com', '2026-03-06'),
(7, 'Patricia Gomes Ferreira', '111.111.111-07', '1982-12-03', 'Feminino', 'Rua Professor Batista Leite, 190', 'Cabedelo', 'PB', '(83) 99911-1007', 'patricia.ferreira@email.com', '2026-03-07'),
(8, 'Rafael Martins Rocha', '111.111.111-08', '1991-04-25', 'Masculino', 'Rua Severino Nicolau de Melo, 315', 'Joao Pessoa', 'PB', '(83) 99911-1008', 'rafael.rocha@email.com', '2026-03-08'),
(9, 'Juliana Ribeiro Nunes', '111.111.111-09', '1986-08-14', 'Feminino', 'Avenida Oceano Atlantico, 620', 'Joao Pessoa', 'PB', '(83) 99911-1009', 'juliana.nunes@email.com', '2026-03-09'),
(10, 'Bruno Carvalho Dias', '111.111.111-10', '1995-02-17', 'Masculino', 'Rua Comerciante Alfredo Ferreira, 72', 'Bayeux', 'PB', '(83) 99911-1010', 'bruno.dias@email.com', '2026-03-10'),
(11, 'Camila Pereira Araujo', '111.111.111-11', '1993-06-28', 'Feminino', 'Rua Josefa Taveira, 505', 'Joao Pessoa', 'PB', '(83) 99911-1011', 'camila.araujo@email.com', '2026-03-11'),
(12, 'Diego Almeida Barros', '111.111.111-12', '1989-10-09', 'Masculino', 'Rua Pedro II, 143', 'Joao Pessoa', 'PB', '(83) 99911-1012', 'diego.barros@email.com', '2026-03-12');

-- ------------------------------------------------------------
-- Insercao de dados na tabela MEDICO
-- ------------------------------------------------------------
INSERT INTO medico
(nome_completo, crm, cpf, telefone, email, data_nascimento, genero, status_ativo, data_contratacao)
VALUES
('Marcos Antonio Ribeiro', 'CRM-PB-1001', '222.222.222-01', '(83) 98811-2001', 'marcos.ribeiro@clinicacare.com', '1978-04-12', 'Masculino', 'Ativo', '2024-01-10'),
('Fernanda Lopes Martins', 'CRM-PB-1002', '222.222.222-02', '(83) 98811-2002', 'fernanda.martins@clinicacare.com', '1982-09-23', 'Feminino', 'Ativo', '2024-02-15'),
('Ricardo Alves Souza', 'CRM-PB-1003', '222.222.222-03', '(83) 98811-2003', 'ricardo.souza@clinicacare.com', '1975-06-08', 'Masculino', 'Ativo', '2024-03-05'),
('Patricia Gomes Lima', 'CRM-PB-1004', '222.222.222-04', '(83) 98811-2004', 'patricia.lima@clinicacare.com', '1986-01-19', 'Feminino', 'Ativo', '2024-04-12'),
('Joao Henrique Costa', 'CRM-PB-1005', '222.222.222-05', '(83) 98811-2005', 'joao.costa@clinicacare.com', '1980-11-30', 'Masculino', 'Ativo', '2024-05-20'),
('Luciana Ferreira Melo', 'CRM-PB-1006', '222.222.222-06', '(83) 98811-2006', 'luciana.melo@clinicacare.com', '1987-03-14', 'Feminino', 'Ativo', '2024-06-18'),
('Eduardo Martins Rocha', 'CRM-PB-1007', '222.222.222-07', '(83) 98811-2007', 'eduardo.rocha@clinicacare.com', '1979-07-25', 'Masculino', 'Ativo', '2024-07-08'),
('Camila Nunes Barros', 'CRM-PB-1008', '222.222.222-08', '(83) 98811-2008', 'camila.barros@clinicacare.com', '1988-12-02', 'Feminino', 'Ativo', '2024-08-16'),
('Rodrigo Almeida Silva', 'CRM-PB-1009', '222.222.222-09', '(83) 98811-2009', 'rodrigo.silva@clinicacare.com', '1983-05-11', 'Masculino', 'Ativo', '2024-09-09'),
('Renata Carvalho Dias', 'CRM-PB-1010', '222.222.222-10', '(83) 98811-2010', 'renata.dias@clinicacare.com', '1985-10-17', 'Feminino', 'Ativo', '2024-10-21'),
('Felipe Pereira Santos', 'CRM-PB-1011', '222.222.222-11', '(83) 98811-2011', 'felipe.santos@clinicacare.com', '1981-02-28', 'Masculino', 'Ativo', '2024-11-11'),
('Amanda Oliveira Freitas', 'CRM-PB-1012', '222.222.222-12', '(83) 98811-2012', 'amanda.freitas@clinicacare.com', '1990-08-06', 'Feminino', 'Ativo', '2024-12-02');

-- ------------------------------------------------------------
-- Insercao de dados na tabela ESPECIALIDADE
-- ------------------------------------------------------------
INSERT INTO especialidade
(codigo_especialidade, nome_especialidade, valor_base_consulta, valor_particular, valor_convenio, data_cadastro, status_especialidade)
VALUES
('ESP001', 'Cardiologia', 180.00, 220.00, 160.00, '2026-01-05', 'Ativa'),
('ESP002', 'Pediatria', 160.00, 200.00, 150.00, '2026-01-05', 'Ativa'),
('ESP003', 'Ortopedia', 170.00, 210.00, 155.00, '2026-01-06', 'Ativa'),
('ESP004', 'Dermatologia', 180.00, 220.00, 165.00, '2026-01-06', 'Ativa'),
('ESP005', 'Ginecologia', 170.00, 210.00, 155.00, '2026-01-07', 'Ativa'),
('ESP006', 'Neurologia', 200.00, 250.00, 180.00, '2026-01-07', 'Ativa'),
('ESP007', 'Oftalmologia', 160.00, 200.00, 145.00, '2026-01-08', 'Ativa'),
('ESP008', 'Endocrinologia', 180.00, 220.00, 160.00, '2026-01-08', 'Ativa'),
('ESP009', 'Psiquiatria', 220.00, 280.00, 200.00, '2026-01-09', 'Ativa'),
('ESP010', 'Urologia', 180.00, 220.00, 160.00, '2026-01-09', 'Ativa'),
('ESP011', 'Gastroenterologia', 190.00, 230.00, 170.00, '2026-01-10', 'Ativa'),
('ESP012', 'Clinica Geral', 140.00, 180.00, 130.00, '2026-01-10', 'Ativa');

-- ------------------------------------------------------------
-- Insercao de dados na tabela MEDICO_ESPECIALIDADE
-- Liga os medicos as especialidades
-- ------------------------------------------------------------
INSERT INTO medico_especialidade
(id_medico, id_especialidade, registro_especialidade, especialidade_principal)
VALUES
(1, 1, 'RQE-1001', 'Sim'),
(1, 12, 'RQE-1002', 'Nao'),
(2, 2, 'RQE-1003', 'Sim'),
(3, 3, 'RQE-1004', 'Sim'),
(3, 12, 'RQE-1005', 'Nao'),
(4, 4, 'RQE-1006', 'Sim'),
(5, 5, 'RQE-1007', 'Sim'),
(6, 6, 'RQE-1008', 'Sim'),
(7, 7, 'RQE-1009', 'Sim'),
(8, 8, 'RQE-1010', 'Sim'),
(8, 12, 'RQE-1011', 'Nao'),
(9, 9, 'RQE-1012', 'Sim'),
(10, 10, 'RQE-1013', 'Sim'),
(11, 11, 'RQE-1014', 'Sim'),
(11, 12, 'RQE-1015', 'Nao'),
(12, 12, 'RQE-1016', 'Sim');

-- ------------------------------------------------------------
-- Insercao de dados na tabela DISPONIBILIDADE
-- ------------------------------------------------------------
INSERT INTO disponibilidade
(id_medico, dia_semana, hora_inicio, hora_fim, turno_atendimento, sala_atendimento, tipo_atendimento, status_disponibilidade)
VALUES
(1, 'Segunda-feira', '08:00:00', '12:00:00', 'Manha', 'Sala 01', 'Presencial', 'Disponivel'),
(2, 'Segunda-feira', '13:00:00', '17:00:00', 'Tarde', 'Sala 02', 'Presencial', 'Disponivel'),
(3, 'Terca-feira', '08:00:00', '12:00:00', 'Manha', 'Sala 03', 'Presencial', 'Disponivel'),
(4, 'Terca-feira', '13:00:00', '17:00:00', 'Tarde', 'Sala 04', 'Presencial', 'Disponivel'),
(5, 'Quarta-feira', '08:00:00', '12:00:00', 'Manha', 'Sala 05', 'Presencial', 'Disponivel'),
(6, 'Quarta-feira', '13:00:00', '17:00:00', 'Tarde', 'Sala 06', 'Presencial', 'Disponivel'),
(7, 'Quinta-feira', '08:00:00', '12:00:00', 'Manha', 'Sala 07', 'Presencial', 'Disponivel'),
(8, 'Quinta-feira', '13:00:00', '17:00:00', 'Tarde', 'Sala 08', 'Presencial', 'Disponivel'),
(9, 'Sexta-feira', '08:00:00', '12:00:00', 'Manha', 'Sala 09', 'Presencial', 'Disponivel'),
(10, 'Sexta-feira', '13:00:00', '17:00:00', 'Tarde', 'Sala 10', 'Presencial', 'Disponivel'),
(11, 'Sabado', '08:00:00', '12:00:00', 'Manha', 'Sala 11', 'Presencial', 'Disponivel'),
(12, 'Sabado', '13:00:00', '17:00:00', 'Tarde', 'Sala 12', 'Presencial', 'Disponivel');

-- ------------------------------------------------------------
-- Insercao de 20 consultas validas
-- ------------------------------------------------------------
INSERT INTO consulta
(id_paciente, id_medico, id_especialidade, data_consulta, hora_consulta, status_consulta, valor_consulta, modalidade_atendimento, observacoes, data_agendamento)
VALUES
(1, 1, 1, '2026-03-02', '09:00:00', 'Realizada', 220.00, 'Presencial', 'Consulta cardiologica de rotina', '2026-02-20'),
(2, 2, 2, '2026-03-02', '14:00:00', 'Realizada', 200.00, 'Presencial', 'Avaliacao pediatrica', '2026-02-21'),
(3, 3, 3, '2026-03-03', '09:30:00', 'Realizada', 210.00, 'Presencial', 'Dor no joelho', '2026-02-22'),
(4, 4, 4, '2026-03-03', '14:30:00', 'Realizada', 220.00, 'Presencial', 'Avaliacao dermatologica', '2026-02-23'),
(5, 5, 5, '2026-03-04', '09:00:00', 'Realizada', 210.00, 'Presencial', 'Consulta ginecologica de rotina', '2026-02-24'),
(6, 6, 6, '2026-03-04', '14:00:00', 'Realizada', 250.00, 'Presencial', 'Avaliacao neurologica', '2026-02-25'),
(7, 7, 7, '2026-03-05', '09:00:00', 'Realizada', 200.00, 'Presencial', 'Avaliacao oftalmologica', '2026-02-26'),
(8, 8, 8, '2026-03-05', '14:00:00', 'Realizada', 220.00, 'Presencial', 'Acompanhamento endocrinologico', '2026-02-27'),
(9, 9, 9, '2026-03-06', '09:00:00', 'Realizada', 280.00, 'Presencial', 'Avaliacao psiquiatrica', '2026-02-28'),
(10, 10, 10, '2026-03-06', '14:00:00', 'Realizada', 220.00, 'Presencial', 'Avaliacao urologica', '2026-03-01'),
(11, 11, 11, '2026-03-07', '09:00:00', 'Realizada', 230.00, 'Presencial', 'Avaliacao gastroenterologica', '2026-03-01'),
(12, 12, 12, '2026-03-07', '14:00:00', 'Realizada', 180.00, 'Presencial', 'Consulta clinica geral', '2026-03-02'),
(1, 1, 1, '2026-03-09', '10:00:00', 'Realizada', 220.00, 'Presencial', 'Retorno cardiologico', '2026-03-01'),
(2, 1, 1, '2026-09-07', '08:30:00', 'Agendada', 220.00, 'Presencial', 'Acompanhamento cardiologico', '2026-08-30'),
(3, 2, 2, '2026-03-09', '15:00:00', 'Realizada', 200.00, 'Presencial', 'Retorno pediatrico', '2026-03-02'),
(4, 12, 12, '2026-03-14', '14:30:00', 'Realizada', 180.00, 'Presencial', 'Consulta de clinica geral', '2026-03-05'),
(5, 12, 12, '2026-03-21', '15:00:00', 'Cancelada', 180.00, 'Presencial', 'Consulta cancelada pelo paciente', '2026-03-10'),
(6, 12, 12, '2026-03-28', '16:00:00', 'Faltou', 180.00, 'Presencial', 'Paciente nao compareceu', '2026-03-15'),
(7, 8, 8, '2026-03-12', '15:30:00', 'Realizada', 220.00, 'Presencial', 'Retorno endocrinologico', '2026-03-04'),
(8, 3, 3, '2026-03-10', '10:30:00', 'Realizada', 210.00, 'Presencial', 'Retorno ortopedico', '2026-03-03');

-- ------------------------------------------------------------
-- Insercao de dados na tabela PRONTUARIO
-- ------------------------------------------------------------
INSERT INTO prontuario
(id_consulta, diagnostico, queixa_principal, historico_clinico, conduta_medica, alergias, observacoes, data_registro)
VALUES
(1, 'Hipertensao arterial controlada', 'Palpitacoes ocasionais', 'Paciente em acompanhamento cardiologico', 'Manter medicacao e acompanhamento', 'Nenhuma relatada', 'Retorno em 90 dias', '2026-03-02'),
(2, 'Infeccao viral leve', 'Febre e coriza', 'Sem doencas cronicas conhecidas', 'Hidratacao, repouso e sintomaticos', 'Nenhuma relatada', 'Retorno se houver piora', '2026-03-02'),
(3, 'Tendinite no joelho', 'Dor ao caminhar', 'Historia de atividade fisica intensa', 'Repouso e fisioterapia', 'Nenhuma relatada', 'Evitar impacto por 15 dias', '2026-03-03'),
(4, 'Dermatite de contato', 'Coceira e vermelhidao', 'Sem historico dermatologico relevante', 'Uso de creme topico', 'Alergia a dipirona', 'Evitar produto irritante', '2026-03-03'),
(5, 'Consulta ginecologica sem alteracoes', 'Consulta de rotina', 'Sem queixas relevantes', 'Acompanhamento anual', 'Nenhuma relatada', 'Solicitados exames de rotina', '2026-03-04'),
(6, 'Cefaleia tensional', 'Dor de cabeca frequente', 'Episodios recorrentes ha 3 meses', 'Orientacoes e medicacao sintomatica', 'Nenhuma relatada', 'Avaliar evolucao em 30 dias', '2026-03-04'),
(7, 'Miopia leve', 'Dificuldade para enxergar de longe', 'Sem cirurgias oftalmologicas previas', 'Prescricao de oculos', 'Nenhuma relatada', 'Reavaliar em 12 meses', '2026-03-05'),
(8, 'Hipotireoidismo em acompanhamento', 'Cansaco frequente', 'Diagnostico previo de hipotireoidismo', 'Manter tratamento e solicitar exames', 'Nenhuma relatada', 'Retorno com exames laboratoriais', '2026-03-05'),
(9, 'Transtorno de ansiedade', 'Ansiedade e dificuldade para dormir', 'Sintomas ha aproximadamente 6 meses', 'Acompanhamento psiquiatrico', 'Nenhuma relatada', 'Retorno em 30 dias', '2026-03-06'),
(10, 'Infeccao urinaria', 'Ardor ao urinar', 'Sem historico recente de infeccao urinaria', 'Tratamento medicamentoso', 'Alergia a penicilina', 'Aumentar ingestao de agua', '2026-03-06'),
(11, 'Gastrite', 'Dor e queimacao no estomago', 'Sintomas associados a alimentacao', 'Orientacao alimentar e medicacao', 'Nenhuma relatada', 'Evitar alimentos irritantes', '2026-03-07'),
(12, 'Quadro gripal leve', 'Tosse e dor de garganta', 'Sem comorbidades relevantes', 'Tratamento sintomatico', 'Nenhuma relatada', 'Repouso e hidratacao', '2026-03-07');

-- ------------------------------------------------------------
-- Insercao de dados na tabela PRESCRICAO
-- ------------------------------------------------------------
INSERT INTO prescricao
(id_prontuario, id_medico, medicamento, dosagem, frequencia, duracao_tratamento, via_administracao, orientacoes, data_prescricao)
VALUES
(1, 1, 'Losartana', '50 mg', '1 vez ao dia', 'Uso continuo', 'Oral', 'Tomar sempre no mesmo horario', '2026-03-02'),
(2, 2, 'Paracetamol', '500 mg', 'A cada 8 horas se necessario', '3 dias', 'Oral', 'Usar somente em caso de febre ou dor', '2026-03-02'),
(3, 3, 'Ibuprofeno', '400 mg', 'A cada 8 horas', '5 dias', 'Oral', 'Tomar apos as refeicoes', '2026-03-03'),
(4, 4, 'Hidrocortisona creme', '1%', '2 vezes ao dia', '7 dias', 'Topica', 'Aplicar fina camada na area afetada', '2026-03-03'),
(5, 5, 'Sem medicamento', 'Nao se aplica', 'Nao se aplica', 'Nao se aplica', 'Nao se aplica', 'Manter acompanhamento de rotina', '2026-03-04'),
(6, 6, 'Paracetamol', '750 mg', 'A cada 8 horas se necessario', '5 dias', 'Oral', 'Evitar uso acima da dose recomendada', '2026-03-04'),
(7, 7, 'Lubrificante ocular', '1 gota', '3 vezes ao dia', '30 dias', 'Oftalmica', 'Aplicar nos dois olhos', '2026-03-05'),
(8, 8, 'Levotiroxina', '50 mcg', '1 vez ao dia', 'Uso continuo', 'Oral', 'Tomar em jejum pela manha', '2026-03-05'),
(9, 9, 'Sertralina', '50 mg', '1 vez ao dia', 'Uso continuo', 'Oral', 'Tomar conforme orientacao medica', '2026-03-06'),
(10, 10, 'Nitrofurantoina', '100 mg', 'A cada 6 horas', '7 dias', 'Oral', 'Completar todo o tratamento prescrito', '2026-03-06'),
(11, 11, 'Omeprazol', '20 mg', '1 vez ao dia', '30 dias', 'Oral', 'Tomar antes do cafe da manha', '2026-03-07'),
(12, 12, 'Paracetamol', '500 mg', 'A cada 8 horas se necessario', '3 dias', 'Oral', 'Manter hidratacao e repouso', '2026-03-07');

-- ------------------------------------------------------------
-- Insercao de dados na tabela PAGAMENTO
-- ------------------------------------------------------------
INSERT INTO pagamento
(id_consulta, id_plano, valor_total, valor_coberto_plano, valor_pago_paciente, data_pagamento, metodo_pagamento, status_pagamento, numero_recibo)
VALUES
(1, 1, 220.00, 160.00, 60.00, '2026-03-02', 'PIX', 'Pago', 'REC-0001'),
(2, 2, 200.00, 150.00, 50.00, '2026-03-02', 'Cartao', 'Pago', 'REC-0002'),
(3, 3, 210.00, 155.00, 55.00, '2026-03-03', 'PIX', 'Pago', 'REC-0003'),
(4, 4, 220.00, 165.00, 55.00, '2026-03-03', 'Dinheiro', 'Pago', 'REC-0004'),
(5, 5, 210.00, 155.00, 55.00, '2026-03-04', 'Cartao', 'Pago', 'REC-0005'),
(6, 6, 250.00, 180.00, 70.00, '2026-03-04', 'PIX', 'Pago', 'REC-0006'),
(7, 7, 200.00, 145.00, 55.00, '2026-03-05', 'PIX', 'Pago', 'REC-0007'),
(8, 8, 220.00, 160.00, 60.00, '2026-03-05', 'Cartao', 'Pago', 'REC-0008'),
(9, 9, 280.00, 200.00, 80.00, '2026-03-06', 'PIX', 'Pago', 'REC-0009'),
(10, 10, 220.00, 160.00, 60.00, '2026-03-06', 'Dinheiro', 'Pago', 'REC-0010'),
(11, 11, 230.00, 170.00, 60.00, '2026-03-07', 'Cartao', 'Pago', 'REC-0011'),
(12, 12, 180.00, 0.00, 180.00, '2026-03-07', 'PIX', 'Pago', 'REC-0012');


-- ============================================================
-- 4. ATUALIZACAO DE DADOS
-- ============================================================

-- Atualizacao do telefone do paciente de ID 1
UPDATE paciente
SET telefone = '(83) 99999-1234'
WHERE id_paciente = 1;

-- Conferencia da atualizacao
SELECT id_paciente, nome_completo, telefone
FROM paciente
WHERE id_paciente = 1;


-- ============================================================
-- 5. CONSULTAS E ANALISES
-- ============================================================

-- Consulta de todos os pacientes
SELECT * FROM paciente;

-- Consulta de pacientes com seus respectivos planos
SELECT
    paciente.nome_completo,
    plano.nome_plano,
    plano.tipo_plano
FROM paciente
INNER JOIN plano
    ON paciente.id_plano = plano.id_plano;

-- Consulta de paciente, medico, especialidade e atendimento
SELECT
    paciente.nome_completo AS paciente,
    medico.nome_completo AS medico,
    especialidade.nome_especialidade AS especialidade,
    consulta.data_consulta,
    consulta.hora_consulta,
    consulta.status_consulta
FROM consulta
INNER JOIN paciente
    ON consulta.id_paciente = paciente.id_paciente
INNER JOIN medico
    ON consulta.id_medico = medico.id_medico
INNER JOIN especialidade
    ON consulta.id_especialidade = especialidade.id_especialidade;

-- Quantidade de consultas por especialidade
SELECT
    especialidade.nome_especialidade AS especialidade,
    COUNT(consulta.id_consulta) AS total_consultas
FROM consulta
INNER JOIN especialidade
    ON consulta.id_especialidade = especialidade.id_especialidade
GROUP BY especialidade.nome_especialidade
ORDER BY total_consultas DESC;

-- Valor total das consultas por especialidade
SELECT
    especialidade.nome_especialidade AS especialidade,
    SUM(consulta.valor_consulta) AS valor_total
FROM consulta
INNER JOIN especialidade
    ON consulta.id_especialidade = especialidade.id_especialidade
GROUP BY especialidade.nome_especialidade
ORDER BY valor_total DESC;

-- Quantidade de consultas por medico
SELECT
    medico.nome_completo AS medico,
    COUNT(consulta.id_consulta) AS total_consultas
FROM consulta
INNER JOIN medico
    ON consulta.id_medico = medico.id_medico
GROUP BY medico.nome_completo
ORDER BY total_consultas DESC;

-- Quantidade de consultas por status
SELECT
    status_consulta,
    COUNT(*) AS total
FROM consulta
GROUP BY status_consulta
ORDER BY total DESC;

-- Resumo financeiro dos pagamentos
SELECT
    SUM(valor_total) AS valor_total_consultas,
    SUM(valor_coberto_plano) AS total_coberto_planos,
    SUM(valor_pago_paciente) AS total_pago_pacientes
FROM pagamento;

-- Quantidade e valor dos pagamentos por metodo
SELECT
    metodo_pagamento,
    COUNT(*) AS quantidade_pagamentos,
    SUM(valor_pago_paciente) AS total_pago
FROM pagamento
GROUP BY metodo_pagamento
ORDER BY quantidade_pagamentos DESC;

-- Quantidade de pacientes por plano
SELECT
    plano.nome_plano,
    COUNT(paciente.id_paciente) AS total_pacientes
FROM paciente
INNER JOIN plano
    ON paciente.id_plano = plano.id_plano
GROUP BY plano.nome_plano
ORDER BY total_pacientes DESC;

-- Quantidade de consultas por mes
SELECT
    DATE_FORMAT(data_consulta, '%Y-%m') AS mes,
    COUNT(*) AS total_consultas
FROM consulta
GROUP BY DATE_FORMAT(data_consulta, '%Y-%m')
ORDER BY mes;

-- Faturamento por mes
SELECT
    DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
    SUM(valor_total) AS faturamento_total
FROM pagamento
WHERE data_pagamento IS NOT NULL
GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m')
ORDER BY mes;

-- Media do valor das consultas
SELECT
    AVG(valor_consulta) AS media_valor_consultas
FROM consulta;

-- Faturamento por especialidade
SELECT
    especialidade.nome_especialidade AS especialidade,
    SUM(consulta.valor_consulta) AS faturamento_total
FROM consulta
INNER JOIN especialidade
    ON consulta.id_especialidade = especialidade.id_especialidade
GROUP BY especialidade.nome_especialidade
ORDER BY faturamento_total DESC;
