# pytorch-docker-for-pycharm
This is pytorch docker-compose repo for pycharm

----
## Installation

### Installation step 1: Docker

### Installation step 2: nvidia toolkit (for gpu usage)

step 2-1 

 `sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common`

step 2-2

 `distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list`

step 2-3

 `sudo apt-get update && sudo apt-get install -y nvidia-container-runtime`

step 2-4

 `sudo nano /etc/docker/daemon.json`
  
 > paste following:
  
 >>  `{
     "default-runtime": "nvidia",
     "runtimes": {
         "nvidia": {
             "path": "/usr/bin/nvidia-container-runtime",
             "runtimeArgs": []
      }
     }
   }`
    
step 2-5: restart docker daemon  
    
`sudo systemctl restart docker.service`
    
step 2-6: check runtime info
    
`docker info | grep Runtime`

----
# How to use

## step 0 (optional): edit **Dockerfile**
If you want to use a different version or library, you can edit the docker file.

## step 1: build docker container

```
docker build -t pytorch-for-pycharm .
```

## step 2: modify docker compose file

> image (eg: pytorch-for-pycharm)
>> You shoud check **image** name in **docker-compose.yml**
>> Image name means docker image tag name 

> service name (eg: pytorch)
>> this name will be appear in step 3-2 (python ineterpreter setting: configure docker-compose)

> environment
>> NVIDIA_VISIBLE_DEVICES=0 means that all graphics cards will be used.


```yaml
version: '2.3'

services:
  pytorch:
    image: pytorch-for-pycharm
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=0
    command: python --version
```


## step 3: pycharm setting 
### step 3-1: docker setting
- open pycharm
- move Preference > Build, Execution, Deploy

<img src=".img/20210223_092604.jpg" width=600 height=400>

### step 3-2: Python Interpreter setting
- add new interpreter

<img src=".img/20210223_093705.jpg" width=600 height=400>

- configure docker-compose
<img src=".img/20210223_104857.jpg" width=600 height=400>
