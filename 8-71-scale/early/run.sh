docker-compose pull
    # 结果略
echo ------------------------------------------------------------

docker-compose build
    # 结果略

echo ------------------------------------------------------------

docker-compose up -d
# Creating early_flask_1        ... done
# Creating early_redis-server_1 ... done
# Creating early_client_1       ... done

echo ------------------------------------------------------------

docker-compose ps
#         Name                      Command               State    Ports  
# ------------------------------------------------------------------------
# early_client_1         sh -c while true; do sleep ...   Up
# early_flask_1          flask run -h 0.0.0.0             Up      5000/tcp
# early_redis-server_1   docker-entrypoint.sh redis ...   Up      6379/tcp

echo ------------------------------------------------------------

docker-compose up -d --scale flask=3
# early_redis-server_1 is up-to-date
# early_client_1 is up-to-date
# Creating early_flask_2 ... done
# Creating early_flask_3 ... done

    # 想要水平扩展进程并不难
    # 上面这样，使用up --scale [要扩展的service名]=[扩展数]
    # 这样我们就启动了3个flask的进程 early_flask_1 ..2 ..3

echo ------------------------------------------------------------

for i in `seq 1 10`
do
    docker container exec early_client_1 curl -s flask:5000
done
# times:1 - hostname:945f25c08232. 
# times:2 - hostname:db85b83d4fdb. 
# times:3 - hostname:db85b83d4fdb. 
# times:4 - hostname:945f25c08232. 
# times:5 - hostname:9dea3cd44357. 
# times:6 - hostname:db85b83d4fdb. 
# times:7 - hostname:945f25c08232. 
# times:8 - hostname:db85b83d4fdb. 
# times:9 - hostname:945f25c08232. 
# times:10 - hostname:db85b83d4fdb.

    # 上节提到，compose会自动登录一个基于service名的DNS
    # 其实不仅如此，如上curl结果所示，实际还提供了一个简单的负载均衡

echo ------------------------------------------------------------

docker-compose up -d --scale flask=1
# Stopping and removing early_flask_2 ... 
# Stopping and removing early_flask_3 ...
# Stopping and removing early_flask_2 ... done
# Stopping and removing early_flask_3 ... done

echo ------------------------------------------------------------

read -p "clean up ? [y/n]:" flag
case $flag in
    [yY])
        ./clean.sh ;;
    *)
        ;;
esac


