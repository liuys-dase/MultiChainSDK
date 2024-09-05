#!/bin/bash

# Get all container IDs created using hyperchaincn/solo:v2.0.0
container_ids=$(docker ps -a --filter "ancestor=hyperchaincn/solo:v2.0.0" --format "{{.ID}}")

# Check if any containers are found
if [ -z "$container_ids" ]; then
  echo "No containers found for hyperchaincn/solo:v2.0.0."
  exit 0
fi

# Stop the containers
echo "Stopping all containers created using hyperchaincn/solo:v2.0.0..."
docker stop $container_ids

# Remove the containers
echo "Removing all containers created using hyperchaincn/solo:v2.0.0..."
docker rm $container_ids

echo "All related containers have been stopped and removed."