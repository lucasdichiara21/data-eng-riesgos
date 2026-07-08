CREATE TABLE IF NOT EXISTS `riesgos.watermark_control`
(
  tabla_origen STRING,
  ultima_fecha_procesada DATE,
  fecha_actualizacion TIMESTAMP
);

INSERT INTO `riesgos.watermark_control`
SELECT 'transacciones', '2024-01-01', CURRENT_TIMESTAMP()
WHERE NOT EXISTS (SELECT 1 FROM `riesgos.watermark_control`);