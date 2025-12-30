#!/bin/bash

case "$1" in
    provision)
        echo "Building and creating containers..."
        docker compose build
        docker compose up --no-start
        echo "Containers created successfully."
        ;;
    
    start)
        echo "Starting containers..."
        docker compose up -d
        echo "Containers started."
        ;;
    
    status)
        echo "Checking container status..."
        docker compose ps
        echo ""
        echo "Container health:"
        docker inspect app --format='App: {{.State.Status}}'
        docker inspect monitor --format='Monitor: {{.State.Status}}'
        ;;
    
    monitor)
        echo "Connecting to monitor logs..."
        docker compose logs -f monitor
        ;;
    
    stop)
        echo "Stopping containers..."
        docker compose stop
        echo "Containers stopped."
        ;;
    
    teardown)
        echo "Destroying containers and images..."
        docker compose down --rmi all
        echo "Teardown complete."
        ;;
    
    *)
        echo "Usage: $0 {provision|start|status|monitor|stop|teardown}"
        exit 1
        ;;
esac
