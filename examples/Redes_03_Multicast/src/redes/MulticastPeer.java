package redes;

import java.net.*;
import java.io.*;

public class MulticastPeer {
	public static void main(String args[]) throws IOException {
		
		// args  provê o conteúdo da mensagem e o endereço  do grupo multicast (p. ex. "228.5.6.7")
		
		int port = 6789;
		MulticastSocket mSocket = null;
		InetAddress groupIp = null;
		InetSocketAddress group = null;
		
		try {
			groupIp = InetAddress.getByName(args[1]);
            group = new InetSocketAddress(groupIp, port);
			
			mSocket = new MulticastSocket(6789);
			mSocket.joinGroup(group, null);
			System.out.println("Entrou do grupo multicast " + args[1]);
			
			byte[] message = args[0].getBytes();
			DatagramPacket messageOut = new DatagramPacket(message, message.length, groupIp, 6789);
			mSocket.send(messageOut);
			byte[] buffer = new byte[1000];
			while (true) {
				DatagramPacket messageIn = new DatagramPacket(buffer, buffer.length);
				mSocket.receive(messageIn);
				System.out.println("Recebido:" + new String(messageIn.getData()).trim());
				buffer = new byte[1000];
			}
		} catch (SocketException e) {
			System.out.println("Socket: " + e.getMessage());
		} catch (IOException e) {
			System.out.println("IO: " + e.getMessage());
		} finally {
			mSocket.leaveGroup(group, null);
			if (mSocket != null)
				mSocket.close();
		}
	}

}
