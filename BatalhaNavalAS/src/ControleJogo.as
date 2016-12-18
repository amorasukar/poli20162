package {
	import fl.controls.Button;
	import fl.controls.TextArea;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.XMLSocket;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * @author Amora
	 */
	public class ControleJogo extends MovieClip {
		/*Elementos do palco*/
		private var meuTabuleiro:Tabuleiro;
		private var oponenteTabuleiro:Tabuleiro;
		private var tabuleiros:Array;
		//private var frota:Frota;
		private var log:TextArea;
		/*Fim de elementos do palco*/
		
		private var vez:int;
		private var eu:Jogador;
		private var oponente:Jogador;
		private var jogadores:Array;
		private var delay:Timer;
		private var resultado:Resultado;
		private var _tipoResultado:String;
		private var comunicacao:XMLSocket;
		
		private var jogadaEnviada:Boolean;
		
		private var fala:TextArea;
		private var enviar:Button;
		
		
		public function ControleJogo(socket:XMLSocket,eu:Humano, oponente:Jogador, tabuleiro:Tabuleiro) {
			this.eu = eu;
			this.oponente = oponente;
			this.oponente_txt.text = this.oponente.nome;
			this.jogadores = [this.eu, this.oponente];
			
			this.comunicacao = socket;
			
			this.meuTabuleiro = this.tabuleiro1_mc;
			this.meuTabuleiro.copiar(tabuleiro);
			this.meuTabuleiro.addEventListener(EventosBatalhaNaval.ACERTARAGUA, acertarAgua);
			this.meuTabuleiro.addEventListener(EventosBatalhaNaval.ATINGIRPECA, atingirPeca);
			this.meuTabuleiro.addEventListener(EventosBatalhaNaval.ABATEREMBARCACAO, this.abaterEmbarcacao);
			this.meuTabuleiro.addEventListener(EventosBatalhaNaval.CLICARPECA, this.informarJogada);
			this.meuTabuleiro.addEventListener(EventosBatalhaNaval.TERMINARJOGO, this.terminarJogo);
			
			this.oponenteTabuleiro = this.tabuleiro2_mc;
			this.oponenteTabuleiro.addEventListener(EventosBatalhaNaval.ACERTARAGUA, acertarAgua);
			this.oponenteTabuleiro.addEventListener(EventosBatalhaNaval.ATINGIRPECA, atingirPeca);
			this.oponenteTabuleiro.addEventListener(EventosBatalhaNaval.ABATEREMBARCACAO, this.abaterEmbarcacao);
			this.oponenteTabuleiro.addEventListener(EventosBatalhaNaval.CLICARPECA, this.informarJogada);
			this.oponenteTabuleiro.addEventListener(EventosBatalhaNaval.TERMINARJOGO, this.terminarJogo);
			
			this.tabuleiros = [this.meuTabuleiro, this.oponenteTabuleiro];									
			
			//this.frota = this.frota_mc;
			this.log = this.log_txt;				
			
			this.delay = new Timer(1000);
			
			// this.fala = this.fala_txt;
			// this.enviar = this.enviar_btn;
			//this.fala.addEventListener(Event.CHANGE, this.habilitarEnviar);
			//this.enviar.addEventListener(MouseEvent.MOUSE_UP, this.enviarTexto);
			
			
			//-----------------------------//
			this.meuTabuleiro.liberarClique(false);
			this.oponenteTabuleiro.liberarClique(false);
			this.vez = -1;
			this.jogadaEnviada = false;
			this.verificarTipoOponente();	
			//----------------------------//
						
						
		}
		
		private function habilitarEnviar(e:Event):void{
			/* if (this.fala.text != "") {
				this.enviar.enabled = true;
			}
			else {
				this.enviar.enabled = false;
			}*/ 
		}
		
		private function enviarTexto(e:MouseEvent):void{
			var msg:Mensagem = new Mensagem();			
			//msg.texto = this.fala.text;
			msg.tipo = "conversaJogo";
			this.comunicacao.send( msg.criarXML() );
			//this.fala.text = "";
			// this.enviar.enabled = false;
		}
		
		public function receberFala(remetente:String, fala:String):void {
			this.log_txt.text += ("\n"+remetente + " falou: " + fala);
		}
		
		public function adicionarFrota(frota:String):void {
			this.oponenteTabuleiro.adicionarFrota(frota);
		}
		
		public function liberarMinhaJogada():void {
			this.vez = 0;
			this.escreverLog("Vez de " + this.jogadores[this.vez].nome + " jogar.");
			this.liberarJogada();
		}
		
		public function liberarOponenteJogada():void {
			this.vez = 1;
			this.escreverLog("Vez de " + this.jogadores[this.vez].nome + " jogar.");
			this.liberarJogada();
		}
		
		private function escreverLog (texto:String) {
			this.log.appendText(texto);
			this.log.verticalScrollPosition = this.log.maxVerticalScrollPosition;
		}
		
		private function revalorarDelay():void {
			var numero:Number = 1000 + Math.floor(Math.random() * 1000);
			this.delay.delay = numero;
		}
		
		private function informarJogada(e:Event):void {			
			var tabuleiro:Tabuleiro = Tabuleiro(e.target);			
			this.oponenteTabuleiro.liberarClique(false);			
			//this.meuTabuleiro.liberarClique(false);		
			this.escreverLog("\n" + this.jogadores[this.vez].nome + " jogou em (" + tabuleiro.ultimaPecaClicada.linha + ", " + tabuleiro.ultimaPecaClicada.coluna + ") ");			
			if (this.oponente.nome != "Computador" && this.vez == 0 && !this.jogadaEnviada) {
				var msg:Mensagem = new Mensagem();
				msg.tipo = "jogada";
				msg.linha = tabuleiro.ultimaPecaClicada.linha;
				msg.coluna = tabuleiro.ultimaPecaClicada.coluna;
				this.comunicacao.send(msg.criarXML());
				this.jogadaEnviada = true;
			}
			
			
		}
		
		private function verificarTipoOponente():void{
			/* if (this.oponente.nome == "Computador") {
				this.fala.enabled =
				this.fala.editable =
				this.fala.mouseEnabled = false;	
				Computador(this.oponente).criarInteligencia(oponenteTabuleiro);				
				this.iniciarJogo();
			}else { */
				var frota:Mensagem = new Mensagem();
				frota.tipo = "frota";
				for (var i:int = 0; i < this.meuTabuleiro.frota.length; i++) {
					var pecas:String = "";
					for (var j:int = 0; j < this.meuTabuleiro.frota[i].pecas.length; j++) {
						pecas += (this.meuTabuleiro.frota[i].pecas[j].linha + "," + this.meuTabuleiro.frota[i].pecas[j].coluna);
						if ( (j + 1) < this.meuTabuleiro.frota[i].pecas.length) {
							pecas += "#";
						}
					}
					if ( (i + 1) < this.meuTabuleiro.frota.length ) {
						pecas += "%";
					}
					frota.embarcacoes += (pecas);
				}
					
							
				this.comunicacao.send(frota.criarXML());
			// }
		}
		
		public function iniciarJogo():void{
			this.vez = Math.floor(Math.random() * 2);
			this.escreverLog("Definido por sorteio: " + this.jogadores[this.vez].nome + " inicia jogando.");
			this.liberarJogada();	
		}
		
		public function continuarVez():void {
			trace("continuarVez");
			this.escreverLog("\n\n" + this.jogadores[this.vez].nome + " deve jogar novamente.");
			if (this.jogadores[this.vez].nome == "Computador") {
				this.revalorarDelay();
				this.delay.start();
				this.delay.addEventListener(TimerEvent.TIMER, this.jogarComputador);
			}else {
				trace("else");
				this.liberarJogada();
			}
		}
		
		public function passarVez(e:Event = null):void {
			this.vez = (1 - this.vez);			
			this.escreverLog("\n\nAgora eh a vez de " + this.jogadores[this.vez].nome + " jogar.");
			this.liberarJogada();
		}				
		
		private function liberarJogada():void {
			trace("metodo liberarJogada");
			this.jogadaEnviada = false;
			if (this.vez == 0) {				
				trace("liberou meu clique");
				this.oponenteTabuleiro.liberarClique(true);
			}			
			else {				
				this.oponenteTabuleiro.liberarClique(false);
				if (this.jogadores[this.vez].nome == "Computador") {
					this.revalorarDelay();
					this.delay.start();
					this.delay.addEventListener(TimerEvent.TIMER, this.jogarComputador);
				}
			}			
		}
		
		private function jogarComputador(e:Event):void {
			this.delay.removeEventListener(TimerEvent.TIMER, this.jogarComputador);			
			var jogadaOponente:Jogada = Computador(this.oponente).escolherJogada();
			this.meuTabuleiro.pecas[jogadaOponente.linha][jogadaOponente.coluna].clicar();			
		}
		
		private function acertarAgua(e:Event):void {
			trace("método acertarAgua");
			if (this.vez == 1 && this.oponente.nome == "Computador") {
				Computador(this.oponente).acertarAgua();				
			}

			
			this.escreverLog("e não atingiu nenhuma peça de nenhuma embarcação de " + this.jogadores[(1 - this.vez)].nome + ".");
			this.passarVez();
		}
		
		private function atingirPeca(e:Event):void {
			trace("método atingirPeca");
			if (this.vez == 1 && this.oponente.nome == "Computador") {
				Computador(this.oponente).atingirPeca();
			}
			this.escreverLog("e atingiu uma peça de uma embarcação de " + this.jogadores[(1-this.vez)].nome + ".");
			this.continuarVez();
		}
		
		private function abaterEmbarcacao(e:Event):void {
			trace("método abaterEmbarcacao");
			if (this.vez == 1 && this.oponente.nome == "Computador") {				
				Computador(this.oponente).abaterEmbarcacao(this.meuTabuleiro.ultimaEmbarcacaoAbatida);				
			}
			this.escreverLog(" e abateu um " + this.tabuleiros[(1 - this.vez)].ultimaEmbarcacaoAbatida.nome + " de " + this.jogadores[(1 - this.vez)].nome + ".");			
			if(!this.tabuleiros[(1 - this.vez)].terminou) {
				this.continuarVez();
			}
		}
		
		private function terminarJogo(e:Event):void {
			this.oponenteTabuleiro.liberarClique(false);
			this.escreverLog("\n" + this.jogadores[this.vez].nome + " abateu todas as embarcações de " + this.jogadores[(1 - this.vez)].nome + ".");						
			if (this.vez == 0) {
				this.tipoResultado = TipoResultado.GANHOU;
				this.escreverLog("\n\n**** VOCÊ VENCEU!!! ****");
			}
			else {
				this.tipoResultado = TipoResultado.PERDEU;
				this.escreverLog("\n\n**** VOCÊ PERDEU... ****");
			}
			this.delay.delay = 5000;
			this.delay.start();
			this.delay.addEventListener(TimerEvent.TIMER, this.dispararEventoTerminarJogo);			
		}
		
		private function dispararEventoTerminarJogo(e:Event):void{
			this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.TERMINARJOGO ) );
		}
		
		private function sair(e:Event):void{
			trace("sair");
		}
		
		private function continuarJogo(e:Event):void{
			trace("continuar");
		}
		
		public function get tipoResultado():String { 
			return _tipoResultado;
		}
		
		public function set tipoResultado(value:String):void {
			_tipoResultado = value;
		}
		
		
		public function executarJogadaOponente(linha:int, coluna:int):void {
			this.meuTabuleiro.pecas[linha][coluna].clicar();
		}
	}
	
}