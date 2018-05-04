# nginx命令


##### 阿里云web页面设置二级域名的步骤
步骤01
![avatar](imgs/阿里云设置二级域名的步骤01.png)
步骤02
![avatar](imgs/阿里云设置二级域名的步骤02.png)

ssl证书(https证书)
```
# docker加了 sh -c 参数后,可以执行多条命令
docker run -itd --name aaa-http -p 8081:80 httpd:2.2.32-alpine sh -c "echo 'aaa.javafly.net' > /usr/local/apache2/htdocs/index.html && httpd-foreground"
docker run -itd --name bbb-http -p 8082:80 httpd:2.2.32-alpine sh -c "echo 'bbb.javafly.net' > /usr/local/apache2/htdocs/index.html && httpd-foreground"
docker run -itd --name ccc-http -p 8083:80 httpd:2.2.32-alpine sh -c "echo 'ccc.javafly.net' > /usr/local/apache2/htdocs/index.html && httpd-foreground"
```