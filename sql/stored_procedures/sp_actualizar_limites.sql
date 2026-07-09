CREATE OR REPLACE PROCEDURE `riesgos.actualizar_limites_riesgo` ()
BEGIN
    DECLARE fecha_actual DATE DEFAULT CURRENT_DATE();

    -- 1. Cerrar registros activos de clientes que superaron el umbral ayer
    UPDATE `riesgos.limites_riesgo_cliente`
    SET
        fecha_fin = DATE_SUB(fecha_actual, INTERVAL 1 DAY),
        es_activo = FALSE
    WHERE es_activo = TRUE AND id_cliente IN (
        SELECT id_cliente
        FROM `riesgos.transacciones`
        WHERE DATE(fecha) = DATE_SUB(fecha_actual, INTERVAL 1 DAY)
        GROUP BY id_cliente
        HAVING SUM(monto) > 50000
    );

    -- 2. Insertar los nuevos límites calculados
    INSERT INTO `riesgos.limites_riesgo_cliente`
    SELECT
        id_cliente,
        CASE
            WHEN SUM(monto) > 100000 THEN 50000
            WHEN SUM(monto) > 50000 THEN 25000
            ELSE 10000
        END AS nuevo_limite,
        fecha_actual AS fecha_inicio,
        CAST(NULL AS DATE) AS fecha_fin,   -- 🔥 FORZAR TIPO DATE
        TRUE AS es_activo
    FROM `riesgos.transacciones`
    WHERE DATE(fecha) = DATE_SUB(fecha_actual, INTERVAL 1 DAY)
    GROUP BY id_cliente
    HAVING SUM(monto) > 50000;
END;
