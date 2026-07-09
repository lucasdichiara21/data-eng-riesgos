# Proyecto Data Engineer - Riesgos Bancarios (GCP)


## 🎯 Objetivo
Construir un pipeline de datos automatizado para el área de riesgos bancarios, desplegando reportes SQL en BigQuery mediante CI/CD con Cloud Build y orquestación con Airflow.

---

## ✅ Entregables finales
- [x] 6 reportes de riesgo (AML, smurfing, saldo móvil, anomalías, geolocalización, VaR).
- [x] SCD Tipo 2 para límites de riesgo.
- [x] Watermark y carga incremental.
- [x] Validación de datos y dead‑letter.
- [x] Monitoreo de calidad.
- [x] CI/CD con Cloud Build (dev y producción).
- [x] SQLFluff para validación de estilo y sintaxis.
- [x] Documentación completa (README y ARCHITECTURE).

## 🚀 Despliegue
- `git push origin dev` → despliega en entorno de desarrollo.
- `git push origin main` → despliega en producción.

## 🔍 Validación de código
- Pre-commit hook ejecuta SQLFluff y dry-run antes de cada commit.
- Cloud Build ejecuta SQLFluff antes de cualquier despliegue.
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

