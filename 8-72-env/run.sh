docker-compose pull
echo ------------------------------------------------------------
docker-compose build
echo ------------------------------------------------------------
docker-compose up -d
echo ------------------------------------------------------------
docker-compose ps
echo ------------------------------------------------------------
docker-compose config
# networks:
#   ...
# services:
#   flask:
#     ...
#     environment:
#       REDIS_HOST: redis-server
#       REDIS_PASS: ABC123
#     ...
#   nginx:
#     ...
#   redis-server:
#     command: redis-server --requirepass ABC123
#     ...
# version: '3.8'

    # 实际上这个命令在up和build等之前也可执行
    # 结果是让我们可以预览到环境变量赋值到docker-compose.yml文件中后的结果
echo ------------------------------------------------------------
for i in `seq 1 10` ; do curl -s localhost:8000 ;done ;

# Hello Container World! I have been seen 1 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 2 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 3 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 4 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 5 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 6 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 7 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 8 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 9 times and my hostname is c6d561376502.
# Hello Container World! I have been seen 10 times and my hostname is c6d561376502.
    # 请求成功，flask的app顺利接上了redis的db

echo ------------------------------------------------------------

read -p "clean up ? [y/n]:" flag
case $flag in
    [yY])
        ./clean.sh ;;
    *)
        ;;
esac


