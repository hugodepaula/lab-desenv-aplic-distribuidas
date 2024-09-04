package br.ldamd.remote;

import java.awt.Rectangle;
import java.awt.Color;
import java.awt.Graphics;
import java.io.Serializable;

public class GraphicalObject implements Serializable {
	private static final long serialVersionUID = 280214445536057525L;
	public String type; // linha, circulo, quadrado, retangulo
	public Rectangle enclosing; // x, y, width, height
	public Color line;
	public Color fill;
	public boolean isFilled;

	public GraphicalObject() {
	}

	public GraphicalObject(String aType, Rectangle anEnclosing, Color aLine, Color aFill, boolean anIsFilled) {
		type = aType;
		enclosing = anEnclosing;
		line = aLine;
		fill = aFill;
		isFilled = anIsFilled;
	}

	public void print() {
		System.out.print(type + " - ");
		System.out.print(enclosing.x + ", " + enclosing.y + ", " + enclosing.width + ", " + enclosing.height);
		if (isFilled)
			System.out.println(" - preenchido");
		else
			System.out.println(" - sem preenchimento");
	}
	
	public void paint(Graphics g) {
		
	}
}
