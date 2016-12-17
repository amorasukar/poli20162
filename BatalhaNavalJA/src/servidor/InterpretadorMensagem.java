package servidor;

/**
 *
 * @author Jessica
 */
public class InterpretadorMensagem {

    private Servidor servidor;
    private Mensagem mensagem;
    private Cliente cliente;

    public InterpretadorMensagem(Servidor servidor, Mensagem mensagem, Cliente cliente) {
        this.servidor = servidor;
        this.mensagem = mensagem;
        this.cliente = cliente;
        this.interpretar();

    }

    private void interpretar() {
        String tipo = this.mensagem.getTipo();

        switch (this.mapearTipo(tipo)) {
            case 1://pedidoJogadores
                Mensagem mensagemResposta = new Mensagem();
                mensagemResposta.setTexto(this.servidor.getNomesJogadores());
                mensagemResposta.setTipo("respostaPedidoJogadores");
                this.servidor.enviarMensagem(mensagemResposta, cliente);

                Mensagem mensagemResposta2 = new Mensagem();
                mensagemResposta2.setTexto(this.cliente.getNome() + "," + this.cliente.getIdCliente() + "," + this.cliente.getEstado());
                mensagemResposta2.setTipo("eventoEntradaJogador");
                this.servidor.broadcastMessage(mensagemResposta2);
                break;

            case 2://envioNome
                Mensagem validacao = new Mensagem();
                Usuario jogador;
                FabricaAbstrata fabrica = FabricaAbstrata.getFabricaUsuario();
                
                if (this.servidor.validarUsuario(this.mensagem.getTexto(), this.mensagem.getSenha())) {
                    jogador = fabrica.criarUsuario(this.mensagem.getTexto(), this.mensagem.getSenha());
                    this.cliente.setUsuario(jogador);
                    this.servidor.writeActivity(this.cliente.getIdCliente() + " => " + this.cliente.getNome() + " conectado ao servidor.");

                    validacao.setTipo("usuarioValido");
                    this.servidor.enviarMensagem(validacao, cliente);
                } else {
                    this.servidor.removeClient(cliente);
                    this.servidor.writeActivity(this.cliente.getIdCliente() + " => " + this.cliente.getNome() + " erro no login.");
                    validacao.setTipo("usuarioInvalido");
                    this.servidor.enviarMensagem(validacao, cliente);
                }

                break;

            case 3://conversaPublica
                this.mensagem.setNomeCliente(this.cliente.getNome());
                this.servidor.broadcastMessage(this.mensagem);
                break;

            case 4://conversaPrivada
                this.mensagem.setNomeCliente(this.cliente.getNome());
                Cliente destinatario = this.servidor.procurarCliente(this.mensagem.getDestinatario());
                this.servidor.enviarMensagem(this.mensagem, destinatario);
                this.servidor.enviarMensagem(this.mensagem, this.cliente);
                break;
            case 5://conviteOponente
                this.mensagem.setNomeCliente(this.cliente.getNome());
                this.mensagem.setIdCliente(this.cliente.getIdCliente());
                Cliente destinatarioConvite = this.servidor.procurarCliente(this.mensagem.getDestinatario());
                this.servidor.enviarMensagem(this.mensagem, destinatarioConvite);
                break;
            case 6://cancelamentoConvite
                this.mensagem.setNomeCliente(this.cliente.getNome());
                this.mensagem.setIdCliente(this.cliente.getIdCliente());
                Cliente destinatarioCancelamentoConvite = this.servidor.procurarCliente(this.mensagem.getDestinatario());
                this.servidor.enviarMensagem(this.mensagem, destinatarioCancelamentoConvite);
                break;
            case 7://aceitacaoConvite
                Cliente convidador = this.servidor.procurarCliente(this.mensagem.getDestinatario());
                this.servidor.enviarMensagem(this.mensagem, convidador);
                this.servidor.adicionarDupla(this.cliente, convidador);

                Mensagem msgMudancaEstado = new Mensagem();
                msgMudancaEstado.setTipo("mudancaEstado");
                msgMudancaEstado.setDestinatario(this.mensagem.getDestinatario());
                msgMudancaEstado.setIdCliente(this.cliente.getIdCliente());
                msgMudancaEstado.setTexto("Jogando");
                this.servidor.broadcastMessage(msgMudancaEstado);

                this.cliente.setEstado("Jogando");
                convidador.setEstado("Jogando");

                break;
            case 8://recusaConvite
                Cliente convidador2 = this.servidor.procurarCliente(this.mensagem.getDestinatario());
                this.servidor.enviarMensagem(this.mensagem, convidador2);
                break;
            case 9://saida
                Cliente oponente = this.servidor.getOponente(cliente);
                System.out.println("Nome oponente = " + oponente.getNome());
                this.servidor.enviarMensagem(this.mensagem, oponente);
                this.servidor.removerLinha(this.servidor.procurarLinhaCliente(this.cliente));
                this.cliente.setEstado("Livre");
                oponente.setEstado("Livre");
                //tirar os 2 do array de duplas.

                Mensagem msgMudancaEstado2 = new Mensagem();
                msgMudancaEstado2.setTipo("mudancaEstado");
                msgMudancaEstado2.setDestinatario(oponente.getIdCliente());
                msgMudancaEstado2.setIdCliente(this.cliente.getIdCliente());
                msgMudancaEstado2.setTexto("Livre");
                this.servidor.broadcastMessage(msgMudancaEstado2);

                break;

            case 10://jogarXPC
                this.cliente.setEstado("Jogando");
                Mensagem msgMudancaEstado3 = new Mensagem();
                msgMudancaEstado3.setTipo("mudancaEstado");
                msgMudancaEstado3.setIdCliente(this.cliente.getIdCliente());
                msgMudancaEstado3.setTexto("Jogando");
                this.servidor.broadcastMessage(msgMudancaEstado3);
                break;
            case 11://conversaFrota ou conversaJogo
                this.mensagem.setNomeCliente(this.cliente.getNome());
                Cliente dupla = this.servidor.getOponente(cliente);
                this.servidor.enviarMensagem(this.mensagem, dupla);
                this.servidor.enviarMensagem(this.mensagem, this.cliente);
                break;
            case 12://frotaDistribuida
                this.cliente.setFrotaDistribuida(true);
                Cliente dupla2 = this.servidor.getOponente(this.cliente);
                if (dupla2 != null) {
                    if (dupla2.isFrotaDistribuida()) {
                        Mensagem iniciaJogo = new Mensagem();
                        iniciaJogo.setTipo("iniciaJogo");
                        this.servidor.enviarMensagem(iniciaJogo, this.cliente);
                        this.servidor.enviarMensagem(iniciaJogo, dupla2);
                        Mensagem vez = new Mensagem();
                        vez.setTipo("joga");//MUDAR ESTE TIPO DEPOIS
                        this.servidor.enviarMensagem(vez, dupla2);//Por enquanto o jogo inicia com o primeiro jogador
                        vez.setTipo("espera");
                        this.servidor.enviarMensagem(vez, this.cliente);
                    }
                }
                break;
            case 13://jogada
                this.mensagem.setNomeCliente(this.cliente.getNome());
                Cliente dupla3 = this.servidor.getOponente(cliente);
                this.servidor.enviarMensagem(this.mensagem, dupla3);
                break;

            case 14://frota
                this.mensagem.setNomeCliente(this.cliente.getNome());
                Cliente dupla5 = this.servidor.getOponente(cliente);
                this.servidor.enviarMensagem(this.mensagem, dupla5);
                System.out.println("mensagem.embarcacoes = "+this.mensagem.getEmbarcacoes());
                break;

        }

    }

    private int mapearTipo(String tipo) {
        int retorno = -1;
        if (tipo.equals("pedidoJogadores")) {
            retorno = 1;
        } else if (tipo.equals("envioNome")) {
            retorno = 2;
        } else if (tipo.equals("conversaPublica")) {
            retorno = 3;
        } else if (tipo.equals("conversaPrivada")) {
            retorno = 4;
        } else if (tipo.equals("conviteOponente")) {
            retorno = 5;
        } else if (tipo.equals("cancelamentoConvite")) {
            retorno = 6;
        } else if (tipo.equals("aceitacaoConvite")) {
            retorno = 7;
        } else if (tipo.equals("recusaConvite")) {
            retorno = 8;
        } else if (tipo.equals("saida")) {
            retorno = 9;
        } else if (tipo.equals("jogarXPC")) {
            retorno = 10;
        } else if (tipo.equals("conversaFrota")) {
            retorno = 11;
        } else if (tipo.equals("frotaDistribuida")) {
            retorno = 12;
        } else if (tipo.equals("jogada")) {
            retorno = 13;
        } else if (tipo.equals("frota")) {
            retorno = 14;
        }else if (tipo.equals("conversaJogo")) {
            retorno = 11;
        }


        return retorno;
    }
}
