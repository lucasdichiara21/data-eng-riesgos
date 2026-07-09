-- Caso 10: Percentil 95 de retiros (VaR) últimos 90 días
WITH retiros AS (
    SELECT
        id_cliente,
        monto
    FROM `riesgos.transacciones`
    WHERE
        tipo = 'RETIRO'
        AND DATE(fecha) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
)

SELECT
    id_cliente,
    APPROX_QUANTILES(monto, 100)[OFFSET(94)] AS percentil_95_retiros,
    COALESCE(APPROX_QUANTILES(monto, 100)[OFFSET(94)] > 10000, FALSE)
        AS riesgo_alto
FROM retiros
GROUP BY id_cliente
ORDER BY percentil_95_retiros DESC
LIMIT 100;
