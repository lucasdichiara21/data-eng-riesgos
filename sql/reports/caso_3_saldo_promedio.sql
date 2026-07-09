WITH saldo_diario AS (
    SELECT
        id_cuenta,
        DATE(fecha) AS dia,
        SUM(monto) AS saldo_dia
    FROM `riesgos.transacciones`
    GROUP BY id_cuenta, dia

)

SELECT
    id_cuenta,
    saldo_dia,
    dia,
    AVG(saldo_dia)
        OVER (
            PARTITION BY id_cuenta
            ORDER BY dia ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        )
        AS saldo_promedio_7d
FROM saldo_diario
ORDER BY id_cuenta ASC, dia DESC
LIMIT 1000;
