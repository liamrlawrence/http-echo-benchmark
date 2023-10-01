#!/bin/bash


# Setup
BENCHMARKS=("python-flask" "rust-axum" "go-chi")
NUM_REQUESTS=10000
CONCURRENCY=100

URL="172.20.0.200"
PORT=":2000"
ENDPOINT="/api/echo"
BODY='{"strings": "Hello, World!", "ints": -1, "floats": 3.14, "bools": {"t": true, "f": false}, "nil": null}'


DATE=$(date "+%Y-%b-%d_%H%M%S")
mkdir -p benchmarks/${DATE}
echo $BODY > .body.json
sudo docker network create --gateway 172.20.0.1 --subnet 172.20.0.1/16 benchmark-net > /dev/null



# Run the benchmarks
LENGTH=${#BENCHMARKS[@]}
COUNTER=1
for BENCHMARK in "${BENCHMARKS[@]}"; do
    printf "Starting %20s $COUNTER/$LENGTH\n" "$BENCHMARK"
    CONTAINER="benchmark-${BENCHMARK}"
    cd $BENCHMARK

    sudo docker compose build
    sudo docker compose run \
        -d \
        --rm \
        --service-ports \
        --name=${CONTAINER} \
        $CONTAINER > /dev/null
    sleep 1

    ab \
        -n $NUM_REQUESTS \
        -c $CONCURRENCY \
        -p ../.body.json \
        -T 'application/json' \
        http://${URL}${PORT}${ENDPOINT} \
        > ../benchmarks/${DATE}/${BENCHMARK}.log

    sudo docker kill $CONTAINER > /dev/null
    cd ..
    ((COUNTER++))
    printf "\n"
done



# Cleanup
rm .body.json
sudo docker network rm benchmark-net > /dev/null

