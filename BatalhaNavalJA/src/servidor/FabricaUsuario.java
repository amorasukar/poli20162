package servidor;

/**
 *
 * @author Amora
 */
class FabricaUsuario extends FabricaAbstrata {

    public FabricaUsuario() {
    }

    @Override
    public Usuario criarUsuario(String nome, String senha) {
        return new Usuario(nome,senha);
    }
}
