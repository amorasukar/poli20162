package {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	* @author Amora
	*/
	public class PortaAvioesFigura extends MovieClip {				
		public var figura:MovieClip;
		public var pecas:Array;
		private var xIni:Number;
		private var yIni:Number;
		private var _NOME:String = "P";
		private var _orientacao:int;
		
		public function PortaAvioesFigura() {
			super();			
			this.figura = this.figura_mc;
			this.figura.visible = true;
			this.pecas = [this.figura.peca1_mc, this.figura.peca2_mc, this.figura.peca3_mc, this.figura.peca4_mc];
			this.xIni = this.figura.x;
			this.yIni = this.figura.y;
			
			this.figura.addEventListener(MouseEvent.MOUSE_DOWN, this.iniciarArrasto);
			this.figura.addEventListener(MouseEvent.MOUSE_UP, this.terminarArrasto);
			this.orientacao = 0;
			
		}		
		
		public function voltarPosicaoInicial():void {
			this.figura.x = this.xIni;
			this.figura.y = this.yIni;
		}
		
		private function iniciarArrasto(m:MouseEvent):void {
			this.dispatchEvent( new Event( EventosBatalhaNaval.APAGARPECASPORTAAVIOES ) );
			this.figura.startDrag(true);
		}
				
		private function terminarArrasto(m:Event):void {
			this.figura.stopDrag();
			this.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.SOLTAREMBARCACAO));
		}
		
		public function configurar():void {
			
		}
		
		private function isImpar(numero:Number):Boolean {
			var retorno:Boolean = false;
			if ((numero%2) != 0) {
				retorno = true;
			}
			return retorno;
		}
		
		public function get orientacao():int { return _orientacao; }
		
		public function set orientacao(value:int):void {
			_orientacao = value;
		}
		
		public function get NOME():String { return _NOME; }
		
		public function set NOME(value:String):void {
			_NOME = value;
		}
	}
}