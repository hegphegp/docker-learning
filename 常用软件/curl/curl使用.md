# curl的使用

* [form-data的请求格式](#form-data的请求格式)

##### form-data的请求格式
```
# multipart/form-data不带文件的上传命令
curl -X POST http://192.168.4.11/member/signIn --data "username=root&password=admin"
# multipart/form-data带文件的上传命令
curl -X POST http://localhost:8988/v1/upload -H "accept: application/json" -H "Content-Type: multipart/form-data" -F "file=@/var/server/backup-back/respone.txt" -F username=root -F password=admin
```