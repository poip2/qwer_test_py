# src/nexus_zero/main.py
from fastapi import FastAPI, WebSocket, WebSocketDisconnect

app = FastAPI()


@app.get("/")
def read_root():
    return {"message": "Hello, World! (This is HTTP)"}


# 🚀 这是一个 WebSocket 路由
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    # 1. 握手：接受连接
    await websocket.accept()
    print("New connection established!")

    try:
        # 2. 循环：保持通话状态
        while True:
            # 等待接收客户端发来的消息
            data = await websocket.receive_text()
            print(f"Received: {data}")

            # 发送消息回客户端
            await websocket.send_text(f"Server says: You sent '{data}'")

    except WebSocketDisconnect:
        print("Connection closed by client")
