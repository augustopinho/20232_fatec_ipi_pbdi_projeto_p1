-- 2. Calcular o preço médio dos vinhos de cada país utilizando um cursor não vinculado
DO
$$
-- Declarar variáveis
DECLARE 
    pais_atual VARCHAR;
    preco_vinho NUMERIC;
	contador INT;
	preco_total NUMERIC;-- Variável escalar para armazenar temporariamente o preço do vinho
BEGIN
	preco_total =0;
	preco_total =0;
    -- Loop para percorrer os países
    FOR pais_atual IN (SELECT DISTINCT country FROM tb_vinhos2)
    LOOP
		preco_total := 0;
        -- Calcular o preço médio para o país atual
        FOR preco_vinho IN (SELECT price FROM tb_vinhos2 WHERE country = pais_atual)
        LOOP
            preco_total := preco_total + preco_vinho;
            contador := contador + 1;
        END LOOP;

        -- Verificar se houve vinhos para o país antes de calcular a média
        IF contador > 0 THEN
            RAISE NOTICE 'País: %, Preço Médio: %', pais_atual, preco_total / contador;
        ELSE
            RAISE NOTICE 'País: %, Nenhum vinho encontrado.', pais_atual;
        END IF;

        -- Resetar o contador para o próximo país
        contador:= 0;
    END LOOP;
END;
$$

-- Criando a tabela

-- CREATE TABLE tb_vinhos2 (
-- 	ID SERIAL PRIMARY KEY,
-- 	country VARCHAR(200),
-- 	description VARCHAR(1000),
-- 	points INT,
-- 	price NUMERIC
-- );
