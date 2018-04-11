#环境

flask=0.12.2
celery=4.1.0
rabbitmq=3.5.3
ansible=2.4.3.0
Ansible API 设计说明
1.核心类
from ansible.parsing.dataloader import DataLoader  #用于读取yaml、json格式的文件，所在模块ansible.parsing.dataloader
from ansible.vars.manager import VariableManager  #用于存储各类变量信息
from ansible.inventory.manager import InventoryManager #用于导入inventory文件
from ansible.inventory.host import Host #操作单个主机或者主机组信息
from ansible.inventory.group import Group
from ansible.playbook.play import Play  #用于存储执行hosts的角色信息，所在模块ansible.playbook.play
from ansible.executor.task_queue_manager import TaskQueueManager #ansible底层用到的任务队列
from ansible.plugins.callback import CallbackBase #状态回调，各种成功失败的状态
from ansible.executor.playbook_executor import PlaybookExecutor #核心类执行playbook副本

2.InventoryManager
管理主机、主机组信息

（1）添加主机到指定主机组 add_host()
（2）查看主机组资源 get_groups_dict()
（3）获取指定的主机对象 get_host()


3.VariableManager
（1）查看变量方法 get_vars()
（2）设置或修改主机变量方法 set_host_variable()
（3）添加扩展变量 extra_vars 这不是方法，是对象的属性


4.ad-hoc模式调用
ansible -m command -a "ls /tmp" testgroup -i /etc/ansible/hosts -f 5
        --------------------------------- --------------------- ----
                  执行对象和模块              资源资产配置清单     执行选项

资源资产配置清单            执行选项      执行对象和模块
InventoryManager         Options()         Play()
      ↓                     ↓               ↓
VariableManager             ↓               ↓
      ↓                     ↓               ↓
                 最后通过TaskQueueManager()执行


5.playbook模式调用
ansible-playbook webserver.yml -i /etc/ansible/hosts -f 5
                 ------------- --------------------- ----
                   剧本文件       资源资产配置清单      执行选项

资源资产配置清单            执行选项
InventoryManager         Options()
      ↓                     ↓
VariableManager             ↓
      ↓                     ↓
     最后通过PlaybookExecutor()执行

6.callback改写
（1）通过子类继承父类(callbackbase)
（2）通过子类改写父类的部分方法
    v2_runner_on_unreachable
    v2_runner_on_ok
    v2_runner_on_failed

7.自动化任务接口设计
    对ansible的核心类功能进行封装，提供API接口给前端
    URL层：Flask url路由实现请求url跳转
    util层: ansible实现ad-hoc、playbook功能封装

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
