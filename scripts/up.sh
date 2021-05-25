# /bin/bash
set -e

docker-compose up -d --build
docker-compose exec lua bash
docker-compose down