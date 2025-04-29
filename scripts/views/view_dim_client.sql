
CREATE VIEW dim_cliente AS
SELECT
    c.id AS skCliente,
    c.id AS nkCliente, 
    c.nome AS nomeCliente,
    ci.nome AS nomeCidade,
    e.nome AS nomeEstado,
    p.nome AS nomePais
FROM
    cliente c 
JOIN
    cidade ci ON c.cidade_id = ci.id  
JOIN
    estado e ON ci.estado_id = e.id  
JOIN
    pais p ON e.pais_id = p.id 







