SELECT
    id_transaccion,
    JSON_EXTRACT_SCALAR(metadata, '$.latitud') AS latitud,
    JSON_EXTRACT_SCALAR(metadata, '$.longitud') AS longitud
FROM `riesgos.transacciones`
WHERE metadata IS NOT NULL
ORDER BY id_transaccion
LIMIT 100;
