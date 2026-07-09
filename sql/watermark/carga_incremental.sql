DECLARE fecha_ultima DATE;
DECLARE fecha_hoy DATE DEFAULT CURRENT_DATE();

-- Obtener la última fecha procesada
SET fecha_ultima = (
    SELECT ultima_fecha_procesada
    FROM `riesgos.watermark_control`
    WHERE tabla_origen = 'transacciones'
);

-- 1. Crear tabla histórica si no existe (copiando esquema sin datos)
CREATE TABLE IF NOT EXISTS `riesgos.transacciones_historicas` AS
SELECT
    id_transaccion,
    id_cliente,
    id_cuenta,
    fecha,
    monto,
    tipo,
    canal,
    id_contraparte,
    pais_origen,
    pais_destino,
    metadata   
FROM `riesgos.transacciones`
WHERE 1 = 0;

-- 2. Insertar las transacciones nuevas (desde el watermark hasta hoy)
INSERT INTO `riesgos.transacciones_historicas`
SELECT
    id_transaccion,
    id_cliente,
    id_cuenta,
    fecha,
    monto,
    tipo,
    canal,
    id_contraparte,
    pais_origen,
    pais_destino,
    metadata   
FROM `riesgos.transacciones`
WHERE
    DATE(fecha) > fecha_ultima
    AND DATE(fecha) <= fecha_hoy;

-- 3. Actualizar el watermark con la fecha de hoy
UPDATE `riesgos.watermark_control`
SET
    ultima_fecha_procesada = fecha_hoy,
    fecha_actualizacion = CURRENT_TIMESTAMP()
WHERE tabla_origen = 'transacciones';