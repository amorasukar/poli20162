package servidor;

import java.io.*;
import java.net.*;
import com.thoughtworks.xstream.XStream;
import java.util.List;

public class Cliente extends Thread {
    private Thread thrThis;
    private Socket socket;
    private Servidor server;
    private String ip; 
    protected BufferedReader in;
    protected PrintWriter out;
    
    private int idCliente;

    private static int count = 0;

    //private String nome;
   // private FabricaAbstrata fabrica;
    private Usuario usuario;
    private String estado;
    private boolean frotaDistribuida;

    public Cliente(Servidor server, Socket socket) {
    	this.idCliente = Cliente.count++;
        System.out.println("this.idCliente = " + this.idCliente);
    	
        this.server = server;
        this.socket = socket;
        this.ip = socket.getInetAddress().getHostAddress();
        this.estado = "Livre";
        this.frotaDistribuida = false;

        try {
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            out = new PrintWriter(socket.getOutputStream(), true);
            Mensagem mensagem = new Mensagem();
            mensagem.setTipo("respostaConecta");
            System.out.println("---> this.idCliente = " + this.idCliente);
            mensagem.setIdCliente(this.idCliente);
            this.server.enviarMensagem(mensagem, this);
        } catch(IOException ioe) {
            server.writeActivity("Client IP: " + ip + " não pôde ser inicializado e foi desconectado.");
            killClient();
        }
    }

    public void run() {
        try {
            char charBuffer[] = new char[1];
            
            while(in.read(charBuffer,0,1) != -1) {
                StringBuffer stringBuffer = new StringBuffer(8192);
                while(charBuffer[0] != '\0') {
                    stringBuffer.append(charBuffer[0]);
                    in.read(charBuffer, 0 ,1);
                }
                //System.out.println("recebido = "+stringBuffer.toString());
                this.server.lerMensagem(stringBuffer.toString(), this);
               // server.broadcastMessage(stringBuffer.toString());
            }
        } catch(IOException ioe) {
            server.writeActivity("IP do Cliente: " + ip + " causou um erro de leitura " 
            + ioe + " : " + ioe.getMessage() + "e foi desconectado.");
        } finally {
            killClient();
        }
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    
    public String getIP() {
        return ip;
    }
    
    public int getIdCliente() {
	return this.idCliente;
    }

    public void send(String message) {
        out.print(message);
        
        if(out.checkError()) {
            server.writeActivity("IP do Cliente: " + ip + " causou um erro de escrita "
            + "e foi desconectado.");
            killClient();
        }
    }
   
    private void killClient() {
        server.removeClient(this);
        Mensagem mensagemSaida = new Mensagem();
        mensagemSaida.setTexto( this.getNome() + "," + this.getIdCliente() );
        mensagemSaida.setTipo("eventoSaidaJogador");
        this.server.broadcastMessage(mensagemSaida);

        try {
            in.close();
            out.close();
            socket.close();            
            thrThis = null;
        } catch (IOException ioe) {
            server.writeActivity("IP do Cliente: " + ip + " causou um erro  "
            + "enquanto desconectava.");
        }       
    }

    private void lerMensagem(String msg){
        XStream stream = new XStream();
        List dados = (List) stream.fromXML(msg);
        System.out.println("atributo = ");
    }

    /**
     * @return the nome
     */
    public String getNome() {
       if(this.usuario != null){
        return this.usuario.getNome();
       }else{
           return "";
       }

        
    }

    /**
     * @param nome the nome to set
     */
    public void setNome(String nome) {
        this.usuario.setNome(nome);
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public boolean isFrotaDistribuida() {
        return frotaDistribuida;
    }

    public void setFrotaDistribuida(boolean frotaDistribuida) {
        this.frotaDistribuida = frotaDistribuida;
    }
    
}