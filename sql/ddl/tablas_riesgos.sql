CREATE TABLE IF NOT EXISTS `riesgos.transacciones`
(
    id_transaccion STRING,
    id_cliente INT64,
    id_cuenta INT64,
    fecha TIMESTAMP,
    monto NUMERIC,
    tipo STRING,
    canal STRING,
    id_contraparte INT64,
    pais_origen STRING,
    pais_destino STRING,
    datos_metadata JSON
)
PARTITION BY DATE(fecha)
CLUSTER BY id_cliente, tipo;
