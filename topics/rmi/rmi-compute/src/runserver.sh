#!/bin/bash
java -cp /home/pucminas/Dev/COMP \
     -Djava.rmi.server.codebase=http://192.168.0.64:8000/Dev/COMP/compute.jar \
     -Djava.rmi.server.hostname=192.168.0.64 \
     -Djava.security.policy=server.policy \
        ComputeEngine
