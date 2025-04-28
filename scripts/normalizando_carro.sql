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

