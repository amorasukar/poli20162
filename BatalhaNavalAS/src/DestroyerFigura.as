package {
	import flash.display.MovieClip;
	import fl.controls.Button;
	import flash.events.MouseEvent
	import flash.events.Event;
	
	/**
	* @author Amora
	*/
	public class DestroyerFigura extends MovieClip {
		public var figura:MovieClip;
		public var pecas:Array;
		private var xIni:Number;
		private var yIni:Number;
		private var _NOME:String = "D";
		private var _orientacao:int;		
		
		public function DestroyerFigura() {
			super();
			this.figura = this.figura_mc;
			this.figura.visible = true;
			this.pecas = [this.figura.peca1_mc, this.figura.peca2_mc, this.figura.peca3_mc];
			this.xIni = this.figura.x;
			this.yIni = this.figura.y;
			this.orientacao = 0;
			
			
			this.figura.addEventListener(MouseEvent.MOUSE_DOWN, this.iniciarArrasto);
			this.figura.addEventListener(MouseEvent.MOUSE_UP, this.terminarArrasto);
			this.addEventListener(EventosBatalhaNaval.FORATABULEIRO, voltarPosicaoInicial);
		}
		
		public function voltarPosicaoInicial():void {
			this.figura.x = this.xIni;
			this.figura.y = this.yIni;
		}
		
		private function iniciarArrasto(m:MouseEvent):void {
			this.dispatchEvent( new Event( EventosBatalhaNaval.APAGARPECASDESTROYER ) );
			this.figura.startDrag(true);
		}
				
		private function terminarArrasto(m:Event):void {
			this.figura.stopDrag();
			this.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.SOLTAREMBARCACAO));
		}
		
		public function configurar():void {
			
		}
		
		private function definirOrientacao(numero:Number):int {
			trace("numero: "+numero)
			var retorno:int = 0;
			switch(Math.abs(numero)) {
				case 0:
					retorno = 0;
					break;
				case 1:
					retorno = 1;
					break;
				case 2:
					retorno = 2;
					break;
				case 3:
					retorno = 3;
					break;
				case 4:
					retorno = 0;
					this.figura.rotation = 0;
					break;
			}
			return retorno;
		}
		
		public function get NOME():String { return _NOME; }
		
		public function set NOME(value:String):void {
			_NOME = value;
		}
		
		public function get orientacao():int { return _orientacao; }
		
		public function set orientacao(value:int):void {
			_orientacao = value;
		}
	}
}