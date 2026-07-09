from airflow import DAG
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateEmptyTableOperator, BigQueryInsertJobOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'riesgos_diarios',
    default_args=default_args,
    description='DAG para ejecutar consultas de riesgos diarios en BigQuery',
    interval_schedule='0 8 * * *',
    catchup=False,
    tags=['riesgo','gcp']
) as dag:
    
    t1_aml = BigQueryInsertJobOperator(
        task_id='riesgos_diarios_aml',
        configuration={
            "query": {
                'query': 'SELECT * FROM `riesgos-bancarios.riesgos.transacciones` WHERE tipo = "DEPOSITO" LIMIT 10;',
                'useLegacySql': False,
            }
        },
        location='US',
    )
    t2_smurfing = BigQueryInsertJobOperator(
        task_id='ejecutar_caso_smurfing',
        configuration={
            'query':{
                'query': 'SELECT COUNT(*) FROM `riesgos-bancarios.riesgos.transacciones` WHERE tipo = "TRANSFERENCIA";',
                'useLegacySql': False
            }
        },
        location='US'
    )
    t1_aml >> t2_smurfing
    
