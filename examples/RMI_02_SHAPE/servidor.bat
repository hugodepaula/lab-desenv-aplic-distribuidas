@echo off

java -Djava.security.policy=rmi.policy -Djava.rmi.server.hostname=localhost ShapeListServer
