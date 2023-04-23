import socket
import json

UDP_IP = "0.0.0.0"
UDP_PORT = 12345

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

sock.bind((UDP_IP, UDP_PORT))

device_info = {
    "name": "Python UDP Server",
    "ip": socket.gethostbyname(socket.gethostname())
}

print("Listening on {}:{}".format(UDP_IP, UDP_PORT))

while True:
    print("Waiting for message")
    data, addr = sock.recvfrom(1024)
    print("Received message:", data.decode("utf-8"), "from:", addr)

    response = json.dumps(device_info)
    print("Sending response:", response)
    sock.sendto(response.encode("utf-8"), addr)  # Send the response to the address it received the message from

