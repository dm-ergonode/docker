#!/bin/bash

set -e

hostname=$(hostname)
RABBITMQ_NODENAME=${RABBITMQ_NODENAME:-rabbit}

runUntil() {
    startTime=$SECONDS
    until "$@" ; do
        exitCode=$?
        sleep 2
        elapsedTime=$(($SECONDS - $startTime))
        if (( $elapsedTime > ${START_PERIOD:-300} )); then
            exit ${exitCode}
        fi
    done
}

echo $hostname

if [[ "$1" = 'rabbitmq-server' ]] ; then

#    if [[ -z "$CLUSTER_WITH" || "$CLUSTER_WITH" == "$hostname" ]]; then
#        >&2 echo "starting as main server"
#        exec docker-entrypoint.sh "$@"
#    else

        function finish {
            jobs=$(jobs -p)
            if [[ -n ${jobs} ]] ; then
                kill $(jobs -p)
            fi
        }
        trap finish EXIT

        export RABBITMQ_LOGS="/var/log/rabbitmq/rabbitmq.log"
        docker-entrypoint.sh "$@" -detached

        rabbitmqctl stop_app
        echo "Joining to cluster $CLUSTER_WITH"

        set +e
        rabbitmqctl join_cluster ${ENABLE_RAM:+--ram} ${RABBITMQ_NODENAME}@${CLUSTER_WITH}
        set -e
        rabbitmqctl start_app

        tail -f "${RABBITMQ_LOGS}"
    #fi
fi

