try:

    from datetime import timedelta
    from airflow import DAG
    from airflow.operators.python_operator import PythonOperator
    from datetime import datetime
    import pandas as pd
    from chessdotcom import get_player_profile

    print("All Dag modules are ok ......")
except Exception as e:
    print("Error  {} ".format(e))

def first_funct_python(**context):
    print("first_function_execute   ")
    context['ti'].xcom_push(key='mykey', value="first_function_execute says Hello ")

def second_funct_python(**context):
    instance=context.get('ti').xcom_pull(key='mykey')
    data = [{"name": "Babasaheb", "title": "Data Analyst"},
            {"name": "Sam", "title": "Software Tester"}, ]
    df = pd.DataFrame(data=data)
    print('@' * 66)
    print(df.head())
    print('@' * 66)
    print(f"second function executed and got value {instance} from first function")
def chess_profile(**kwargs):
    user = kwargs.get("user","Didint get key")
    response = get_player_profile(user)
    print(response.json['player']['username'])
    print(response.json['player']['name'])
    print(response.json['player']['status'])
    print(response.json['player']['is_streamer'])


with DAG(
        dag_id="first_dag",
        schedule_interval="@daily",
        default_args={
            "owner": "airflow",
            "retries": 1,
            "retry_delay": timedelta(minutes=5),
            "start_date": datetime(2021, 1, 1),
        },
        catchup=False) as f:
        chess_profile = PythonOperator(
        task_id="chess_profile",
        python_callable=chess_profile,
        op_kwargs={"user": "babsmane"})

"""    first_funct_python = PythonOperator(
        task_id="first_funct_python",
        python_callable=first_funct_python,
        provide_context=True,
        op_kwargs={"name":"Babs"}
    )
    second_funct_python = PythonOperator(
        task_id="second_funct_python",
        python_callable=second_funct_python,
        provide_context=True
    )
"""

#first_funct_python >> second_funct_python