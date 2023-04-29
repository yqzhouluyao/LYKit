### 介绍：

功能是通过发送广播去发现局域网里面的其他设备，其他设备收到给个回复。



### 如何使用：
1、启动python服务器
python3 udp_server.py

2、在iOS端进行搜索局域网的其他设备


### 存在的问题：
目前在iOS端，发送广播，python服务器接收不到消息，具体原因没找到
[self.udpSocket sendData:data toHost:@"255.255.255.255" port:12345 withTimeout:-1 tag:0];
目前是对指定的Ip进行通信的
[self.udpSocket sendData:data toHost:@"192.168.101.69" port:12345 withTimeout:-1 tag:0];
