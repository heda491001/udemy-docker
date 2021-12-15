if [ -e docker-compose.yml ]; then docker-compose stop ; docker-compose rm -f ; fi ;
if [ -n "$(docker container ls -q)" ];then docker container rm -f $(docker container ls -q); fi ;
docker system prune -f
docker volume prune -f