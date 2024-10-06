---
title : Fuzzing Web
published : True
---
* Fuzzing en paginas web.
<br>
<br>
```python
#Enumeración de archivos finalizados en : .php .xml .conf
gobuster -t 100 dir -u http://10.10.254.165 -w /usr/share/wordlists/web-content/directory-list-2.3-medium.txt -x php,xml,conf

#Enumeración de directorios en web:
wfuzz  --hc=404 -t 200 -w /usr/share/wordlists/web-content/directory-list-2.3-medium.txt -u http://10.10.254.165/FUZZ

```
