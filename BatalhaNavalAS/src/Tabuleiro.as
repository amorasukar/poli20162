package {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	* @author Jessica
	*/
	public class Tabuleiro extends MovieClip {
		private var _pecas:Array;
		private var _ultimaPecaClicada:Peca;
		private var _frota:Array; //Por enquanto, é como se fosse a frota do oponente humano.
		private var _ultimaEmbarcacaoAbatida:Embarcacao;
		private var contadorAbatidos:int;
		private const QTDEMBARCACOES:int = 3
		private var _terminou:Boolean;
		
		public function Tabuleiro() {
			this.ultimaPecaClicada = undefined;
			this.inicializarPecas();
			this.contadorAbatidos = 0;
			this.terminou = false;
			this.inicializarFrota();
		}		
		
		private  function inicializarFrota():void {
			var destroyer:Embarcacao = new Embarcacao("destroyer");
			destroyer.observadores = [this];
			var portaAvioes:Embarcacao = new Embarcacao("porta-avioes");
			portaAvioes.observadores = [this];
			var submarino:Embarcacao = new Embarcacao("submarino");
			submarino.observadores = [this];
			this.frota = [destroyer, portaAvioes, submarino];
		}
		
		public function copiar(tabuleiro:Tabuleiro):void {			
			for (var i:int = 0; i < tabuleiro.frota.length; i++) {
				for (var j:int = 0; j < tabuleiro.frota[i].pecas.length; j++) {
					var peca:Peca = this.pecas[tabuleiro.frota[i].pecas[j].linha][tabuleiro.frota[i].pecas[j].coluna];
					this.frota[i].adicionarPeca(peca);
					peca.estado = EstadoPeca.PECAEXPOSTA;
				}
			}
		}	
		
		public function adicionarFrota(frota:String):void { // frota = "0,0#0,2#1,1%3,3#3,4#3,5#3,6%8,8"
			var embarcacoes:Array = new Array();
			embarcacoes = frota.split("%"); //embarcacoes = ["0,0#0,2#1,1", "3,3#3,4#3,5#3,6", "8,8"];			
			for (var t:int = 0; t < embarcacoes.length; t++) {
				if (embarcacoes[t].indexOf("#") != -1) {
					embarcacoes[t] = embarcacoes[t].split("#"); //embarcacoes = [ ["0,0", "0,2", "1,1"], ["3,3", "3,4", "3,5", "3,6"], "8,8"];
					for (var f:int = 0; f < embarcacoes[t].length; f++) {
						embarcacoes[t][f] = embarcacoes[t][f].split(","); //embarcacoes = [ [ ["0","0"], ["0", "2"], ["1", "1"] ], ["3,3", "3,4", "3,5", "3,6"], "8,8"];
					}
				}else {
					embarcacoes[t] = [embarcacoes[t].split(",")]; //embarcacoes = [ [ ["0","0"], ["0", "2"], ["1", "1"] ], ["3,3", "3,4", "3,5", "3,6"], [["8","8"]]];
				}
				
			}						
			
			for (var i:int = 0; i < embarcacoes.length; i++) {
				for (var j:int = 0; j < embarcacoes[i].length; j++) {
					var peca:Peca = this.pecas[ int(embarcacoes[i][j][0]) ][ int( embarcacoes[i][j][1]) ];
					this.frota[i].adicionarPeca(peca);	
					//peca.estado = EstadoPeca.PECAEXPOSTA;
				}
			}
		}
		
		
		
		private function atingirEmbarcacao():void {
			this.dispatchEvent(new Event(EventosBatalhaNaval.ATINGIRPECA));
		}
		
		private function abaterEmbarcacao():void {
			this.dispatchEvent(new Event(EventosBatalhaNaval.ABATEREMBARCACAO));
		}
				
		private function terminarJogo():void {
			this.dispatchEvent(new Event(EventosBatalhaNaval.TERMINARJOGO));
		}
		
		private function inicializarPecas():void {
			this._pecas = new Array(10);
			for (var i:int = 0; i < this.pecas.length; i++) {
				this._pecas[i] = new Array(10);
				for (var j:int = 0; j < this.pecas[i].length; j++) {
					this._pecas[i][j] = this.getChildByName("quad" + i + j + "_mc");
					this._pecas[i][j].buttonMode = true;
					this._pecas[i][j].observadores = new Array(this);
				}					
			}
		}				
		
		public function liberarClique(liberado:Boolean):void {
			for (var i:int = 0; i < this.pecas.length; i++) {
				for (var j:int = 0; j < this.pecas[i].length; j++) {
					if (this.pecas[i][j].estado == EstadoPeca.PECAOCULTA || this.pecas[i][j].estado == EstadoPeca.PECAEXPOSTA) {
						this.pecas[i][j].mouseEnabled = liberado;
					}					
				}	
			}
		}
		
		private function dispararEventoClicarPeca(peca:Peca):void {
			this.ultimaPecaClicada = peca;
			this.dispatchEvent( new Event(EventosBatalhaNaval.CLICARPECA) );
		}
		
		public function atualizar(tipo:String, objeto:Object):void {								
			if (tipo == "peca") {	
				var peca:Peca = Peca(objeto);
				this.dispararEventoClicarPeca(peca);
				peca.estado = EstadoPeca.PECAAGUA;
				this.dispararAcertarAgua();
			}
			else { //tipo = Embarcacao			
				var embarcacao:Embarcacao = Embarcacao(objeto);				
				this.dispararEventoClicarPeca(embarcacao.ultimaPecaClicada);
				if (embarcacao.estado == EstadoEmbarcacao.EMBARCACAOATINGIDA) {
					this.atingirEmbarcacao();
				}
				else {
					this._ultimaEmbarcacaoAbatida = embarcacao;					
					if (++this.contadorAbatidos == this.QTDEMBARCACOES) {
						this.terminou = true;
						this.abaterEmbarcacao();
						this.terminarJogo();
					}					
					else {
						this.abaterEmbarcacao();
					}
				}
				
			}
			
		}												
		
		private function dispararAcertarAgua():void {
			this.dispatchEvent(new Event(EventosBatalhaNaval.ACERTARAGUA));
		}
		
		public function get pecas():Array { 
			return _pecas;
		}				
		
		public function get ultimaEmbarcacaoAbatida():Embarcacao { 
			return _ultimaEmbarcacaoAbatida;
		}
		
		public function set pecas(value:Array):void {
			_pecas = value;
		}
		
		public function get ultimaPecaClicada():Peca { 
			return _ultimaPecaClicada;
		}
		
		public function set ultimaPecaClicada(value:Peca):void {
			_ultimaPecaClicada = value;
		}							
		
		public function get frota():Array { 
			return _frota;
		}
		
		public function set frota(value:Array):void {
			_frota = value;
		}
		
		public function get terminou():Boolean { 
			return _terminou;
		}
		
		public function set terminou(value:Boolean):void {
			_terminou = value;
		}
	}
	
}