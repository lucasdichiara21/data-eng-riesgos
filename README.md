# Proyecto Data Engineer - Riesgos Bancarios (GCP)
# Proyecto Data Engineer - Riesgos Bancarios (GCP)

## 🎯 Objetivo
Construir un pipeline de datos automatizado para el área de riesgos bancarios, desplegando reportes SQL en BigQuery mediante CI/CD con Cloud Build y orquestación con Airflow.

---

## ✅ Estado actual del proyecto
- [x] Repositorio en GitHub conectado a GCP.
- [x] Trigger de Cloud Build configurado para la rama `dev`.
- [x] Tabla `transacciones` en BigQuery con partición por fecha y clustering.
- [x] 100,000 filas de datos de prueba cargados.
- [x] 6 reportes de riesgo ejecutándose automáticamente en cada `git push`:
  1. AML (Depósitos > $50,000) – Caso 1
  2. Estructuramiento (Smurfing) – Caso 2
  3. Saldo promedio móvil 7 días – Caso 3
  4. Detección de anomalías (monto > 3x media) – Caso 6
  5. Extracción de geolocalización desde JSON – Caso 7
  6. Percentil 95 de retiros (VaR) – Caso 10
- [x] DAG de Airflow (Cloud Composer) creado y versionado en el repositorio (pendiente de desplegar).

---

## 🧠 Aprendizajes clave (Errores comunes y cómo solucionarlos)

| Error | Causa | Solución |
|-------|-------|----------|
| `Unexpected string literal '.riesgos.transacciones'` | Usar comillas simples en lugar de backticks. | Usar backticks (`` ` ``) para nombres con puntos. |
| `Array index 4 is out of bounds` | `RAND()*4` puede dar 4.0. | Usar `FLOOR(RAND()*4)` y `CAST(... AS INT64)`. |
| `No matching signature for operator >= for argument types: TIMESTAMP, DATE` | Comparar TIMESTAMP con DATE sin conversión. | Usar `DATE(fecha) >= ...`. |
| `Array position in [] must be coercible to INT64` | `FLOOR` devuelve FLOAT64. | Envolver con `CAST(... AS INT64)`. |
| `No such file or directory` | Archivos nuevos no subidos a Git. | `git add` y commit. |
| `invalid value for 'build.substitutions': key in the template "ROWS"` | Cloud Build interpreta `$ROWS` como variable sustituta. | Escapar con `$$ROWS`. |
| `403 The billing account is disabled` | Facturación no habilitada. | Activar facturación en GCP. |

---

## 🔄 Flujo de despliegue (CI/CD)
1. Editar código en local (SQL, YAML, Python).
2. `git add . && git commit -m "mensaje" && git push origin dev`
3. Cloud Build detecta el cambio y ejecuta los pasos definidos en `cloudbuild/cloudbuild-dev.yaml`.
4. Los reportes se ejecutan en BigQuery y los resultados quedan disponibles.

---

## 📂 Estructura del repositorio
data-eng-riesgos/
├── cloudbuild/
│ └── cloudbuild-dev.yaml # Pipeline de CI/CD
├── dags/
│ └── dag_riesgos_diario.py # DAG de Airflow (orquestación)
├── sql/
│ ├── ddl/
│ │ └── tablas_riesgos.sql # Definición de tablas
│ ├── seed/
│ │ └── load_sample_data.sql # Datos de prueba
│ └── reports/
│ ├── caso_1_aml.sql
│ ├── caso_2_smurfing.sql
│ ├── caso_3_saldo_promedio.sql
│ ├── caso_6_anomalias.sql
│ ├── caso_7_geolocalizacion.sql
│ └── caso_10_percentil_retiros.sql
└── README.md


---

## 🚀 Próximos pasos
- Desplegar el DAG de Airflow en Cloud Composer para orquestación diaria.
- Agregar más reportes (ej: detección de lavado de dinero, scoring de riesgo).
- Configurar alertas en Slack cuando un reporte falle o detecte algo anómalo.