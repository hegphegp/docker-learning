#!/bin/bash
set -e

#通过-e环境变量来设置配置文件参数
if [ -z "$MONGODB_URI" ]; then
  echo -e '\033[31m 必须配置MONGODB_URI参数,格式 docker run -itd --name easy-mock -e MONGODB_URI=ip:port/easy-mock -e REDIS_HOST=ip -e REDIS_PORT=port -p 7300:7300 easy-mock:1.5.1 \033[0m'
  exit 2
fi

if [ -z "$REDIS_HOST" ]; then
  echo -e '\033[31m 必须配置REDIS_HOST参数,格式 docker run -itd --name easy-mock -e MONGODB_URI=ip:port/easy-mock -e REDIS_HOST=ip -e REDIS_PORT=port -p 7300:7300 easy-mock:1.5.1 \033[0m'
  exit 2
fi

if [ -z "$REDIS_PORT" ]; then
  echo -e '\033[31m 必须配置REDIS_PORT参数,格式 docker run -itd --name easy-mock -e MONGODB_URI=ip:port/easy-mock -e REDIS_HOST=ip -e REDIS_PORT=port -p 7300:7300 easy-mock:1.5.1 \033[0m'
  exit 2
fi

cd /easy-mock/config/ ;
jq ".db = \"mongodb://$MONGODB_URI\"" production.json > tmp.json && mv tmp.json production.json ;
jq ".redis = { host: \"$REDIS_HOST\", port: $REDIS_PORT }" production.json > tmp.json && mv tmp.json production.json ;

exec "$@"
