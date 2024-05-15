# 異質使用者密度分布應用環境下最大化滿足率之無人機佈署演算法
本 repository 包含 SPIRAL+、逆時針螺旋、kmeans、隨機、voronoi 五種部署演算法及各項指標分析的 matlab 檔，以及一個使用 matlabengine 串接的模擬器。 

## 執行環境
無論是要執行 matlab 或是模擬器，請確保 matlab 已安裝，且版本高於 R2023a 。

## 模擬器啟動
模擬器使用`Python`撰寫，使用方式如下：

1. 請確認是否安裝 Python
    ```
    python --version
    ```

2. Python 安裝依賴套件
    ```
    pip install Flask
    pip install matlabengine 
    ```

3. 啟動後端
   ```
   python ./emulator.py
   ```

5. 啟動瀏覽器 [http://localhost:8088](http://localhost:8088)

## 模擬器開發模式
模擬器開發模式使用`Python`及`Node.js`撰寫，使用`Next.js 14.0.4`框架與`NextUI`套件，使用方式如下：

1. 請確認是否安裝 Python 及 Node.js
    ```
    node --version
    python --version
    ```
    > **Note**:
    > Next.js 14 要求 Node.js 版本要高於 18.17

2. Python 安裝依賴套件
    ```
    pip install Flask
    pip install Flask-Cors
    pip install matlabengine
    ```

3. Next.js 安裝依賴套件
    ```
    npm install
    ```

4. 將`emulator.py`裡，解除CORS相關的註解
    ```python
    import matlab.engine
    import os
    import json
    from flask import Flask, request, jsonify, send_from_directory
    # from flask_cors import CORS

    app = Flask(__name__, static_url_path="/static")
    eng = matlab.engine.start_matlab()
    eng.cd(os.path.abspath("./matlab"), nargout=0)
    port = 8088
    # CORS(app)
    ```
    ```python
    import matlab.engine
    import os
    import json
    from flask import Flask, request, jsonify, send_from_directory
    from flask_cors import CORS

    app = Flask(__name__, static_url_path="/static")
    eng = matlab.engine.start_matlab()
    eng.cd(os.path.abspath("./matlab"), nargout=0)
    port = 8088
    CORS(app)
    ```

6. 啟動後端
   ```
   python ./emulator.py
   ```

7. 啟動前端
   ```
   cd ./emulator/
   npm run dev
   ```

8. 啟動瀏覽器 [http://localhost:3000](http://localhost:3000)


## 模擬器演示
執行前
![模擬器1](https://github.com/PMinn/Deployment-of-UAV-BSs/blob/main/images/1.jpeg?raw=true)
![模擬器2](https://github.com/PMinn/Deployment-of-UAV-BSs/blob/main/images/2.jpeg?raw=true)
執行後
![模擬器3](https://github.com/PMinn/Deployment-of-UAV-BSs/blob/main/images/3.jpeg?raw=true)
![模擬器4](https://github.com/PMinn/Deployment-of-UAV-BSs/blob/main/images/4.jpeg?raw=true)