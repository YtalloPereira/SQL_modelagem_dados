CREATE VIEW fato_locacao AS
SELECT
    l.idLocacao,
    l.idCliente AS skCliente,
    l.idCarro AS skCarro,
    l.idVendedor AS skVendedor,
    l.dataHoraLocacao,
    l.dataHoraEntrega,
    l.qtdDias,
    l.valorDiaria,
    l.valorTotal
FROM
    locacao_nor l;
	
