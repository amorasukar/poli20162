package servidor;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.xml.sax.SAXException;
import servidor.CarregadorUsuarios;
import servidor.Usuario;

/**
 *
 * @author Amora
 */
public class CarregarXML {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException {
        CarregadorUsuarios carregar = new CarregadorUsuarios();
        try {
            ArrayList<Usuario> lista = carregar.listarUsuarios("C:\\Users\\Amora\\Documents\\GitHub\\poli20162\\BatalhaNavalJA\\src\\servidor\\Usuarios.xml");

        } catch (SAXException ex) {
            Logger.getLogger(CarregarXML.class.getName()).log(Level.SEVERE, null, ex);
        }

        

    }

}
