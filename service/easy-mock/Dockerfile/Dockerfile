FROM ubuntu:16.04

RUN apt-get update ;\
    apt-get install --no-install-recommends -y wget jq ca-certificates; \
    wget http://cdn.npm.taobao.org/dist/node/v8.4.0/node-v8.4.0-linux-x64.tar.gz; \
    tar -xzvf node-v8.4.0-linux-x64.tar.gz; \
    ln -s /node-v8.4.0-linux-x64/bin/node /usr/local/bin/node; \
    ln -s /node-v8.4.0-linux-x64/bin/npm /usr/local/bin/npm; \
    rm -rf /node-v8.4.0-linux-x64.tar.gz

RUN mkdir /easy-mock ; \
    wget https://github.com/easy-mock/easy-mock/archive/v1.5.1.tar.gz ; \
    tar -xzvf v1.5.1.tar.gz -C /easy-mock --strip-components 1 ; \
    rm -rf v1.5.1.tar.gz ; \
    cd /easy-mock/config ; \
    npm config set registry https://registry.npm.taobao.org; \
    jq '.db = "mongodb://mongodb/easy-mock"' default.json > tmp.json && mv tmp.json default.json ; \
    jq '.redis = { port: 6379, host: "redis" }' default.json > tmp.json && mv tmp.json default.json ; \
    cp default.json production.json

RUN apt-get autoclean && apt-get clean && apt-get autoremove
WORKDIR /easy-mock
RUN npm install -verbose && npm run build
EXPOSE 7300

CMD [ "npm", "start", "-verbose" ]