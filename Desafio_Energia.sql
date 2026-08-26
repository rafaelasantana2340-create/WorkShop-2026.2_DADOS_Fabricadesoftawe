CREATE SCHEMA DESAFIO;
USE DESAFIO;
CREATE TABLE regioes (
    id_regiao INT PRIMARY KEY,
    nome VARCHAR(100),
    estado VARCHAR(30),
    potencial FLOAT
);
CREATE TABLE usinas (
    id_usina INT PRIMARY KEY,
    nome VARCHAR(100),
    tipo VARCHAR(50),
    id_regiao INT,
    FOREIGN KEY (id_regiao) REFERENCES regioes(id_regiao)
);
CREATE TABLE geracao (
    id_geracao INT PRIMARY KEY,
    quantidade FLOAT,
    data_geracao DATE,
    id_usina INT,
    FOREIGN KEY (id_usina) REFERENCES usinas(id_usina)
);
INSERT INTO regioes (id_regiao, nome, estado, potencial)
VALUES
(1, 'Nordeste', 'Paraiba', 85.5),
(2, 'Sudeste', 'Sao Paulo', 72.3),
(3, 'Sul', 'Parana', 68.0),
(4, 'Norte', 'Amazonas', 90.2),
(5, 'Centro-Oeste', 'Goias', 76.4),
(6, 'Litoral', 'Pernambuco', 88.1),
(7, 'Sertao', 'Ceara', 81.7),
(8, 'Zona da Mata', 'Alagoas', 70.5),
(9, 'Agreste', 'Rio Grande do Norte', 79.0),
(10, 'Vale', 'Bahia', 83.6);

INSERT INTO usinas (id_usina, nome, tipo, id_regiao)
VALUES
(1, 'Usina Sol', 'Solar', 1),
(2, 'Usina Ventos', 'Eolica', 2),
(3, 'Usina Verde', 'Hidreletrica', 3),
(4, 'Usina Norte', 'Solar', 4),
(5, 'Usina Central', 'Eolica', 5),
(6, 'Usina Mar', 'Eolica', 6),
(7, 'Usina Sertao', 'Solar', 7),
(8, 'Usina Mata', 'Solar', 8),
(9, 'Usina Agreste', 'Eolica', 9),
(10, 'Usina Vale', 'Hidreletrica', 10);

INSERT INTO geracao (id_geracao, quantidade, data_geracao, id_usina)
VALUES
(1, 150.5, '2026-01-10', 1),
(2, 180.0, '2026-02-12', 2),
(3, 210.5, '2026-03-15', 3),
(4, 175.0, '2026-04-18', 4),
(5, 230.5, '2026-05-20', 5),
(6, 195.0, '2026-06-22', 6),
(7, 250.0, '2026-07-25', 7),
(8, 160.5, '2026-08-10', 8),
(9, 220.0, '2026-09-12', 9),
(10, 275.5, '2026-10-15', 10);

UPDATE usinas
SET nome = 'Usina Solar Nordeste'
WHERE id_usina = 1;

SELECT * FROM usinas;

SELECT COUNT(*) FROM geracao;

SELECT SUM(quantidade) FROM geracao;

SELECT AVG(quantidade) FROM geracao;

SELECT tipo, COUNT(*)
FROM usinas
GROUP BY tipo
HAVING COUNT(*) > 2;

SELECT usinas.nome, regioes.nome
FROM usinas
INNER JOIN regioes
ON usinas.id_regiao = regioes.id_regiao;

SELECT regioes.nome, SUM(geracao.quantidade) AS total_geracao
FROM regioes
INNER JOIN usinas
ON regioes.id_regiao = usinas.id_regiao
INNER JOIN geracao
ON usinas.id_usina = geracao.id_usina
GROUP BY regioes.nome
ORDER BY total_geracao DESC
LIMIT 1;