docker build -t net-box:demo .
# 没有镜像也会自动build
# [+] Building 8.4s (8/8) FINISHED
#  => [internal] load build definition from Dockerfile                                                                                 0.0s 
#  => => transferring dockerfile: 682B                                                                                                 0.0s 
#  => [internal] load .dockerignore                                                                                                    0.0s 
#  => => transferring context: 2B                                                                                                      0.0s 
#  => [internal] load metadata for docker.io/library/alpine:latest                                                                     8.3s 
#  => [auth] library/alpine:pull token for registry-1.docker.io                                                                        0.0s 
#  => [1/3] FROM docker.io/library/alpine:latest@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300               0.0s 
#  => CACHED [2/3] RUN apk update && apk upgrade &&     apk add --no-cache net-snmp-tools &&     mkdir /var/lib/net-snmp &&     mkdir  0.0s 
#  => CACHED [3/3] WORKDIR /omd                                                                                                        0.0s 
#  => exporting to image                                                                                                               0.0s 
#  => => exporting layers                                                                                                              0.0s 
#  => => writing image sha256:12ab6069e3fb0244111a707255eb57e612bc148dec6ecaf62e5146c4a91df2de                                         0.0s 
#  => => naming to docker.io/library/net-box:demo     

echo ------------------------------------------------------------

docker-compose up -d
# Creating network "8-69-network-1_default" with the default driver
# Starting 8-69-network-1_box2_1 ... done
# Starting 8-69-network-1_box1_1 ... done

    # 这里可以看到，纵使network并没有任何声明
    # docker-compose默认的自动创建了一个名为8-69-network-1_default的网络
        # 默认网络名为[projectName]_default

echo ------------------------------------------------------------

docker container ls 
# CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                  PORTS     NAMES
# e63f0f80c930   net-box:demo   "/bin/sh -c 'while t…"   2 seconds ago   Up Less than a second             8-69-network-1_box2_1
# 17b183e8f031   net-box:demo   "/bin/sh -c 'while t…"   2 seconds ago   Up Less than a second             8-69-network-1_box1_1

echo ------------------------------------------------------------

docker network ls 
# NETWORK ID     NAME                     DRIVER    SCOPE
# fd5c05dc0a02   8-69-network-1_default   bridge    local
# c88d71a260b2   bridge                   bridge    local
# 778d62a8fce7   host                     host      local
# 594694aab4e3   none                     null      local

    # 默认创建的网络是bridge类型

echo ------------------------------------------------------------

docker network inspect 8-69-network-1_default
# ...
# "Containers": {
#     ...: {
#         "Name": "8-69-network-1_box1_1",
#         ...
#     },
#     ...: {
#         "Name": "8-69-network-1_box2_1",
#         ...
#     }
# },
# ...

    # 默认bridge自动添加所有的services

echo ------------------------------------------------------------

docker container exec 8-69-network-1_box1_1 ping 8-69-network-1_box2_1 -c 5
# PING 8-69-network-1_box2_1 (172.18.0.2): 56 data bytes
# 64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.242 ms
# 64 bytes from 172.18.0.2: seq=1 ttl=64 time=0.148 ms
# 64 bytes from 172.18.0.2: seq=2 ttl=64 time=0.049 ms
# 64 bytes from 172.18.0.2: seq=3 ttl=64 time=0.054 ms
# 64 bytes from 172.18.0.2: seq=4 ttl=64 time=0.050 ms

# --- 8-69-network-1_box2_1 ping statistics ---
# 5 packets transmitted, 5 packets received, 0% packet loss
# round-trip min/avg/max = 0.049/0.108/0.242 ms

    # 之前也提过
    # docker的bridge网络，提供了一个基于容器名字的DNS
    # 从box1来ping box2的容器名字，没有问题

echo ------------------------------------------------------------

docker container exec 8-69-network-1_box1_1 ping box1 -c 5
# PING box1 (172.18.0.3): 56 data bytes
# 64 bytes from 172.18.0.3: seq=0 ttl=64 time=0.037 ms
# 64 bytes from 172.18.0.3: seq=1 ttl=64 time=0.040 ms
# 64 bytes from 172.18.0.3: seq=2 ttl=64 time=0.037 ms
# 64 bytes from 172.18.0.3: seq=3 ttl=64 time=0.038 ms
# 64 bytes from 172.18.0.3: seq=4 ttl=64 time=0.039 ms

# --- box1 ping statistics ---
# 5 packets transmitted, 5 packets received, 0% packet loss
# round-trip min/avg/max = 0.037/0.038/0.040 ms

echo --------------------------------------

docker container exec 8-69-network-1_box1_1 ping box2 -c 5
# PING box2 (172.18.0.2): 56 data bytes
# 64 bytes from 172.18.0.2: seq=0 ttl=64 time=0.077 ms
# 64 bytes from 172.18.0.2: seq=1 ttl=64 time=0.100 ms
# 64 bytes from 172.18.0.2: seq=2 ttl=64 time=0.048 ms
# 64 bytes from 172.18.0.2: seq=3 ttl=64 time=0.146 ms
# 64 bytes from 172.18.0.2: seq=4 ttl=64 time=0.050 ms

# --- box2 ping statistics ---
# 5 packets transmitted, 5 packets received, 0% packet loss
# round-trip min/avg/max = 0.048/0.084/0.146 ms

    # docker-compose的除了容器名DNS以外，
    # 还登录了一个基于docker-compose.yml中service名的DNS
    # 不论是ping box1 还是 box2 都没有问题
    
    # 当然这在我们本地是无法ping通这两个地址的
    # 实际上docker在运行容器时,后台提供了一个DNS server
    # 我们可以使用如下的命令来看这个DNSserver在Docker网络中的ip
echo ------------------------------------------------------------

docker container exec 8-69-network-1_box1_1 dig box2
# ; <<>> DiG 9.16.22 <<>> box2
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 56621
# ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

# ;; QUESTION SECTION:
# ;box2.                          IN      A

# ;; ANSWER SECTION:
# box2.                   600     IN      A       172.18.0.2

# ;; Query time: 0 msec
# ;; SERVER: 127.0.0.11#53(127.0.0.11)
# ;; WHEN: Tue Dec 14 08:04:45 UTC 2021
# ;; MSG SIZE  rcvd: 42

echo ------------------------------------------------------------

docker container exec 8-69-network-1_box1_1 cat /etc/resolv.conf
# nameserver 127.0.0.11
# options ndots:0

