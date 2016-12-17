package servidor;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


/**
 *
 * @author Jessica
 */
public class CarregadorUsuarios {
    private ArrayList<Usuario> usuarios;
    private File arquivo;
    private DocumentBuilderFactory fabrica;
    private DocumentBuilder criador;
    private NodeList listaNo;
    private String caminho;
    private Document doc;
    private FabricaAbstrata fabricaUsuario;

    public CarregadorUsuarios() {
        this.usuarios = new ArrayList<Usuario>();
    }

    public ArrayList<Usuario> listarUsuarios(String caminho) throws IOException, SAXException{
        this.caminho = caminho;
        this.arquivo = new File(this.caminho);
        this.fabrica = DocumentBuilderFactory.newInstance();
        this.fabricaUsuario = FabricaAbstrata.getFabricaUsuario();
        try {
            this.criador = this.fabrica.newDocumentBuilder();
            this.doc =  this.criador.parse(arquivo);
            this.doc.getDocumentElement().normalize();
            this.listaNo = this.doc.getElementsByTagName("usuario");
            for (int i = 0; i < this.listaNo.getLength(); i++) {
                Node no = this.listaNo.item(i);
                 if (no.getNodeType() == Node.ELEMENT_NODE) {
                     Element pai = (Element)no;
                     NodeList nome = pai.getElementsByTagName("nome");
                     Element nomeElemento = (Element) nome.item(0);
                     NodeList nomeUsuario = nomeElemento.getChildNodes();
                     NodeList senha = pai.getElementsByTagName("senha");
                     Element senhaElemento = (Element) senha.item(0);
                     NodeList senhaUsuario = senhaElemento.getChildNodes();
                     Usuario usuario = this.fabricaUsuario.criarUsuario(((Node) nomeUsuario.item(0) ).getNodeValue(),((Node)senhaUsuario.item(0)).getNodeValue());
                     this.usuarios.add(usuario);
                 }

            }
        } catch (ParserConfigurationException ex) {
            Logger.getLogger(CarregadorUsuarios.class.getName()).log(Level.SEVERE, null, ex);
        }
        return this.usuarios;
    }

}
