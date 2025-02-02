
CREATE TABLE if not exists padovan_cache (
    n BIGINT PRIMARY KEY,
    value BIGINT
);

CREATE OR REPLACE FUNCTION first_n_of_padovan(nn BIGINT) RETURNS BIGINT AS

$$
DECLARE
    res BIGINT;
BEGIN

    -- Проверяем, есть ли нужное значение в таблице
    SELECT value INTO res
    FROM padovan_cache
    WHERE n = nn;

    -- Если значение найдено, возвращаем его
    IF FOUND THEN
        RETURN res;
    END IF;

    -- Если значение не найдено, вычисляем его
    IF nn <= 3 THEN
        res := 1;
    ELSE
        res := first_n_of_padovan(nn - 2) + first_n_of_padovan(nn - 3);
    END IF;

    -- Сохраняем результат в кэш
    INSERT INTO padovan_cache (n, value)
    VALUES (nn, res)
    ON CONFLICT (n) DO UPDATE SET value = EXCLUDED.value;

    RETURN res;
END;

$$ LANGUAGE plpgsql;

select distinct n, first_n_of_padovan(n) res from padovan
order by n, res
