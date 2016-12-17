package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class Frota extends MovieClip{
		private var _submarino:Embarcacao;
		private var _portaAvioes:Embarcacao;
		private var _destroyer:Embarcacao;
		private var _embarcacoes:Array;
		
		private var _ultimaEmbarcacaoAbatida:Embarcacao;
		
		public function Frota() {
			this._submarino = new Embarcacao("submarino");
			this._portaAvioes = new Embarcacao("porta-aviões");
			this._destroyer = new Embarcacao("destroyer");
			this._embarcacoes = [this.submarino, this.portaAvioes, this.destroyer];
			
			for (var i:int = 0; i < this.embarcacoes.length; i++) {
				this.embarcacoes[i].addEventListener(EventosBatalhaNaval.ABATEREMBARCACAO, this.abaterEmbarcacao);
			}
			
		}
		
		private function abaterEmbarcacao(e:Event):void {
			this._ultimaEmbarcacaoAbatida = Embarcacao(e.target);
			this.dispatchEvent(new Event(EventosBatalhaNaval.ABATEREMBARCACAO));
			this.verificarFim();
		}
		
		private function verificarFim():void {			
			var contador:int = 0;
			for (var i:int = 0; i < this.embarcacoes.length; i++) {
				if (this.embarcacoes[i].estado == EstadoEmbarcacao.EMBARCACAOABATIDA) {
					contador++;
				}
			}
			trace(contador + " == " + this.embarcacoes.length);
			if (contador == this.embarcacoes.length) {
				trace("Frota: disparou terminarJogo");
				this.dispatchEvent( new Event(EventosBatalhaNaval.TERMINARJOGO) );
			}
		}
		
		public function get submarino():Embarcacao { 
			return _submarino;
		}
		
		public function get portaAvioes():Embarcacao { 
			return _portaAvioes;
		}
		
		public function get destroyer():Embarcacao { 
			return _destroyer;
		}
		
		public function get embarcacoes():Array { 
			return _embarcacoes;
		}	
		
		public function get ultimaEmbarcacaoAbatida():Embarcacao { 
			return _ultimaEmbarcacaoAbatida;
		}
		
	}
	
}