### keycloak

```
docker run -itd --restart always -e TZ=Asia/Shanghai -v /etc/localtime:/etc/localtime:ro -p 5432:5432 --name postgres -e POSTGRES_USER=keycloak -e POSTGRES_PASSWORD=password postgres:9.6.12

docker run -it --restart always -e TZ=Asia/Shanghai --name keycloak -e DB_VENDOR=POSTGRES -e DB_ADDR=192.168.1.169 -e DB_PORT=5432 -e DB_DATABASE=keycloak -e DB_USER=keycloak -e DB_PASSWORD=password -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=Pa55w0rd -p 8095:8080 jboss/keycloak:4.8.3.Final
```