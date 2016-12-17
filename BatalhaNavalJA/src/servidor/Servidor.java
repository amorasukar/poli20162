package servidor;


import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;
import java.util.*;
import java.io.*;
import java.net.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.xml.sax.SAXException;


public class Servidor {
    private Vector<Cliente> clients = new Vector<Cliente>();
    private ArrayList<ArrayList> duplas = new ArrayList<ArrayList>();
    ServerSocket server;
    private int port;
    private GuiServidor gui;

    private ArrayList<Usuario> usuarios;
    private CarregadorUsuarios carregador;
    public Servidor(int port, GuiServidor gui) {
        this.port = port;
        //startServer(port);
        this.gui = gui;
        this.carregador = new CarregadorUsuarios();
        try {
            this.usuarios = this.carregador.listarUsuarios("Usuarios.xml");
        } catch (IOException ex) {
            Logger.getLogger(Servidor.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SAXException ex) {
            Logger.getLogger(Servidor.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }

    public void startServer() {
        writeActivity("Inicializando o Servidor");
        
        try {
            server = new ServerSocket(this.port);
            writeActivity("Servidor inicializado na porta: " + port);

            while(true) {
                Socket socket = server.accept();
                
                Cliente client = new Cliente(this, socket);
                writeActivity(client.getIdCliente() + " => " + client.getIP() + " conectado ao servidor.");
                
                
                clients.addElement(client);

                int id = (int)client.getIdCliente();
               
                client.start();		
               
                if(clients.size() == 2){
                    System.out.println("size = 2");
                }
                
            }
        } catch(IOException ioe) {
            
            killServer();
        } 
    }

    public synchronized void broadcastMessage(Mensagem mensagem) {
       
        Enumeration enume = clients.elements();
        while (enume.hasMoreElements()) {
            Cliente cliente = (Cliente)enume.nextElement();
            this.enviarMensagem(mensagem, cliente);
        }

    }

    public synchronized void enviarMensagem(Mensagem mensagem, Cliente cliente) {
        XStream stream = new XStream(new DomDriver());
        String xml = stream.toXML(mensagem);
        xml += '\0';
        System.out.println("enviando xml = " + xml);
        
        cliente.send(xml);
    }

    public void lerMensagem(String msg, Cliente cliente){
        XStream stream = new XStream(new DomDriver());
        Mensagem mensagemLida = (Mensagem) stream.fromXML(msg);
        System.out.println("recebendo xml = " + stream.toXML(mensagemLida));
        InterpretadorMensagem interpretador = new InterpretadorMensagem(this,mensagemLida,cliente);
        //this.interpretarMensagem(mensagemLida, cliente);
    }

    public String getNomesJogadores(){
        String retorno = new String();
        Enumeration enume = clients.elements();
        while (enume.hasMoreElements()) {
            Cliente cliente = (Cliente)enume.nextElement();
            retorno += cliente.getNome() + ",";
        }
        enume = clients.elements();
        while(enume.hasMoreElements()){
            Cliente cliente = (Cliente)enume.nextElement();
            retorno += cliente.getIdCliente() + ",";
        }
        enume = clients.elements();
        while(enume.hasMoreElements()){
            Cliente cliente = (Cliente)enume.nextElement();
            retorno += cliente.getEstado();
            if(cliente.getIdCliente() != clients.get(clients.size()-1).getIdCliente()){
                retorno += ",";
            }
        }
        return retorno;
    }

    public void removeClient(Cliente client) {
        writeActivity(client.getIP() + " deixou o servidor.");        
        clients.removeElement(client);             
    }

    public void writeActivity(String activity) {
        Calendar cal = Calendar.getInstance();
        activity = "[" + cal.get(Calendar.DAY_OF_MONTH) 
                 + "/" + (cal.get(Calendar.MONTH) + 1) 
                 + "/" + cal.get(Calendar.YEAR) 
                 + " " 
                 + cal.get(Calendar.HOUR_OF_DAY) 
                 + ":" + cal.get(Calendar.MINUTE) 
                 + ":" + cal.get(Calendar.SECOND) 
                 + "] " + activity + "\n";
        System.out.print(activity);
       this.gui.mostrarMensagem(activity);
    }

    protected void killServer() {
        try {
            server.close();
            writeActivity("O servidor foi parado!");
        } catch (IOException ioe) {
            writeActivity("Erro enquanto parava o servidor");
        }
    }

    protected void adicionarDupla(Cliente c1, Cliente c2){
        this.duplas.add( new ArrayList<Cliente>() );
        this.duplas.get(this.duplas.size()-1).add(c1);
        this.duplas.get(this.duplas.size()-1).add(c2);
    }

    protected int procurarLinhaCliente(Cliente cliente){
        int retorno = -1;
        for(int i = 0;i<this.duplas.size();i++){
            if(this.duplas.get(i).indexOf(cliente) != -1){
                retorno = i;
                break;
            }
        }
        return retorno;
    }

    protected Cliente getOponente(Cliente cliente){
        Cliente oponente = null;
        int linha = this.procurarLinhaCliente(cliente);
        if(linha != -1){
            for (int i = 0; i < this.duplas.get(linha).size(); i++) {
                if( ((Cliente)(this.duplas.get(linha).get(i))).getIdCliente() != cliente.getIdCliente() ){
                    oponente = (Cliente)(this.duplas.get(linha).get(i));
                    break;
                }
            }
        }
        
        return oponente;
    }

    protected void removerLinha(int indice){
        this.duplas.remove(indice);
    }

    protected Cliente procurarCliente(int id){
       Cliente retorno = null;
       Enumeration enume = clients.elements();
        while (enume.hasMoreElements()) {
           retorno = (Cliente)enume.nextElement();
           if( (retorno).getIdCliente() == id ){
                break;
           }
        }
       return retorno;
    }

    protected Boolean validarUsuario(String nome, String senha){
        FabricaAbstrata fabrica = FabricaAbstrata.getFabricaUsuario();
        boolean retorno = false;
        Usuario teste = fabrica.criarUsuario(nome, senha);//new Usuario(nome, senha);
        for (int i = 0; i < this.usuarios.size(); i++) {
            if(teste.equals(this.usuarios.get(i))){
                retorno = true;
                break;
            }
         }

        return retorno;
    }

}
