from google.cloud import bigquery
from google.cloud import storage
import json
from datetime import datetime


# Configuración
PROJECT_ID = 'riesgos-bancarios'
BUCKET_NAME = 'riesgos-bancarios-dataflow'
FILE_PATH = 'input/test_data.json'  # Ruta dentro del bucket
TABLE_ID = f'{PROJECT_ID}.riesgos.transacciones_streaming'


def main():
    # Inicializar clientes
    storage_client = storage.Client(project=PROJECT_ID)
    bq_client = bigquery.Client(project=PROJECT_ID)

    # Leer el archivo desde GCS
    bucket = storage_client.bucket(BUCKET_NAME)
    blob = bucket.blob(FILE_PATH)
    content = blob.download_as_string().decode('utf-8')
    
    rows= []
    for line in content.strip().split('\n'):
        try:
            data = json.loads(line)
            # Validar campos obligatorios
            if 'monto' not in data or data['monto'] <= 0:
                continue
            # Enriquecer
            data['fecha_procesamiento'] = datetime.now().isoformat()
            data['monto'] = float(data['monto'])
            rows.append(data)   
        except json.JSONDecodeError:
            print(f"Error al parsear: {line}")
            continue
        
    if not rows:
        print("No hay datos válidos para insertar.")
        return

    # Insertar en BigQuery
    errors = bq_client.insert_rows_json(TABLE_ID, rows)
    if errors:
        print(f"Errores al insertar: {errors}")
    else:
        print(f"✅ {len(rows)} filas insertadas correctamente en {TABLE_ID}")

if __name__ == '__main__':
    main()
            