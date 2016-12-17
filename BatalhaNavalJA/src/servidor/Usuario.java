package servidor;

/**
 *
 * @author Amora e Jessica
 */
public class Usuario {

    private String nome;
    private String senha;

   
    public Usuario(String nome,String senha) {
        this.nome = nome;
        this.senha = senha;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    @Override
    public String toString(){
        return ("usuario: "+this.getNome()+" >> senha: "+this.senha);
    }

    @Override
    public boolean equals(Object obj){
        boolean retorno = false;
        Usuario usuariotemp = (Usuario) obj;

        if((this.nome.equals(usuariotemp.nome)) && (this.senha.equals(usuariotemp.senha))){
            retorno = true;
        }

        return retorno;
    }
}
