# ansible use root (Not recommanded)
source ../ansible_api24/venv/bin/activate
export C_FORCE_ROOT=True
export PYTHONOPTIMIZE=1
celery -A celery_work.celery worker --loglevel=info
