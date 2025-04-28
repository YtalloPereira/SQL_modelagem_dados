/*
  aplicando norma 3FN , já que há uma depenência entre cidadeCliente e 
  estadoCliente e também entre estadoCliente e paisCliente irei decompor isso
  criando novas tabelas
 */
 
 -- criando tabela para pais e populando com os dados de tb_cliente
CREATE TABLE pais (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE
);

INSERT INTO pais (nome)
SELECT DISTINCT paisCliente FROM tb_cliente;

-- criando e populando tabela de estados
CREATE TABLE estado (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    pais_id INTEGER NOT NULL,
    UNIQUE (nome, pais_id),
    FOREIGN KEY (pais_id) REFERENCES pais(id)
);

INSERT INTO estado (nome, pais_id)
SELECT DISTINCT t.estadoCliente, p.id
FROM tb_cliente t
JOIN pais p ON t.paisCliente = p.nome;

-- criando e populando tabela de cidades
CREATE TABLE cidade (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    estado_id INTEGER NOT NULL,
    UNIQUE (nome, estado_id),
    FOREIGN KEY (estado_id) REFERENCES estado(id)
);

INSERT INTO cidade (nome, estado_id)
SELECT DISTINCT t.cidadeCliente, e.id
FROM tb_cliente t
JOIN estado e ON t.estadoCliente = e.nome;

-- recriando a tabela de clientes normalizada
CREATE TABLE cliente (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    cidade_id INTEGER NOT NULL,
    FOREIGN KEY (cidade_id) REFERENCES cidade(id)
);

INSERT INTO cliente (id, nome, cidade_id)
SELECT t.idCliente, t.nomeCliente, c.id
FROM tb_cliente t
JOIN cidade c ON t.cidadeCliente = c.nome
JOIN estado e ON c.estado_id = e.id AND t.estadoCliente = e.nome