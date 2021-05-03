# MTIE513-CICD-PGH-KTAC
Proyecto Final - Modelos de Arquitecturas Orientadas a Servicios 

## Requisitos previos
### Instalación de Docker Machine en Windows
1. Deshabilitar **Hyper-V** por medio de *Activar o desactivar las características de Windows*. 
   - En caso de contar con Windows 10 Home, deshabilitar las opciones de *Virtual Machine Platform* y *Windows Hypervisor Platform*. 
2. Instalar [VirtualBox](https://www.virtualbox.org/wiki/Downloads). 
3. Abrir la consola de **Windows PowerShell**; de preferencia como administrador y ejecutar el siguiente comando: 
``` 
bcdedit /set hypervisorlaunchtype off 
``` 
4. Instalar [Docker Desktop](https://www.docker.com/products/docker-desktop) y reiniciar. 
5. Instalar **Chocolatey** con **Windows PowerShell** con los siguientes comandos: 
``` 
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 
``` 
6. Revisar la versión de Chocolatey instalada. 
``` 
choco 
``` 
7. Instalar **docker-machine** con **Chocolatey** ejecutar el siguiente comando: 
``` 
choco install docker-machine 
``` 
8. Para validar la instalación ejecutar el comando: 
``` 
docker-machine version 
``` 
### Crea una maquina con docker-machine 
1. Para crear la máquina, a la cual llamamos **\*vmmtie\***; se debe ejecutar el siguiente comando: 
``` 
docker-machine create --driver virtualbox --virtualbox-cpu-count 2 --virtualbox-disk-size 10000 --virtualbox-memory 4096 --virtualbox-boot2docker-url https://releases.rancher.com/os/latest/rancheros.iso vmmtie
``` 
_--virtualbox-cpu-count: Número de CPU que se utilizarán para crear la máquina virtual._ 
_--virtualbox-disk-size: Tamaño del disco para el host en MB._ 
_--virtualbox-memory: Tamaño de la memoria del host en MB._ 
_--virtualbox-boot2docker-url: URL de la imagen de boot2docker (Última versión disponible)._ 
2. Ver el listado de las máquinas disponibles. 
``` 
docker-machine ls 
``` 
3. Para iniciar o detener la máquina. 
``` 
docker-machine stop NOMBRE_MV 
docker-machine start NOMBRE_MV 
``` 
### Instalación de contenedores 
1. Entrar a la máquina creada en la sección anterior. 
``` 
docker-machine ssh NOMBRE_MV 
``` 
2. Configurar variable **vm.max_map_count** dentro del archivo de configuración sysctl. 
``` 
sudo vi /etc/sysctl.conf 
``` 
Agregar al final del archivo: **vm.max_map_count=2621444**. 
Para volver a cargar la configuración del archivo con el nuevo valor, ejecutar:
``` 
sudo sysctl -p 
``` 
3. Para ejecutar un Alias Git Temporal para no realizar la instalación. 
``` 
alias git="docker run -ti --rm -v $(pwd):/git bwits/docker-git-alpine" 
``` 
4. Clonar en la máquina el repositorio de este proyecto. 
``` 
git clone https://github.com/karroyodev/MTIE513-CICD-PGH-KTAC.git 
``` 
5. Crear las carpetas de volumes para Elasticsearch dentro de la carpeta del proyecto y brindar permisos. 
``` 
sudo mkdir -p volumes/elk-stack/elasticsearch 
cd volumes/elk-stack/ 
sudo chmod 777 elasticsearch/ 
``` 
``` 
sudo mkdir -p volumes/elk-stack/elasticsearch && cd volumes/elk-stack/ && sudo chmod 777 elasticsearch/ 
``` 
Revisar que los permisos se hayan concedido con 
``` 
ls -l 
``` 
6. Entrar a la carpeta creada al clonar el repositorio. Crear los contenedores con el archivo YAML llamado **\*docker-compose\***. 
``` 
sudo docker-compose up --build -d 
``` 
### Lista de comandos
Comando | Descripción
------------ | -------------
docker-machine rm * *nombre máquina* * | Eliminar máquina creada
docker ps | Ver en un listado de los contenedores que están corriendo
docker ps -a | Ver en un listado todos los contenedores
docker rm -f $(docker ps -qa) | Eliminar todos los contenedores
docker logs --follow --tail 10 * *nombre contenedor* * | Muestra el número de líneas indicadas del registro de salida
sudo rm -r * *nombre carpeta* * | eliminar carpeta

### Solución de errores 
En caso de que el contenedor de MySQL durante la revisión de los logs muestre el siguiente error: 
> mbind: Operation not permitted 
Agregar en el archivo de **\*docker-compose\*** las siguientes líneas: 
``` 
cap_add:
    - SYS_NICE  # CAP_SYS_NICE
``` 
La cual agrega capacidades del contenedor para aumentar el valor de proceso, establecer políticas de programación en tiempo real y afinidad de CPU, entre otras operaciones. 