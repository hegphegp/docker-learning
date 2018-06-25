## 零碎的知识

```
# 压缩当前文件夹
WORKPATH=$PWD && tar -czvf $(basename `pwd`).tar.gz -C $WORKPATH $(ls $WORKPATH)
```