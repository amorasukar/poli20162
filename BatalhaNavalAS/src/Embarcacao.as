package {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	* @author Jessica
	*/
	public class Embarcacao extends MovieClip {
		
		private var _nome:String;
		public var quantidadePecas:int;
		public var quantidadePecasAtingidas:int;
		public var estado:String;
		public var pecas:Array;
		private var _observadores:Array;
		private var _ultimaPecaClicada:Peca;
		
		public function Embarcacao(nome) {
			this._nome = nome;
			this.estado = EstadoEmbarcacao.EMBARCACAOPERFEITA;
			this.pecas = [];
		}
		
		public function adicionarPeca(peca:Peca):void {
			this.pecas.push(peca);
			peca.observadores = new Array(this);
			this.quantidadePecas = this.pecas.length;			
		}
		
		public function atualizar(tipo:String, peca:Peca):void {						
			peca.estado = EstadoPeca.PECAATINGIDA;
			this.ultimaPecaClicada = peca;
			
			var contadorPecasAtingidas:int = 0;
			for (var i:int = 0; i < this.pecas.length; i++) {
				if (this.pecas[i].estado == EstadoPeca.PECAATINGIDA) {
					contadorPecasAtingidas++;					
				}
			}
			if (contadorPecasAtingidas == this.pecas.length) { //Se todas as pecas foram atingidas, abater embarcacao
				this.abater();
				this.estado = EstadoEmbarcacao.EMBARCACAOABATIDA;				
			}
			else if (contadorPecasAtingidas == 1) {
				this.estado = EstadoEmbarcacao.EMBARCACAOATINGIDA;
			}
			
			this.notificar();
		}
		
		private function notificar():void{
			for (var i:int = 0; i < this.observadores.length; i++) {
				this.observadores[i].atualizar("embarcacao", this);
			}
		}
		
		public function abater():void {
			this.estado = EstadoEmbarcacao.EMBARCACAOABATIDA;
			for (var i:int = 0; i < this.pecas.length; i++) {
				this.pecas[i].estado = EstadoPeca.PECAABATIDA;
			}
			this.dispatchEvent( new Event(EventosBatalhaNaval.ABATEREMBARCACAO) );
		}
		
		public function get nome():String { 
			return _nome;
		}
		
		public function get observadores():Array { 
			return _observadores;
		}
		
		public function set observadores(value:Array):void {
			_observadores = value;
		}
		
		public function get ultimaPecaClicada():Peca { 
			return _ultimaPecaClicada;
		}
		
		public function set ultimaPecaClicada(value:Peca):void {
			_ultimaPecaClicada = value;
		}
	}
}