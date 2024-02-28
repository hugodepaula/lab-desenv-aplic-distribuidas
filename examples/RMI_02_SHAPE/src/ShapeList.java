
import java.rmi.*;
import java.util.Vector;

public interface ShapeList extends Remote {

	Shape newShape(GraphicalObject g) throws RemoteException;

	Vector<Shape> allShapes() throws RemoteException;

	int getVersion() throws RemoteException;
}
