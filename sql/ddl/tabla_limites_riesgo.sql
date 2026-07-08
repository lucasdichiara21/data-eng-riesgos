CREATE TABLE IF NOT EXISTS 'riesgos.limites_riesgo_cliente'
(
    id_cliente INT64,
    limite_operativo_diario NUMERIC,
    fecha_inicio DATE,
    fecha_fin DATE,                 
    es_activo BOOLEAN
)
PARTITION BY fecha_inicio
CLUSTER BY id_cliente