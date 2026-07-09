SELECT
    DATE(fecha_intentos) AS dia,
    proceso,
    COUNT(*) AS total_errores
    FROM ´`riesgos.dead_letter_transacciones`
    WHERE fecha_intento >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
    GROUP BY
        dia,proceso
    ORDER BY
        total_errores DESC