from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from datetime import datetime


# Define a Python function to run
def print_hello():
    print("Hello from Airflow!")


# Instantiate the DAG
dag = DAG(
    "example_dag",
    description="A simple example DAG",
    schedule_interval="@daily",  # Run once a day
    start_date=datetime(2025, 1, 1),
    catchup=False,
)

# Define the tasks
start_task = EmptyOperator(
    task_id="start",
    dag=dag,
)

hello_task = PythonOperator(
    task_id="print_hello",
    python_callable=print_hello,
    dag=dag,
)

# Set the task order
start_task >> hello_task
