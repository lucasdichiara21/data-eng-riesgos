-- Caso 10: Percentil 95 de retiros (VaR) últimos 90 días
WITH retiros AS (
  SELECT 
    id_cliente,
    monto
  FROM `riesgos.transacciones`
  WHERE tipo = 'RETIRO'
    AND DATE(fecha) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
)
SELECT 
  id_cliente,
  APPROX_QUANTILES(monto, 100)[OFFSET(94)] AS percentil_95_retiros,
  CASE 
    WHEN APPROX_QUANTILES(monto, 100)[OFFSET(94)] > 10000 
    THEN TRUE 
    ELSE FALSE 
  END AS riesgo_alto
FROM retiros
GROUP BY id_cliente
ORDER BY percentil_95_retiros DESC
LIMIT 100;