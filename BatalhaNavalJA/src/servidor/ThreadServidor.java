package servidor;

/**
 *
 * @author Amora
 */
public class ThreadServidor extends Thread{
    private int port;
    Servidor server;
    GuiServidor gui;
    public ThreadServidor(int port,GuiServidor gui){
        this.port = port;
        this.gui = gui;
    }
    
    public void run(){
        server = new Servidor(port,this.gui);
        server.startServer();
    }
    
    public void stopConexao(){
      server.killServer();
    }
}
