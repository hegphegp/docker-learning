#

```
# 官方Dockerfile的文件     https://github.com/jgm/pandoc/blob/master/linux/Dockerfile
docker run -itd --restart always --name pandoc -v $(pwd)/:/input/:ro vbatts/pandoc:1.17.0.3-2.fc25.x86_64 sh

## 命令格式 pandoc -f [markdown] -t [docx] -o [output path] [source file path]
pandoc -f markdown -t docx -o /output/docs.docx /input/README.md
Input formats: docbook, docx, epub, haddock, html, json, latex, markdown,
               markdown_github, markdown_mmd, markdown_phpextra,
               markdown_strict, mediawiki, native, opml, org, rst, t2t,
               textile, twiki
Output formats: asciidoc, beamer, context, docbook, docx, dokuwiki, dzslides,
               epub, epub3, fb2, haddock, html, html5, icml, json, latex, man,
               markdown, markdown_github, markdown_mmd, markdown_phpextra,
               markdown_strict, mediawiki, native, odt, opendocument, opml,
               org, pdf*, plain, revealjs, rst, rtf, s5, slideous, slidy, texinfo, textile
               [*for pdf output, use latex or beamer and -o FILENAME.pdf]

docker run -itd \
        --name pandoc \
        -v $(pwd)/:/input/:ro \
        vbatts/pandoc:1.17.0.3-2.fc25.x86_64 sh

# 因为markdown语法引用的图片都是相对路径的，所以一定要进入容器的目录执行命令
docker exec -it pandoc sh
cd /input
mkdir -p output
pandoc -f markdown -t docx -o output/docs.docx README.md
```