WITH diario AS (
  SELECT 
    id_cliente,
    DATE(fecha) AS dia,
    SUM(monto) AS suma_diaria,
    COUNT(*) AS num_tx
  FROM `{{PROJECT_ID}}.riesgos.transacciones`
  WHERE tipo = 'TRANSFERENCIA'
    AND monto < 3000
    AND EXTRACT(YEAR FROM fecha) = 2024
  GROUP BY id_cliente, dia
  HAVING suma_diaria > 9000
)
SELECT *, TRUE AS alerta_smurfing FROM diario;