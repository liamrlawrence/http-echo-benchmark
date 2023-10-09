#!/bin/bash


# Setup
BENCHMARKS=("javascript-node" "python-flask" "rust-axum" "go-chi")
NUM_REQUESTS=10000
CONCURRENCY=100

IP="0.0.0.0"
PORT=":2000"
ENDPOINT="/api/echo"
API_URL="http://${IP}${PORT}${ENDPOINT}"
BODY='{"strings": "Hello, World!", "ints": -1, "floats": 3.14, "bools": {"t": true, "f": false}, "nil": null}'


DATE=$(date "+%Y-%b-%d_%H%M%S")
mkdir -p benchmarks/${DATE}
echo $BODY > .body.json



# Run the benchmarks
LENGTH=${#BENCHMARKS[@]}
COUNTER=1
for BENCHMARK in "${BENCHMARKS[@]}"; do
    printf "Starting %20s $COUNTER/$LENGTH\n" "$BENCHMARK"
    CONTAINER="benchmark-${BENCHMARK}"
    cd $BENCHMARK

    sudo docker build -t $CONTAINER .
    sudo docker run \
        -d \
        --rm \
        -p "2000:2000" \
        --name=${CONTAINER} \
        $CONTAINER > /dev/null
    sleep 1

    ab \
        -n $NUM_REQUESTS \
        -c $CONCURRENCY \
        -p ../.body.json \
        -T 'application/json' \
        $API_URL \
        > ../benchmarks/${DATE}/${BENCHMARK}.log


    sudo docker kill $CONTAINER > /dev/null
    cd ..
    ((COUNTER++))
    printf "\n"
done



# Cleanup
rm .body.json
echo "Benchmark completed"

