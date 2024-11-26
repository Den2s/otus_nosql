

# Запускаем контейнеры
docker run -d `
  --name postgres_otus `
  -p 5444:5432 `
  -v C:\\docker_store/postgresql4/data:/var/lib/postgresql/data `
  -e POSTGRES_PASSWORD=123qwe `
  -e POSTGRES_USER=app `
  -e POSTGRES_DB=otus  `
  postgres:16

cd "C:\git\otus_nosql\Neo4j, часть 1\"
# docker exec -it postgres_otus bash 
docker cp postgres.sql postgres_otus:/tmp/ 
docker exec -it postgres_otus psql -h 127.0.0.1 -U app -d otus -f /tmp/postgres.sql


docker pull neo4j
docker run -p 5474:7474 -p 5687:7687 -e NEO4J_AUTH=neo4j/s3cr3t3r neo4j
# then open http://localhost:5474 to connect with Neo4j Browser



docker stop postgres_otus
docker rm postgres_otus
rm -Path C:\docker_store\postgresql4 -Recurse -Force