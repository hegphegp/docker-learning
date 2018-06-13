FROM debian:9.4-slim

RUN echo "deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ jessie-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ jessie-backports main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y xmlstarlet && \
    apt-get clean all

CMD ["sh"]
