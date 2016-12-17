package servidor;

/**
 *
 * @author Jessica
 */
abstract class FabricaAbstrata {

    public static FabricaAbstrata getFabricaUsuario(){
        return new FabricaUsuario();
    }

    public abstract Usuario criarUsuario(String nome, String senha);
}
