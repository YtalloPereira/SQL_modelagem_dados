CREATE VIEW dim_vendedor AS
SELECT
    v.id AS skVendedor,
    v.id AS nkVendedor,
    v.nome AS nomeVendedor,
    v.sexo AS sexoVendedor,
    e.nome AS nomeEstadoVendedor,
    p.nome AS nomePaisVendedor
FROM
    vendedor v
JOIN
    estado e ON v.estado_id = e.id
JOIN
    pais p ON e.pais_id = p.id;
	
DROP VIEW vw_dimCarro;
DROP VIEW vw_dimCliente;
DROP VIEW vw_dimTempo;
DROP VIEW vw_dimVendedor;
DROP VIEW vw_fato_locacao;