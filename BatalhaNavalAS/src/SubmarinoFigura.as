package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	* @author Amora
	*/
	public class SubmarinoFigura extends MovieClip {
		public var figura:MovieClip;
		
		public var pecas:Array;
		private var xIni:Number;
		private var yIni:Number;
		private var _NOME:String = "S";
		private var _orientacao:int;
		
		public function SubmarinoFigura() {
			super();	
			this.figura = this.figura_mc;
			this.figura.visible = true;
			this.pecas = [this.figura.peca1_mc];
			this.xIni = this.figura.x;
			this.yIni = this.figura.y;
			this.orientacao = 0;
			
			this.figura.addEventListener(MouseEvent.MOUSE_DOWN, this.iniciarArrasto);
			this.figura.addEventListener(MouseEvent.MOUSE_UP, this.terminarArrasto);
		}
		
		public function voltarPosicaoInicial():void {
			this.figura.x = this.xIni;
			this.figura.y = this.yIni;
		}
		
		private function iniciarArrasto(m:MouseEvent):void {
			this.dispatchEvent( new Event( EventosBatalhaNaval.APAGARPECASSUBMARINO ) );
			this.figura.startDrag(true);
		}
				
		private function terminarArrasto(m:Event):void {
			this.figura.stopDrag();
			this.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.SOLTAREMBARCACAO));
		}
		
		public function configurar():void {
			
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