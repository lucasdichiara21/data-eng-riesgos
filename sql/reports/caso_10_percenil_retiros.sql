WITH retiros AS(
    SELECT
        id_cliente,
        monto,
    FROM `riesgos.transacciones`
    WHERE tipo = 'retiro'
        AND fecha >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)

)
SELECT 
    id_cliente,
    APPROX_QUANTILES(monto, 100)[OFFSET(94)] AS percentil_95_retiros
    CASE 
        WHEN monto > APPROX_QUANTILES(monto, 100)[OFFSET(94)]>10000
        THEN TRUE
        ELSE FALSE
    END AS riesgo_alto
    GROUP BY id_cliente
    ORDER BY percentil_95_retiros DESC
    LIMIT 100;
    
