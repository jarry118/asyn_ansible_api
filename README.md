API Usage：
POST /ad_hoc
param : < json >
{ 
    "data": {
       "host_list": "127.0.0.1", 
       "module_name": "shell",
       "module_args": "whoami", 
       "resource": {
          "hostname": "test1", 
          "ip": "127.0.0.1",
          "username": "root", 
          "port": "22", 
          "password": "root!2013"
        }
     }
}
return: < json >
{
    "task_id": "9976bdbf-1757-42e2-aa57-5fc3c8eb5ffb",
    "task_url": "/taskstats/ad_hoc/9976bdbf-1757-42e2-aa57-5fc3c8eb5ffb"
}
POST /playbook
param: < json >
{
  "data": {
       "playbooks": {
          "pb_name": "xx.yaml", 
          "pb_type": "host"
       },
       "resource": {
          "hostname": "test1", 
          "ip": "127.0.0.1",
          "username": "root", 
          "port": "22", 
          "password": "root!2013"
        }
     } 
}
return: < json >
{
    "task_id": "9976bdbf-1757-42e2-aa57-5fc3c8eb5ffb",
    "task_url": "/taskstats/playbook/9976bdbf-1757-42e2-aa57-5fc3c8eb5ffb"
}
GET /taskstats/< task_type >/< task_id >
return: < json >
{
    "state": "task_state",
    "status": "task_info",
}
