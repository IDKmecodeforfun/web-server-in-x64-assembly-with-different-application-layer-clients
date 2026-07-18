read -p "number of clients: " NUM_CLIENT

COUNTER=0

while [[ "$COUNTER" -le "$NUM_CLIENT" ]]; do
    echo "==================================================="
    echo "=                curl client                      ="
    echo "==================================================="
    curl -v 0.0.0.0:8080

    COUNTER=$((COUNTER + 1)) 
done

printf "\n\n\n"

COUNTER=0

while [[ "$COUNTER" -le "$NUM_CLIENT" ]]; do
    echo "====================================================="
    echo "=                netcat client                      ="
    echo "====================================================="
    echo "GET / HTTP/1.1" | nc -v 0.0.0.0 8080

    COUNTER=$((COUNTER + 1))
done

