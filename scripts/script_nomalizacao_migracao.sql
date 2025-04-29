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


/*
	tal qual  tb_cliente tb,_carro não atende a 3FN pois há uma dependencia
	entre modeloCarro e marcaCarro , vou decompor em mais tabelas para
	atender a normalização
*/

-- criando tabela de marca e populando
CREATE TABLE marca (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE
);

INSERT INTO marca (nome)
SELECT DISTINCT marcaCarro FROM tb_carro;

-- criando tabela modelo e populando
CREATE TABLE modelo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    marca_id INTEGER NOT NULL,
    FOREIGN KEY (marca_id) REFERENCES marca(id),
    UNIQUE (nome, marca_id)
);

INSERT INTO modelo (nome, marca_id)
SELECT DISTINCT tc.modeloCarro, m.id
FROM tb_carro tc
JOIN marca m ON tc.marcaCarro = m.nome;

-- recriando a tabela carro normalizada
CREATE TABLE carro (
    id INTEGER PRIMARY KEY,
    kilometragem INTEGER NOT NULL,
    classi TEXT NOT NULL UNIQUE,
    modelo_id INTEGER NOT NULL,
    ano INTEGER NOT NULL,
    combustivel_id INTEGER NOT NULL,
    FOREIGN KEY (modelo_id) REFERENCES modelo(id),
    FOREIGN KEY (combustivel_id) REFERENCES tb_combustivel(idCombustivel)
);

INSERT INTO carro (id, kilometragem, classi, modelo_id, ano, combustivel_id)
SELECT tc.idCarro, tc.kmCarro, tc.classiCarro, md.id, tc.anoCarro, tc.combCarro
FROM tb_carro tc
JOIN marca m ON tc.marcaCarro = m.nome
JOIN modelo md ON tc.modeloCarro = md.nome AND md.marca_id = m.id
JOIN tb_combustivel c ON tc.combCarro = c.idCombustivel;


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
