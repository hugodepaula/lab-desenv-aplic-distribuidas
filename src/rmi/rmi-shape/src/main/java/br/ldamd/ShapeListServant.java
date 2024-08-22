package br.ldamd;

import java.rmi.RemoteException;
import java.util.Vector;

public class ShapeListServant implements ShapeList {

	private Vector<Shape> theList;
	private int version;

	public ShapeListServant() throws RemoteException {
		theList = new Vector<Shape>();
		version = 0;
	}

	public Shape newShape(GraphicalObject g) throws RemoteException {
		// deveria haver filtragem de duplicada antes
		// constular no cache, se ja existe returna cache, senao adiciona nova
		version++;
		Shape s = new ShapeServant(g, version);
		theList.addElement(s);
		return s;
	}

	public Vector<Shape> allShapes() throws RemoteException {
		return theList;
	}

	public int getVersion() throws RemoteException {
		return version;
	}
}
