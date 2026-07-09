CREATE TABLE IF NOT EXISTS `riesgos.watermark_control`
(
    tabla_origen STRING,
    ultima_fecha_procesada DATE,
    fecha_actualizacion TIMESTAMP
);

-- Insertar registro inicial (solo si la tabla está vacía)
INSERT INTO `riesgos.watermark_control`
SELECT
    'transacciones' AS tabla_origen,
    DATE('2024-01-01') AS ultima_fecha_procesada,
    CURRENT_TIMESTAMP() AS fecha_actualizacion
FROM UNNEST([1])
WHERE NOT EXISTS (SELECT 1 FROM `riesgos.watermark_control`);
