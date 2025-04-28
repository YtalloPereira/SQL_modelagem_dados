/*
	Há uma depenência transitiva , estadoVendedor que não depende exclusivamente
	da chave primária de vendendor , vou recriar vendendo relacionando com a 
	tabela estado que foi criada na normalização de cliente
*/
-- recriando tabela vendedor e populando
CREATE TABLE vendedor (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    estado_id INTEGER NOT NULL,
    sexo INTEGER NOT NULL,
    FOREIGN KEY (estado_id) REFERENCES estado(id)
);

INSERT INTO vendedor (id, nome, estado_id, sexo)
SELECT tv.idVendedor, tv.nomeVendedor, e.id, tv.sexoVendedor
FROM tb_vendedor tv
JOIN estado e ON tv.estadoVendedor = e.nome;

-- inserindo possíveis dados faltantes na tebela estado
INSERT INTO estado (nome, pais_id)
SELECT DISTINCT tv.estadoVendedor, 1
FROM tb_vendedor tv
WHERE NOT EXISTS (
    SELECT 1 
    FROM estado e 
    WHERE e.nome = tv.estadoVendedor
);
