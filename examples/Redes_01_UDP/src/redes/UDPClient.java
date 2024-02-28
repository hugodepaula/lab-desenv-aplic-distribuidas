package redes;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;

public class UDPClient {

	public static void main(String args[]) {

		// args fornecem a mensagem e o endereço do servidor.
		DatagramSocket aSocket = null;
		int serverPort = 6789;
		String message;
		
		try {
			aSocket = new DatagramSocket();
			byte[] m = args[0].getBytes();
			InetAddress aHost = InetAddress.getByName(args[1]);
			DatagramPacket request = new DatagramPacket(m, args[0].length(), aHost, serverPort);
			aSocket.send(request);
			
			byte[] buffer = new byte[1000];
			
			DatagramPacket reply = new DatagramPacket(buffer, buffer.length);
			aSocket.receive(reply);
			message = new String(reply.getData()).trim();
			
			System.out.println("Resposta: " + message);
		} catch (SocketException e) {
			System.out.println("Socket: " + e.getMessage());
		} catch (IOException e) {
			System.out.println("IO: " + e.getMessage());
		} finally {
			if (aSocket != null)
				aSocket.close();
		}
	}
}
