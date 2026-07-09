-- Caso 6: Detección de anomalías (monto > 3x promedio últimas 10 tx)
WITH tx_ordenadas AS (
    SELECT
        id_cuenta,
        id_transaccion,
        fecha,
        monto,
        AVG(monto) OVER (
            PARTITION BY id_cuenta
            ORDER BY fecha
            ROWS BETWEEN 10 PRECEDING AND 1 PRECEDING
        ) AS media_10_previas
    FROM `riesgos.transacciones`
)

SELECT
    id_cuenta,
    id_transaccion,
    fecha,
    monto,
    media_10_previas,
    CASE
        WHEN media_10_previas IS NOT NULL AND monto > 3 * media_10_previas
            THEN 'ANOMALO'
        ELSE 'NORMAL'
    END AS flag_anomalia
FROM tx_ordenadas
WHERE media_10_previas IS NOT NULL
LIMIT 1000;
