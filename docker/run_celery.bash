#!/bin/bash
set -e
source /etc/profile

# Run the main Celery worker (will not process `sync_kobocat_xforms` jobs).
# Start 2 processes by default; this will be overridden later, in Python code,
# according to the user's preference saved by django-constance
cd "${KPI_SRC_DIR}"

exec celery -A kobo worker --loglevel=info \
    --hostname=kpi_main_worker@%h \
    --logfile=${KPI_LOGS_DIR}/celery.log \
    --pidfile=/tmp/celery.pid \
    --exclude-queues=sync_kobocat_xforms_queue \
    --uid=${UWSGI_USER} \
    --gid=${UWSGI_GROUP} \
    --autoscale 2,2
