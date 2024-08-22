cd C:\Users\Hugo\Dropbox\PUC\Disciplinas\DAMD\Material\DAMD code\Ex04_RMI\src
md ..\client
md ..\server
c:\dev\Java\jdk-9.0.1\bin\javac GraphicalObject.java Shape.java ShapeList.java
c:\dev\Java\jdk-9.0.1\bin\jar cvf shapeserver.jar *.class
copy  shapeserver.jar ..\client
copy  shapeserver.jar ..\server

c:\dev\Java\jdk-9.0.1\bin\javac -cp shapeserver.jar ShapeServant.java ShapeListServer.java ShapeListServant.java
move *.class ..\server
c:\dev\Java\jdk-9.0.1\bin\javac -cp shapeserver.jar ShapeListClient.java
move *.class ..\server


