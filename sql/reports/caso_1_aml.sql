WITH depositos_mensuales AS (
  SELECT 
    id_cliente,
    DATE_TRUNC(fecha, MONTH) AS mes,
    SUM(monto) AS total_depositado
  FROM `{{PROJECT_ID}}.riesgos.transacciones`
  WHERE tipo = 'DEPOSITO'
    AND EXTRACT(YEAR FROM fecha) = 2024
  GROUP BY id_cliente, mes
  HAVING total_depositado > 50000
)
SELECT * FROM depositos_mensuales
ORDER BY total_depositado DESC;