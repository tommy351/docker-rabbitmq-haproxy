#!/bin/sh

set -e

# Add cookie
cookie_path=/var/lib/rabbitmq/.erlang.cookie

echo "ERLANGCOOKIE" > $cookie_path
chmod 400 $cookie_path
chown rabbitmq:rabbitmq $cookie_path

# Initialize configs
for p in 5673 5674
do
  echo "
[program:rabbitmq-$p]
command=rabbitmq-server
environment=RABBITMQ_NODENAME=\"rabbit-$p@localhost\",RABBITMQ_NODE_PORT=\"$p\"
autorestart=unexpected
startsecs=5
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
" >> /supervisord.conf
done

# Start supervisor
supervisord
