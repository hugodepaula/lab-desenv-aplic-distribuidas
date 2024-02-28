import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Shape extends Remote {
	int getVersion() throws RemoteException;

	GraphicalObject getAllState() throws RemoteException;
}
