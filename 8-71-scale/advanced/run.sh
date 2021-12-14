docker-compose pull
    # 结果略
echo ------------------------------------------------------------

docker-compose build
    # 结果略

echo ------------------------------------------------------------

docker-compose up -d
# Creating advanced_flask_1        ... done
# Creating advanced_redis-server_1 ... done
# Creating advanced_nginx_1        ... done

echo ------------------------------------------------------------

docker-compose ps
#          Name                        Command               State          Ports        
# ---------------------------------------------------------------------------------------
# advanced_flask_1          flask run -h 0.0.0.0             Up      5000/tcp
# advanced_nginx_1          /docker-entrypoint.sh ngin ...   Up      0.0.0.0:8000->80/tcp
# advanced_redis-server_1   docker-entrypoint.sh redis ...   Up      6379/tcp

echo ------------------------------------------------------------

for i in `seq 1 10`
do
    curl -s localhost:8000
done

# times:1 - hostname:df5ed4a3eed1. 
# times:2 - hostname:df5ed4a3eed1.
# times:3 - hostname:df5ed4a3eed1. 
# times:4 - hostname:df5ed4a3eed1.
# times:5 - hostname:df5ed4a3eed1. 
# times:6 - hostname:df5ed4a3eed1.
# times:7 - hostname:df5ed4a3eed1. 
# times:8 - hostname:df5ed4a3eed1. 
# times:9 - hostname:df5ed4a3eed1.
# times:10 - hostname:df5ed4a3eed1. 
    # 访问将会是
    #     localhost:8000
    #     转发 -> nginx 80端口
    #         转发 -> flask 5000端口
    
echo ------------------------------------------------------------

docker-compose up -d --scale flask=3
docker-compose ps
# advanced_redis-server_1 is up-to-date
# Creating advanced_flask_2 ... done
# Creating advanced_flask_3 ... done
# advanced_nginx_1 is up-to-date
#          Name                        Command               State          Ports        
# ---------------------------------------------------------------------------------------
# advanced_flask_1          flask run -h 0.0.0.0             Up      5000/tcp
# advanced_flask_2          flask run -h 0.0.0.0             Up      5000/tcp
# advanced_flask_3          flask run -h 0.0.0.0             Up      5000/tcp
# advanced_nginx_1          /docker-entrypoint.sh ngin ...   Up      0.0.0.0:8000->80/tcp
# advanced_redis-server_1   docker-entrypoint.sh redis ...   Up      6379/tcp

echo ------------------------------------------------------------

docker-compose restart nginx
# Restarting advanced_nginx_1 ... done
    # 注意这里，需要重新启动一下容器。
    # 应该说需要重新启动一下容器内的nginx服务
        # 尝试了下边的命令确实没有问题，可以达到一样的效果
        # docker container exec advanced_nginx_1 nginx -s reload
    # 但在生产实践中，重启容器可能会更加的稳妥，也更加的方便
    # 这里可能还是需要具体分析

echo ------------------------------------------------------------

for i in `seq 1 10`;do curl -s localhost:8000;done;
# times:11 - hostname:24326b19dbc3. 
# times:12 - hostname:cb0e6b8cd69a.
# times:13 - hostname:925626fd46fb. 
# times:14 - hostname:24326b19dbc3.
# times:15 - hostname:cb0e6b8cd69a. 
# times:16 - hostname:925626fd46fb.
# times:17 - hostname:24326b19dbc3. 
# times:18 - hostname:cb0e6b8cd69a.
# times:19 - hostname:925626fd46fb. 
# times:20 - hostname:24326b19dbc3.
    # 负载均衡，发给三个flask容器

echo ------------------------------------------------------------

read -p "clean up ? [y/n]:" flag
case $flag in
    [yY])
        ./clean.sh ;;
    *)
        ;;
esac


