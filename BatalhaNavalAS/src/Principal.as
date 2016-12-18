package {
	import fl.controls.Button;
	import fl.controls.RadioButton;
	import fl.controls.TextArea;
	import flash.display.MovieClip;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.XMLSocket;
	
	/**
	* @author Jessica e Amora
	*/
	public class Principal extends MovieClip {
		
		/*Alvo onde as telas serão attachadas*/
		private var alvo:MovieClip;
		
		/*Telas*/
		private var introducao:MovieClip;
		private var login:MovieClip;
		private var regras:MovieClip;
		private var convidandoOponente:MovieClip;
		private var distribuindoFrota:MovieClip;
		private var jogo:MovieClip;
		private var resultado:MovieClip;
		
		/*Comunicação*/
		public var socket:XMLSocket;
		private var id:int;
		private var nome:String;
		private var caixaConfirmacao:CaixaConfirmacao;
				
		
		/*Jogo*/
		private var matrizTabuleiro:Array;
		private var tabuleiro:Tabuleiro;
		private var eu:Humano;
		private var oponente:Jogador;		
		
		/*Construtor da classe*/
		public function Principal() {
			this.socket = new XMLSocket();
			this.socket.addEventListener(DataEvent.DATA, receberMensagem);
			this.alvo = alvo_mc;
			this.introducao = this.attacharTela("ControleIntroducao", true);
			this.introducao.addEventListener(EventosBatalhaNaval.INTRODUCAOPASSARTELA, this.irParaLogin);					
		}
		
		private function receberMensagem(e:DataEvent):void {			
			var xml:XML = new XML(e.data);	
			switch((xml.tipo).toString()) {
				case "liberacao": 				this.distribuindoFrota.liberar();									
												break;
									
				case "respostaConecta": 		this.id = int(xml.idCliente);
												//this.irParaConvidandoOponente();
												
												break;
									
				case "respostaPedidoJogadores": this.preencherDataGrid(xml.texto);
												break;
									
				case "eventoEntradaJogador": 	this.preencherDataGrid(xml.texto, true);
												break;
									
				case "eventoSaidaJogador": 		this.removerDoDataGrid(xml.texto);
												break;
									
				case "conversaPublica": 		this.falarChat(xml);
												break;
												
				case "conversaPrivada": 		this.falarChat(xml, true);
												break;
												
				case "conviteOponente": 		this.convidandoOponente.mostrarCaixaConviteRecebido(xml.nomeCliente, xml.idCliente);
												break;
												
				case "cancelamentoConvite":		this.convidandoOponente.receberCancelamentoConvite();
												break;
												
				case "aceitacaoConvite":		this.convidandoOponente.receberAceitacao();
												
												break;
												
				case "recusaConvite":			this.convidandoOponente.receberRecusa();												
												break;
												
				case "mudancaEstado":			this.atualizarEstadosJogadores(xml);												
												break;
												
				case "saida":					var caixaGeral:CaixaGeral = new CaixaGeral("Seu oponente desistiu do jogo!");
												this.alvo.addChild(caixaGeral);
												caixaGeral.addEventListener(EventosBatalhaNaval.CAIXAGERALOK, this.irParaConvidandoOponente);
												break;
												
				case "usuarioValido":			this.irParaConvidandoOponente();
												break;
				case "usuarioInvalido":			//trace("Avisar ao usiario que o login é invalido!!!");
												this.login.log_txt.text += "\nFalha na autenticação do login!";
												this.login.ok_btn.enabled = true;
												break;
				case "conversaFrota":			//FAZER A CONVERSA SER ESCRITA NA TELA DO USUARIO
												this.distribuindoFrota.receberFala(xml.nomeCliente,xml.texto)
												break;
				case "conversaJogo":			//FAZER A CONVERSA SER ESCRITA NA TELA DO USUARIO
												this.jogo.receberFala(xml.nomeCliente,xml.texto)
												break;
				case "iniciaJogo":				this.irParaJogo();
												break;
				case "jogada":					this.jogo.executarJogadaOponente(xml.linha, xml.coluna);
												break;
				case "joga":					this.jogo.liberarMinhaJogada();
												break;
				case "espera":					this.jogo.liberarOponenteJogada();
												break;
				case "frota":					this.jogo.adicionarFrota(xml.embarcacoes);
												break;
				
				default:				trace("Principal -> receberMensagem -> não entrou em case nenhum.");
										break;
			}
		}
		
		private function atualizarEstadosJogadores(xml:XML):void{
			var id1:String = xml.idDestinatario;
			var id2:String = xml.idCliente;
			var lista:Array = new Array;
			if (id1 != "0") lista.push(id1);
			if (id2 != "0") lista.push(id2);
			var novoEstado:String = xml.texto;
			this.convidandoOponente.atualizarEstados(lista, novoEstado);
		}
		
		private function falarChat(xml:XML, reservado:Boolean = false):void {
			var remetente:String = xml.nomeCliente;
			var idDestinatario:String = xml.idDestinatario;
			var fala:String = xml.texto;
			this.convidandoOponente.receberFala(remetente, idDestinatario, fala, reservado);
		}
		
		private function removerDoDataGrid(texto:String):void {
			if(this.convidandoOponente.parent == this.alvo_mc){
				var dados:Array = texto.split(",");						
				this.convidandoOponente.removerJogador(dados[1], dados[0]); 	
			}
		}
		
		private function preencherDataGrid(texto:String, novoJogador:Boolean = false):void {			
			var nomes:Array = texto.split(",");
			var ids:Array = [];			
			var estados:Array = [];			
			for (var i:int = (nomes.length/3); i < (2*nomes.length/3); i++) {
				ids.push(nomes[i]);
			}
			for (var k:int = (2*nomes.length/3); k < nomes.length; k++) {
				estados.push(nomes[k]);
			}
			nomes.splice( (nomes.length/3), (2*nomes.length/3) );			
			for (var j:int = 0; j < nomes.length; j++) {			
				this.convidandoOponente.adicionarJogador(ids[j], nomes[j], estados[j], novoJogador); 	
			}			
		}
		
		private function irParaRegras(e:Event):void {
			this.regras = this.attacharTela("ControleRegras", true);
			this.regras.addEventListener(EventosBatalhaNaval.REGRASPASSARTELA, irParaLogin);
		}
		
		
		
		/* Esse método será chamando quando, depois de terminado o jogo, o jogador decide continuar jogando. */
		private function continuarJogando(e:Event):void{
			trace("Feedback: clicou em continuar");
		}
		
		/* Esse método será chamando quando, depois de terminado o jogo, o jogador decide não jogar mais. */
		private function sair(e:Event):void{
			this.caixaConfirmacao = new CaixaConfirmacao("Tem certeza que deseja sair?");
			this.alvo.addChild(this.caixaConfirmacao);
			this.caixaConfirmacao.addEventListener(EventosBatalhaNaval.CAIXACONFIRMACAOSIM, this.confirmarSaida);
			this.caixaConfirmacao.addEventListener(EventosBatalhaNaval.CAIXACONFIRMACAONAO, this.fecharCaixaConfirmacao);
			this.distribuindoFrota.habilitar(false);
		}
		
		private function confirmarSaida(e:EventosBatalhaNaval):void {
			var msg:Mensagem = new Mensagem();
			msg.tipo = "saida";
			this.socket.send(msg.criarXML());
			this.irParaConvidandoOponente();
		}
		
		private function fecharCaixaConfirmacao(e:Event):void{
			this.alvo.removeChild(this.caixaConfirmacao);
			this.distribuindoFrota.habilitar(true);
		}
		
		private function irParaLogin(e:Event):void {
			this.login = this.attacharTela("ControleLogin", true);					
		}
		
		private function irParaConvidandoOponente(e:Event = null):void {			
			this.convidandoOponente = this.attacharTela("ControleConvidandoOponente", true);
			this.convidandoOponente.addEventListener(EventosBatalhaNaval.CONVIDANDOOPONENTEPASSARTELA, this.irParaDistribuindoFrota);
			this.convidandoOponente.addEventListener(EventosBatalhaNaval.CONVIDANDOPCPASSARTELA, this.setOponenteComputador);
		}
		
		private function setOponenteComputador(e:Event):void {
			this.oponente = new Computador("Computador");
			this.irParaDistribuindoFrota();
		}
		
		private function irParaDistribuindoFrota(e:Event = null):void {	
			this.eu = new Humano(this.login.nome, this.login.senha);
			if(this.oponente == null)this.oponente = new Jogador(this.convidandoOponente.nomeOponente);//VERIFICAR ISTO DEPOIS;
			//this.eu.senha = this.login.senha;
			this.distribuindoFrota = this.attacharTela("ControleDistribuindoFrota", true);
			this.distribuindoFrota.addEventListener(EventosBatalhaNaval.SAIR, this.sair);
			this.distribuindoFrota.addEventListener(EventosBatalhaNaval.INICIARJOGO, this.irParaJogo);
		}
		
		private function irParaJogo(e:Event = null):void{
			this.matrizTabuleiro = this.distribuindoFrota.matrizTabuleiro;
			this.tabuleiro = this.distribuindoFrota.tabuleiro;
			this.jogo = this.attacharTela("ControleJogo", true);
			this.jogo.addEventListener(EventosBatalhaNaval.TERMINARJOGO, this.terminarJogo);
		}
		
		/*Attacha a tela de acordo com o nome passado como parâmetro. A tela atual é removida se o segundo parâmetro for true.*/
		private function attacharTela(nomeTela:String, limpar:Boolean = true):MovieClip {
			if (limpar)	this.limparAlvo();
			var tela:MovieClip;
			switch (nomeTela) {
				case "ControleIntroducao":			tela = new ControleIntroducao();											
											break;
				case "ControleLogin":				tela = new ControleLogin(this.socket);											
											break;
				case "ControleDistribuindoFrota": 	tela = new ControleDistribuindoFrota(this.socket, this.id, this.oponente.nome);
											break;
				case "ControleConvidandoOponente": 	tela = new ControleConvidandoOponente(this.socket, this.id);
											break;
				case "ControleJogo": 				tela = new ControleJogo(this.socket,this.eu, this.oponente, this.tabuleiro);
											break;
				case "Resultado": 					tela = new Resultado();
											break;
				default:					trace("Essa tela não existe.");
			}
			this.alvo.addChild(tela);
			return tela;
		}
		
		private function limparAlvo():void {
			while (this.alvo.numChildren > 0) {
				this.alvo.removeChildAt(0);
			}
		}
		
		private function terminarJogo(e:Event):void {
			var tipo:String = this.jogo.tipoResultado;		
			this.resultado = this.attacharTela("Resultado", true);			
			this.resultado.configurar(tipo);			
			this.resultado.addEventListener(EventosBatalhaNaval.CONTINUAR, this.continuarJogando);
			this.resultado.addEventListener(EventosBatalhaNaval.SAIR, this.sair);
		}
	}
}