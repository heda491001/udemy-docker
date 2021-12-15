FROM python:3.9.5-slim

RUN pip install flask redis && \
    apt-get update && \
    apt-get install -y curl && \
    groupadd -r flask && useradd -r -g flask flask && \
    mkdir /src && \
    chown -R flask:flask /src

USER flask

COPY app.py /src/app.py

WORKDIR /src

ENV FLASK_APP=app.py REDIS_HOST=redis

EXPOSE 5000

HEALTHCHECK --interval=1s \
            --timeout=3s \
        CMD curl -f http://localhost:5000/ || exit 1
# 像上边这样，定义healthcheck
# --interval => 检查的周期,默认为30s
# --timeout  => 就算没有返回错误，healthcheck的命令
#               没有响应多长时间之后视为error
# CMD        => 执行的HealthCheck命令

CMD ["flask", "run", "-h", "0.0.0.0"]