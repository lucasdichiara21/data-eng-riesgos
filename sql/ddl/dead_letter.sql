CREATE TABLE IF NOT EXISTS `riesgos.dead_letter_transacciones` (

    raw_data STRING,
    error_message STRING,
    fecha_intento TIMESTAMP,
    proceso STRING
)
PARTITION BY DATE(fecha_intento)
CLUSTER BY proceso;
