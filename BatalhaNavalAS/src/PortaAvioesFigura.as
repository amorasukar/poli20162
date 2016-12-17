package {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class PortaAvioesFigura extends MovieClip {				
		public var figura:MovieClip;
		private var mais90:Button;
		private var menos90:Button;
		//private var terminarArrasto_evt:Event;
		public var pecas:Array;
		private var xIni:Number;
		private var yIni:Number;
		private var _NOME:String = "P";
		private var _orientacao:int;
		
		public function PortaAvioesFigura() {
			super();			
			this.figura = this.figura_mc;
			this.figura.visible = true;
			this.mais90 = this.mais90_mc;
			this.menos90 = this.menos90_mc;
			//this.quantidadePartes = 4;
			this.pecas = [this.figura.peca1_mc, this.figura.peca2_mc, this.figura.peca3_mc, this.figura.peca4_mc];
			this.xIni = this.figura.x;
			this.yIni = this.figura.y;
			//this.terminarArrasto_evt = new Event(EventosBatalhaNaval.SOLTAREMBARCACAO);
			
			this.figura.addEventListener(MouseEvent.MOUSE_DOWN, this.iniciarArrasto);
			this.figura.addEventListener(MouseEvent.MOUSE_UP, this.terminarArrasto);
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.aparecer);
			this.addEventListener(MouseEvent.ROLL_OUT, this.desaparecer);
			
			//this.addEventListener(EventosBatalhaNaval.FORATABULEIRO, voltarPosicaoInicial);
			
			this.mais90.addEventListener(MouseEvent.MOUSE_UP, this.rotacionar);
			this.menos90.addEventListener(MouseEvent.MOUSE_UP, this.rotacionar);
			this.orientacao = 0;
			
		}		
		
		public function voltarPosicaoInicial():void {
			this.figura.x = this.xIni;
			this.figura.y = this.yIni;
		}
		
		private function iniciarArrasto(m:MouseEvent):void {
			this.dispatchEvent( new Event( EventosBatalhaNaval.APAGARPECASPORTAAVIOES ) );
			this.desaparecer();
			this.figura.startDrag(true);
		}
				
		private function terminarArrasto(m:Event):void {
			this.figura.stopDrag();
			this.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.SOLTAREMBARCACAO));
			//this.dispatchEvent(new Event(EventosBatalhaNaval.SOLTAREMBARCACAO));
		}
		
		public function configurar():void {
			
		}
		
		private function aparecer(m:MouseEvent = null):void {
			this.mais90.visible =
			this.menos90.visible = true;
		}
		
		private function desaparecer(m:MouseEvent = null):void {
			this.mais90.visible = 
			this.menos90.visible = false;
		}
		
		private function rotacionar(e:Event = null):void {
			var fator:int;
			var botao:String = Button(e.currentTarget).name;
			if (botao == "mais90_mc") {
				this.figura.rotation += 90;
			}
			else {
				this.figura.rotation -= 90;
			}
			this.orientacao = (isImpar(this.figura.rotation / 90))? 1:0;
			if (orientacao == 0) {
				this.figura.rotation = 0;
			}
			else {
				this.figura.rotation = 90;
			}
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