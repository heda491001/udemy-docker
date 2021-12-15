# 参考文档
# Dockerfile healthcheck https://docs.docker.com/engine/reference/builder/#healthcheck
# docker compose https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck

# 健康检查是容器运行状态的高级检查，
# 主要是检查容器内运行的进程是否能正常的对外提供服务
# docker本身也自带健康检查功能，可以在docker run时使用下边的参数
    # --health-cmd string              Command to run to check health
    # --health-interval duration       Time between running the check(ms|s|m|h) (default 0s)
    # --health-retries int             Consecutive failures needed to report unhealthy
    # --health-start-period duration   Start period for the container to initialize before starting 
    #                                  health-retries countdown(ms|s|m|h) (default 0s)
    # --health-timeout duration        Maximum time to allow one check to
# 或者是像本节的例子中一样，在dockerfile中进行定义。

docker image build -t flask-demo ./flask
# 结果略
echo ------------------------------------------------------------

docker network create mybridge
# 结果略
    # 构建一个network供flask和redis使用
echo ------------------------------------------------------------

docker container run -d --network mybridge --name flask --env REDIS_PASS=abc123 flask-demo
    
echo ------------------------------------------------------------

sleep 10
docker container ls -f name=flask  --format '{{.Status}}'
# Up 10 seconds (health: starting)
docker inspect -f '{{json .State.Health}}' flask
# {"Status":"starting","FailingStreak":2,"Log":[{"Start":"2021-12-15T16:08:18.7944519Z","End":"2021-12-15T16:08:21.7952414Z","ExitCode":-1,"Output":"Health check exceeded timeout (3s)"},{"Start":"2021-12-15T16:08:22.8032638Z","End":"2021-12-15T16:08:25.8040782Z","ExitCode":-1,"Output":"Health check exceeded timeout (3s)"}]}
    # 虽然flask的容器是起来了
    # 但是并没有构建所使用的redis，
    # 因此健康检查一直为失败
echo ------------------------------------------------------------
docker container run -d --network mybridge --name redis redis:latest redis-server --requirepass abc123
    # 启动一个redis服务供flask使用
sleep 3;docker container ls -f name=flask  --format '{{.Status}}'
# Up 14 seconds (healthy)
    # 再次查看状态，OK
echo ------------------------------------------------------------

read -p "clean up ? [y/n]:" flag
case $flag in
    [yY])
        ./clean.sh ;;
    *)
        ;;
esac