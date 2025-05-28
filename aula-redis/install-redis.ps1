docker run -d --name redis -p 6379:6379 redis:latest
docker exec -it redis redis-cli