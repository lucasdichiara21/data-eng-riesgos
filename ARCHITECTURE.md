# Arquitectura del Proyecto

## Componentes
- **BigQuery**: Almacenamiento y procesamiento.
- **Cloud Build**: CI/CD.
- **Cloud Composer**: Orquestación (Airflow).
- **Python**: Ingesta y validaciones.
- **SQLFluff**: Linting de SQL.

## Flujo de datos
1. DDL crea tablas particionadas y clusterizadas.
2. Seed carga datos de prueba.
3. Reportes generan análisis de riesgo.
4. SCD Tipo 2 actualiza límites históricos.
5. Watermark controla cargas incrementales.
6. Ingesta valida y escribe en dead‑letter.
7. Monitoreo alerta sobre errores.

## Validación de código
- **Pre-commit**: SQLFluff + dry-run.
- **Cloud Build**: SQLFluff como paso inicial.
- **Entornos**: `dev` (rama `dev`) y `prod` (rama `main`).