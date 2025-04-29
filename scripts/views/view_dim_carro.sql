CREATE VIEW dim_carro AS 
SELECT
    c.id AS skCarro,
    c.id AS nkCarro,
    m.nome AS nomeModelo,
    ma.nome AS nomeMarca,
    c.ano AS anoCarro,
    c.classi AS classiCarro,
    co.tipoCombustivel,
    c.kilometragem
FROM
    carro c
JOIN
    modelo m ON c.modelo_id = m.id
JOIN
    marca ma ON m.marca_id = ma.id
JOIN
    tb_combustivel co ON c.combustivel_id = co.idCombustivel;
	
