CREATE TABLE IF NOT EXISTS `riesgos.watermark_control`
(
  tabla_origen STRING,
  ultima_fecha_procesada DATE,
  fecha_actualizacion TIMESTAMP
);

-- Insertar registro inicial (solo si la tabla está vacía)
INSERT INTO `riesgos.watermark_control`
SELECT 'transacciones', '2024-01-01', CURRENT_TIMESTAMP()
FROM UNNEST([1])   -- ← Agregamos un FROM dummy para poder usar WHERE
WHERE NOT EXISTS (SELECT 1 FROM `riesgos.watermark_control`);