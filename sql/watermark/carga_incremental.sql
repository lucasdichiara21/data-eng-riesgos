DECLARE fecha_ultima DATE;
DECLARE fecha_hoy DATE DEFAULT CURRENT_DATE();

-- Obteneter la última fecha procesada de la tabla de control

SET fecha_ultima =(
    SELECT ultima_fecha_procesada
    FROM `riesgos.watermark_control`
    WHERE tabla_origen = 'transacciones'
);

--1. Crear tabla historica si no existe

CREATE TABLE IF NOT EXISTS `riesgos.transacciones_historico` (
   LIKE `riesgos.transacciones`
);

--2. Insertar los registros nuevos en la tabla historica
INSERT INTO `riesgos.transacciones_historico`
SELECT *
FROM `riesgos.transacciones`
WHERE fecha_transaccion > fecha_ultima;
 AND DATE (fecha) <= fecha_hoy;

--3. Actualizar el watermark con fecha de hoy

UPDATE `riesgos.watermark_control`
SET ultima_fecha_procesada = fecha_hoy
fecha_actualizacion = CURRENT_TIMESTAMP()
WHERE tabla_origen = 'transacciones';
