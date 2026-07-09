from google.cloud import bigquery
from google.cloud import storage
import json
from datetime import datetime

PROJECT_ID = 'riesgos-bancarios'
BUCKET_NAME = 'riesgos-bancarios-dataflow'
FILE_PATH = 'input/test_data.json'
TABLE_ID = f'{PROJECT_ID}.riesgos.transacciones_streaming'

def main():
    storage_client = storage.Client(project=PROJECT_ID)
    bq_client = bigquery.Client(project=PROJECT_ID)

    # Crear la tabla si no existe
    try:
        bq_client.get_table(TABLE_ID)
        print(f"La tabla {TABLE_ID} ya existe.")
    except Exception:
        print(f"Creando tabla {TABLE_ID}...")
        schema = [
            bigquery.SchemaField("id_cliente", "INTEGER"),
            bigquery.SchemaField("monto", "FLOAT"),
            bigquery.SchemaField("tipo", "STRING"),
            bigquery.SchemaField("fecha_procesamiento", "TIMESTAMP"),
        ]
        table = bigquery.Table(TABLE_ID, schema=schema)
        bq_client.create_table(table)
        print(f"Tabla {TABLE_ID} creada.")

    # Leer archivo desde GCS
    bucket = storage_client.bucket(BUCKET_NAME)
    blob = bucket.blob(FILE_PATH)
    if not blob.exists():
        print(f"El archivo {FILE_PATH} no existe en GCS.")
        return

    content = blob.download_as_string().decode('utf-8')
    rows = []
    for line in content.strip().split('\n'):
        line = line.strip()
        if not line:
            continue
        try:
            data = json.loads(line)
            if 'monto' not in data or data['monto'] <= 0:
                continue
            data['fecha_procesamiento'] = datetime.now().isoformat()
            data['monto'] = float(data['monto'])
            rows.append(data)
        except json.JSONDecodeError:
            print(f"Error al parsear línea: {line}")
            continue

    if not rows:
        print("No hay datos válidos para insertar.")
        return

    errors = bq_client.insert_rows_json(TABLE_ID, rows)
    if errors:
        print(f"Errores al insertar: {errors}")
    else:
        print(f"✅ {len(rows)} filas insertadas correctamente en {TABLE_ID}")

if __name__ == '__main__':
    main()