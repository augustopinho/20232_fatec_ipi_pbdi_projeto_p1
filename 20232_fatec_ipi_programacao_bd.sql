-- 4. Os resultados obtidos pelos cursores devem ser armazenados numa tabela com os seguintes campos
CREATE TABLE resultados_vinhos (
ID SERIAL PRIMARY KEY,
name_country VARCHAR(50),
price_medio NUMERIC,
description_long VARCHAR(1500)
);

DO
$$
-- Declarar variáveis
DECLARE 
    pais_atual VARCHAR;
    preco_vinho NUMERIC;
    descricao VARCHAR; 
    contador INT;
    preco_total NUMERIC;
BEGIN
    preco_total := 0;
    contador := 0;
    descricao := ''; 

    -- Loop para percorrer os países
    FOR pais_atual IN (SELECT DISTINCT country FROM tb_vinhos2)
    LOOP
        preco_total := 0;
        descricao := ''; 

        -- Calcular o preço médio e coletar descrições para o país atual
        FOR preco_vinho, descricao IN (SELECT price, description FROM tb_vinhos2 WHERE country = pais_atual)
        LOOP
            preco_total := preco_total + preco_vinho;
            contador := contador + 1;
        END LOOP;

        -- Verificar se houve vinhos para o país antes de calcular a média
        IF contador > 0 THEN
            RAISE NOTICE 'País: %, Preço Médio: %', pais_atual, preco_total / contador;
            INSERT INTO resultados_vinhos (ID, name_country, price_medio, description_long)
            VALUES (DEFAULT, pais_atual, preco_total / contador, descricao);
        ELSE
            RAISE NOTICE 'País: %, Nenhum vinho encontrado.', pais_atual;
        END IF;

        -- Resetar o contador e a descrição para o próximo país
        contador := 0;
        descricao := '';
    END LOOP;
END;
$$


-- --3. Identificar a descrição mais longa para os vinhos de cada país utilizando um cursor vinculado.
-- DO $$
-- DECLARE
--     -- Declarando o cursor
--     cur_country_e_description CURSOR FOR SELECT country, description FROM tb_vinhos2;
--     -- Declarando tupla e variáveis
--     tupla RECORD;
--     registro_count INT DEFAULT 0;
-- BEGIN
--     -- Abrindo o cursor
--     OPEN cur_country_e_description;

--     -- Inicializando variáveis para o primeiro registro
--     FETCH cur_country_e_description INTO tupla;
--     registro_count := 1;

--     -- Imprimindo o cabeçalho da tabela
--     RAISE NOTICE 'Número de Registro | Country | Description';
--     RAISE NOTICE '--------------------------------------------';

--     -- Loop para percorrer os registros
--     WHILE FOUND LOOP
--         -- Imprimindo cada registro como uma linha da tabela
--
--     -- Fechando o cursor
--             RAISE NOTICE '% | % | %', registro_count, tupla.country, tupla.description;
        
--         -- Continuando a busca pelos registros
--         FETCH cur_country_e_description INTO tupla;
--         registro_count := registro_count + 1;
--     END LOOP;

--     -- Fechando o cursor
--     CLOSE cur_country_e_description;
-- END $$;

-- -- 2. Calcular o preço médio dos vinhos de cada país utilizando um cursor não vinculado
-- DO
-- $$
-- -- Declarar variáveis
-- DECLARE 
--     pais_atual VARCHAR;
--     preco_vinho NUMERIC;
-- 	contador INT;
-- 	preco_total NUMERIC;-- Variável escalar para armazenar temporariamente o preço do vinho
-- BEGIN
-- 	preco_total =0;
-- 	preco_total =0;
--     -- Loop para percorrer os países
--     FOR pais_atual IN (SELECT DISTINCT country FROM tb_vinhos2)
--     LOOP
-- 		preco_total := 0;
--         -- Calcular o preço médio para o país atual
--         FOR preco_vinho IN (SELECT price FROM tb_vinhos2 WHERE country = pais_atual)
--         LOOP
--             preco_total := preco_total + preco_vinho;
--             contador := contador + 1;
--         END LOOP;

--         -- Verificar se houve vinhos para o país antes de calcular a média
--         IF contador > 0 THEN
--             RAISE NOTICE 'País: %, Preço Médio: %', pais_atual, preco_total / contador;
--         ELSE
--             RAISE NOTICE 'País: %, Nenhum vinho encontrado.', pais_atual;
--         END IF;

--         -- Resetar o contador para o próximo país
--         contador:= 0;
--     END LOOP;
-- END;
-- 

-- 1. Base de dados e criação de tabela

-- CREATE TABLE tb_vinhos2 (
-- 	ID SERIAL PRIMARY KEY,
-- 	country VARCHAR(200),
-- 	description VARCHAR(1000),
-- 	points INT,
-- 	price NUMERIC
-- );
