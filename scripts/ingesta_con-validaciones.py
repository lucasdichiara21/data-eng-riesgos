from google.cloud import bigquery
from google.cloud import storage
from datetime import datetime
import json

PROJECT_ID = 'riesgos-bancarios'
BUCKET_NAME = 'riesgos-bancarios-dataflow'
FILE_PATH = 'input/test_data.json'
TABLE_ID = f'{PROJECT_ID}.riesgos.transacciones_streaming'
DEAD_LETTER_TABLE = f'{PROJECT_ID}.riesgos.dead_letter_transacciones'

def validar_transaccion(data):
    if 'monto' not in data or data['monto']<= 0:
        return False,'monto inválido (<= 0 o ausente)'
    if 'id_cliente' not in data or data['id_cliente']<=0:
        return False, 'id_cliente inválido'
    return True,'OK'

def main():
    storage_client= storage.Client(project=PROJECT_ID)
    bq_client= bigquery.Client(project=PROJECT_ID)
    
    bucket= storage_client.bucket(BUCKET_NAME)
    blob=bucket.blob(FILE_PATH)
    content=blob.download_as_string().decode('utf-8')
    
    rows_validos= []
    errores=[]
    
    for line in content.strip().split('\n'):
        try:
            data= json.loads(line)
            es_valido, msg = validar_transaccion(data)
            if es_valido:
                data['fecha_procesamiento']= datetime.now().isoformat()
                data['monto']= float(data['monto'])
                rows_validos.append(data)
            else:
               errores.append({
                    'raw_data': line,
                    'error_message': msg,
                    'fecha_intento': datetime.now().isoformat(),
                    'proceso': 'ingesta_gcs'
                })
               
        except json.JSONDecodeError as e:
            errores.append({
                'raw_data': line,
                'error_message': f"JSON inválido: {str(e)}",
                'fecha_intento': datetime.now().isoformat(),
                'proceso': 'ingesta_gcs'
            })
            
            if rows_validos:
                bq_client.insert_rows_json(TABLE_ID, rows_validos)
                print(f"✅ {len(rows_validos)} filas insertadas correctamente.")
            
            if errores:
                bq_client.insert_rows_json(DEAD_LETTER_TABLE, errores)
                print(f"⚠️ {len(errores)} registros enviados a dead-letter.")
                
if __name__ == '__main__':
    main()
    