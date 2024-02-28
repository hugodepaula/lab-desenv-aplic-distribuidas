@echo off

java -Djava.security.policy=rmi.policy ShapeListClient escrever circulo nao
java -Djava.security.policy=rmi.policy ShapeListClient escrever quadrado sim
java -Djava.security.policy=rmi.policy ShapeListClient escrever retangulo sim
java -Djava.security.policy=rmi.policy ShapeListClient escrever linha nao
java -Djava.security.policy=rmi.policy ShapeListClient ler

pause