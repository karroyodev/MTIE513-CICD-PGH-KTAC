# MTIE513-CICD-PGH-KTAC 
 
[Maestría en Tecnologías De Información Empresarial](http://bajio.delasalle.edu.mx/oferta/oferta5.php?n=6&p=21) de la [Universidad de La Salle Bajio](http://bajio.delasalle.edu.mx/) 

Proyecto Final - Modelos de Arquitecturas Orientadas a Servicios 

## Introducción

Crear una solución de inteligencia de negocios con Kibana, la cual nos proporciona la visualización de datos y de búsqueda para los datos indexados en Elasticsearch; que es un motor de analítica y análisis distribuido para todos los tipos de datos, además de poder obtener información de varias fuentes (En este caso MySQL). 

Para procesar los datos y enviarlos a Elasticsearch se utiliza Logstash, que es una tubería (pipeline) del lado del servidor que permite ingestar datos de múltiples fuentes de manera simultánea para enriquecerlos y transformarlos antes de que se indexen en Elasticsearch. 

Toda estos componentes de la infraestructura se creará a través del uso de contenedores. 

- [x] MySQL 
- [x] Logstash 
- [x] Elasticsearch 
- [x] Kibana 

Dashboard de Kibana para la visualización y gestión de datos: 
> kibana.karroyodev.net

**CONTENIDO** 
1. [ Requisitos previos ](#previos)
    - [ Instalación de Docker Desktop ](#docker-desktop)
    - [ Instalación de Chocolatey ](#choco)
    - [ Instalación de Docker Machine ](#docker-machine)
2. [ Creación de máquina con Docker Machine ](#crear-machine)
3. [ Creación de contenedores ](#crear-contenedores) 
    - [ Instalación de docker-compose ](#docker-compose)
    - [ Clonar repositorio con archivos de configuración ](#clonar)
4. [ Referencia de líneas de comandos ](#ref-comandos) 
5. [ Solución de errores ](#errores) 

<a name="previos"></a> 
## Requisitos previos

1. Deshabilitar **Hyper-V** por medio de *Activar o desactivar las características de Windows*. 
   - En caso de contar con Windows 10 Home, deshabilitar las opciones de *Virtual Machine Platform* y *Windows Hypervisor Platform*. 
   
    ![Hyper-V](https://www.elcegu.com/wp-content/uploads/2019/01/2019-01-31_21-29-55.png)
   
2. Instalar [VirtualBox](https://www.virtualbox.org/wiki/Downloads). 

    [![VirtualBox](https://www.igestweb.es/blog/wp-content/uploads/2017/09/Virtualbox-logo.jpg)](https://www.virtualbox.org/wiki/Downloads)

3. Abrir la consola de **Windows PowerShell**; de preferencia como administrador y ejecutar el siguiente comando: 

    ``` 
    > bcdedit /set hypervisorlaunchtype off 
    ``` 

<a name="docker-desktop"></a> 
### Instalación de Docker Desktop

4. Instalar [Docker Desktop](https://www.docker.com/products/docker-desktop) y posteriormente reiniciar la computadora. 

    [![Docker Desktop](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrQRbJtTXmruUZNgXGDTbXEP2yUV0_cKm_D7l6Ahxi5x-QjOci9KHa32Nie3NyCOnyM70&usqp=CAU)](https://www.virtualbox.org/wiki/Downloads) 

    Nota: Si después de reiniciar aparece la siguiente ventana; no hay que preocuparse, solo de clic en el botón OK y continuar con las instalaciones. 
    
    [![Docker Error](https://user-images.githubusercontent.com/59643335/103649036-13a48000-4f5e-11eb-8154-bce9cfccf31b.png) 

<a name="choco"></a> 
### Instalación de Chocolatey

5. Instalar **Chocolatey** <img src="https://upload.wikimedia.org/wikipedia/commons/b/b0/Chocolatey_icon.png" data-canonical-src="https://gyazo.com/eb5c5741b6a9a16c692170a41a49c858.png" width="28" height="28" /> con **Windows PowerShell** <img src="https://4.bp.blogspot.com/-VnHaVPAfOms/XDepW52T1BI/AAAAAAAAGQo/ZzujNs2KPkEmmtF1Astea01BkZ6RGStswCLcBGAs/s1600/powershell.png" width="28" height="28" /> con los siguientes comandos: 

    ``` 
    > Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 
    ``` 
    
6. Revisar la versión de Chocolatey instalada con el comando: `choco` para visualizar la versión y el comando de ayuda.

<a name="docker-machine"></a> 
### Instalación de Docker Machine

7. Instalar **docker-machine** con **Chocolatey** ejecutar el siguiente comando: 

    ``` 
    > choco install docker-machine 
    ``` 
    
8. Para validar la instalación ejecutar el comando: `docker-machine version`. 

<a name="crear-machine"></a> 
## Creación de máquina con Docker Machine 

1. Para crear la máquina, a la cual llamamos **\*vmmtie\***; se debe ejecutar el siguiente comando: 

    ``` 
    > docker-machine create --driver virtualbox --virtualbox-cpu-count 2 --virtualbox-disk-size 10000 --virtualbox-memory 4096 --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso vmmtie
    ``` 
    
    _--virtualbox-cpu-count: Número de CPU que se utilizarán para crear la máquina virtual._  
    _--virtualbox-disk-size: Tamaño del disco para el host en MB._  
    _--virtualbox-memory: Tamaño de la memoria del host en MB._  
    _--virtualbox-boot2docker-url: URL de la imagen de boot2docker (Última versión disponible)._ 
 
2. Revisar las máquinas disponibles con: `docker-machine ls`. 
3. Para iniciar o detener la máquina. 
    ``` 
    > docker-machine stop NOMBREMV
    > docker-machine start NOMBREMV 
    ``` 
    
<a name="crear-contenedores"></a> 
## Creación de contenedores 

1. Iniciar sesión a la máquina mediante SSH con el comando:  

    ``` 
    > docker-machine ssh NOMBREMV 
    ``` 
2. Configurar variable **vm.max_map_count** dentro del archivo de configuración sysctl para asignar el número máximo de áreas de mapa de memoria que se puede tener en un proceso. Agregar al final del archivo: **vm.max_map_count=2621444**. 

    ``` 
    > sudo vi /etc/sysctl.conf 
    ``` 

 Para volver a cargar la configuración del archivo con el nuevo valor, ejecutar: `sudo sysctl -p`.

3. Al iniciar RancherOS con un archivo de configuración, se puede seleccionar qué consola se quiere utilizar. Para ver el listado de las consolas disponibles en RancherOS se utiliza el comando `sudo ros console list`. Después de identificar la consola a utilizar, se ejecuta el siguiente comando: 

    ``` 
    > sudo ros console switch ubuntu 
    ``` 
    
    _Al finalizar, se va a cerrar la sesión de la máquina y se tendrá que hacer de nuevo el login con ssh._ 
    
<a name="docker-compose"></a> 
### Instalación de docker-compose

4. Instalar docker-compose dentro de docker-machine:

    ``` 
    > sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose 
    > sudo chmod +x /usr/local/bin/docker-compose
    ``` 

<a name="clonar"></a> 
### Clonar repositorio con archivos de configuración 

4. Para ejecutar un Alias Git Temporal para no realizar la instalación. 

    ``` 
    > alias git="docker run -ti --rm -v $(pwd):/git bwits/docker-git-alpine" 
    ``` 
5. Clonar en la máquina el repositorio de este proyecto. 

    ``` 
    git clone https://github.com/karroyodev/MTIE513-CICD-PGH-KTAC.git 
    ``` 
    
6. Crear las carpetas de volumes para Elasticsearch dentro de la carpeta del proyecto y brindar permisos. 

    ``` 
    sudo mkdir -p volumes/elk-stack/elasticsearch 
    cd volumes/elk-stack/ 
    sudo chmod 777 elasticsearch/ 
    ``` 
    ``` 
    sudo mkdir -p volumes/elk-stack/elasticsearch && cd volumes/elk-stack/ && sudo chmod 777 elasticsearch/ 
    ``` 
    Revisar que los permisos se hayan concedido con `ls -l`.
    
7. Entrar a la carpeta creada al clonar el repositorio. Crear los contenedores con el archivo YAML llamado **\*docker-compose\***. 
    
    ``` 
    sudo docker-compose up --build -d 
    ``` 

<a name="ref-comandos"></a> 
## Referencia de líneas de comandos 

Comando                             | Descripción
------------                        | -------------
docker-machine ls                   | Listado de máquinas con estado, dirección y versión de Docker 
docker-machine start                | Inicia la máquina llamada default, en caso de existir
docker-machine stop                 | Detiene la máquina llamada default, en caso de existir
docker-machine start NOMBREMV       | Inicia la máquina indicada
docker-machine stop NOMBREMV        | Detiene la máquina indicada
docker-machine restart NOMBREMV     | Reiniciar la máquina
docker-machine kill NOMBREMV        | Forza a que la máquina se detenga abruptamente
docker-machine status NOMBREMV      | Obtierne el estado de la máquina
docker-machine ip NOMBREMV          | Obtierne la dirección IP de la máquina 
docker-machine rm NOMBREMV          | Eliminar la máquina creada
docker-machine ssh NOMBREMV         | Iniciar sesión a la máquina por SSH 
docker ps                           | Listado de los contenedores que están corriendo 
docker ps -a                        | Listado de todos los contenedores 
docker start CONTENEDOR             | Inicializa el contenedor
docker stop CONTENEDOR              | Detiene el contenedor
docker restart CONTENEDOR           | Reinicia el contenedor
docker pause CONTENEDOR             | Suspende todos los procesos del contenedor especificados 
docker unpause CONTENEDOR           | Reanuda todos los procesos dentro del contenedor
docker kill CONTENEDOR              | Envía una señal SIGKILL al contenedor
docker logs --follow --tail n CONTENEDOR | Muestra el número de líneas indicadas del registro de salida (log)
docker stop $(docker ps -a -q)      | Detiene todos los contenedores
docker rm -f $(docker ps -qa)       | Elimina todos los contenedores
docker images                       | Listado de imágenes con su nivel, repositorio, etiquetas y tamaño 
docker image rm IMAGEN              | Elimina la imágen
docker rmi -f $(docker images -a -q) | Eliminar todas las imagenes del repositorio

<a name="errores"></a> 
## Solución de errores 
En caso de que el contenedor de MySQL durante la revisión de los logs muestre el siguiente error: 

> mbind: Operation not permitted 
 
Agregar en el archivo de **\*docker-compose\*** las siguientes líneas: 

``` 
cap_add:
    - SYS_NICE  # CAP_SYS_NICE
``` 

La cual agrega capacidades del contenedor para aumentar el valor de proceso, establecer políticas de programación en tiempo real y afinidad de CPU, entre otras operaciones. 