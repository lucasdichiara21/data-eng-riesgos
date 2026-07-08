import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, GoogleCloudOptions
import json
from datetime import datetime


options=PipelineOptions()
google_cloud_options = options.view_as(GoogleCloudOptions)
google_cloud_options.project = 'riesgos-bancarios'
google_cloud_options.job_name = 'ingesta-transacciones'
google_cloud_options.staging_location = 'gs://riesgos-bancarios-dataflow/staging'
google_cloud_options.temp_location = 'gs://riesgos-bancarios-dataflow/temp'
options.view_as(GoogleCloudOptions).runner = 'DataflowRunner'


def procesar_transaccion(elemento):
    """Procesa una transacción: limpia, valida y enriquece"""
    try:
        data = json.loads(elemento)
        if 'monto' not in data or data['monto'] <= 0:
            return None
        
        data['fecha_procesamiento'] = datetime.now().isoformat()
        data['monto'] =float(data['monto'])
        
        return data
    
    except:
        return None 
    
def run():
    with beam.Pipeline(options=options) as p:
        
        transacciones = (
            p
            | 'Leer Mensajes' >> beam.io.ReadFromPubSub(
                subscription='projects/riesgos-bancarios/subscriptions/transacciones-sub')
            
            |'decodificar JSON' >> beam.map( lambda x: json.loads(x) )
            | 'Procesar Transacciones' >> beam.map(procesar_transaccion)
            | 'Filtrar nulos' >> beam.Filter( lambda x: x is not None )
            
            
        )
        
        _=  (
            transacciones
            |'Escribir a BigQuery' >> beam.io.WriteToBigQuery(
                table='riesgos-bancarios:transacciones.transacciones_procesadas',
                schema='SCHEMA_AUTODETECT',
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
                create_disposition=beam.io.BigQueryDisposition.CREATE_IF_NEEDED
                
                 )
        )
        if __name__ == '__main__':
            run()