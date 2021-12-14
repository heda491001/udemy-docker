docker build -t net-box:demo .
echo ------------------------------------------------------------

docker-compose up -d
# Creating network "8-70-network-2_my-net-work-1" with the default driver
# Creating network "8-70-network-2_my-net-work-2" with driver "bridge"
# Creating 8-70-network-2_box1_1 ... done
# Creating 8-70-network-2_box2_1 ... done
    # 这里net-work-1里没有声明,所以my-net-work-1将使用默认dirver

echo ------------------------------------------------------------

docker network ls
# NETWORK ID     NAME                           DRIVER    SCOPE
# 3738646b24cd   8-70-network-2_my-net-work-1   bridge    local
# aa0ac8aa4232   8-70-network-2_my-net-work-2   bridge    local
# c88d71a260b2   bridge                         bridge    local
# 778d62a8fce7   host                           host      local
# 594694aab4e3   none                           null      local
    # 默认driver的设定是跟我们执行docker容器的host相关
    #     现在这种本机执行docker默认就是bridge,
    #     下一节会讲到docker swarm,将会有所不同

echo ------------------------------------------------------------

docker network inspect 8-70-network-2_my-net-work-1
# [
#     {
#         "Name": "8-70-network-2_my-net-work-1",
#         "Id": "3738646b24cd52c631db6dfec6218708b911dcbecd66fb7644ab0e8d40955683",
#         "Created": "2021-12-14T09:09:30.8888623Z",
#         "Scope": "local",
#         "Driver": "bridge",
#         "EnableIPv6": false,
#         "IPAM": {
#             "Driver": "default",
#             "Options": null,
#             "Config": [
#                 {
#                     "Subnet": "172.26.0.0/16",
#                     "Gateway": "172.26.0.1"
#                 }
#             ]
#         },
#         "Internal": false,
#         "Attachable": true,
#         "Ingress": false,
#         "ConfigFrom": {
#             "Network": ""
#         },
#         "ConfigOnly": false,
#         "Containers": {
#             "6d4ba1ddb487ff0170c11d1ce4ad482dc9d8033ad83b99fdba16feb701f0d21c": {
#                 "Name": "8-70-network-2_box1_1",
#                 "EndpointID": "85b2d398bb29c559ad887f224e23497c099fbe56d259a1537ea2d60fcc645019",
#                 "MacAddress": "02:42:ac:1a:00:02",
#                 "IPv4Address": "172.26.0.2/16",
#                 "IPv6Address": ""
#             },
#             "9764cb85693810231c815bc18952975c3553e29631de80adc9a187f7a41220d8": {
#                 "Name": "8-70-network-2_box2_1",
#                 "EndpointID": "32f23d01e84a6c9dcf581fd86a2bd0dcfc7f4ced56149a96e35bb5eb941b08d8",
#                 "MacAddress": "02:42:ac:1a:00:03",
#                 "IPv4Address": "172.26.0.3/16",
#                 "IPv6Address": ""
#             }
#         },
#         "Options": {},
#         "Labels": {
#             "com.docker.compose.network": "my-net-work-1",
#             "com.docker.compose.project": "8-70-network-2",
#             "com.docker.compose.version": "1.29.2"
#         }
#     }
# ]
echo ------------------------------------------------------------

docker network inspect 8-70-network-2_my-net-work-2
# [
#     {
#         "Name": "8-70-network-2_my-net-work-2",
#         "Id": "aa0ac8aa42324af828e60d11872b38682e864e5a452f9bb0313befd0c2225a66",
#         "Created": "2021-12-14T09:09:31.5859053Z",
#         "Scope": "local",
#         "Driver": "bridge",
#         "EnableIPv6": false,
#         "IPAM": {
#             "Driver": "default",
#             "Options": null,
#             "Config": [
#                 {
#                     "Subnet": "172.28.0.0/24",
#                     "Gateway": "172.28.0.1"
#                 }
#             ]
#         },
#         "Internal": false,
#         "Attachable": true,
#         "Ingress": false,
#         "ConfigFrom": {
#             "Network": ""
#         },
#         "ConfigOnly": false,
#         "Containers": {
#             "9764cb85693810231c815bc18952975c3553e29631de80adc9a187f7a41220d8": {
#                 "Name": "8-70-network-2_box2_1",
#                 "EndpointID": "dbe57a40bbe398c9225bca9d6f1096a5be211a1d198f11a3ecf5b099c94fe4b0",
#                 "MacAddress": "02:42:ac:1c:00:02",
#                 "IPv4Address": "172.28.0.2/24",
#                 "IPv6Address": ""
#             }
#         },
#         "Options": {},
#         "Labels": {
#             "com.docker.compose.network": "my-net-work-2",
#             "com.docker.compose.project": "8-70-network-2",
#             "com.docker.compose.version": "1.29.2"
#         }
#     }
# ]