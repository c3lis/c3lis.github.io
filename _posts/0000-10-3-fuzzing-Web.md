---
title : Fuzzing Web
published : True
---



<div class="contenedor imgc">
    <img class="imgc" src="imgs/FUZZING/FUZZING.jpg" style="width: 169px" alt="FUZZING logo">
    <div> 
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> FUZZING </p>
        
    </div>
</div>

<h2><font color="white"><center># FUZZING</center></font></h2>
<br>

* Enumeración de archivos finalizados en .php .xml .conf

        gobuster -t 100 dir -u http://$target_ip -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -x php,xml,conf

* Enumeración de directorios en web

        wfuzz  --hc=404 -t 200 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u http://$target_ip/FUZZ

* Enumeración de subdominios

        wfuzz -c -f domains -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u "http://$target_ip" -H "Host: FUZZ.ejemplo.com" 

