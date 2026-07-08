CREATE TABLE IF NOT EXISTS `riesgos.watermark_control`
(
  tabla_origen STRING,
  ultima_fecha_procesada DATE,
  fecha_actualizacion TIMESTAMP
);

-- Insertar el registro inicial solo si la tabla está vacía
MERGE `riesgos.watermark_control` AS target
USING (SELECT 'transacciones' AS tabla_origen, DATE '2024-01-01' AS ultima_fecha, CURRENT_TIMESTAMP() AS fecha_actualizacion) AS source
ON target.tabla_origen = source.tabla_origen
WHEN NOT MATCHED THEN
  INSERT (tabla_origen, ultima_fecha_procesada, fecha_actualizacion)
  VALUES (source.tabla_origen, source.ultima_fecha, source.fecha_actualizacion);