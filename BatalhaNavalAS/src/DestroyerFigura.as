package {
	import flash.display.MovieClip;
	import fl.controls.Button;
	import flash.events.MouseEvent
	import flash.events.Event;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class DestroyerFigura extends MovieClip {
		public var figura:MovieClip;
		private var mais90:Button;
		private var menos90:Button;
		public var pecas:Array;
		private var xIni:Number;
		private var yIni:Number;
		private var _NOME:String = "D";
		private var _orientacao:int;		
		
		public function DestroyerFigura() {
			super();
			//trace("Lorena comentou todo o construtor de DestroyerFigura.as");
			this.figura = this.figura_mc;
			this.figura.visible = true;
			this.mais90 = this.mais90_mc;
			this.menos90 = this.menos90_mc;
			this.pecas = [this.figura.peca1_mc, this.figura.peca2_mc, this.figura.peca3_mc];
			this.xIni = this.figura.x;
			this.yIni = this.figura.y;
			this.orientacao = 0;
			
			
			this.figura.addEventListener(MouseEvent.MOUSE_DOWN, this.iniciarArrasto);
			this.figura.addEventListener(MouseEvent.MOUSE_UP, this.terminarArrasto);
			
			this.addEventListener(MouseEvent.ROLL_OVER, this.aparecer);
			this.addEventListener(MouseEvent.ROLL_OUT, this.desaparecer);
			this.addEventListener(EventosBatalhaNaval.FORATABULEIRO, voltarPosicaoInicial);
			
			this.mais90.addEventListener(MouseEvent.MOUSE_UP, this.rotacionar);
			this.menos90.addEventListener(MouseEvent.MOUSE_UP, this.rotacionar);
		}
		
		public function voltarPosicaoInicial():void {
			this.figura.x = this.xIni;
			this.figura.y = this.yIni;
		}
		
		private function iniciarArrasto(m:MouseEvent):void {
			this.dispatchEvent( new Event( EventosBatalhaNaval.APAGARPECASDESTROYER ) );
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
				this.orientacao++;
			}
			else {
				this.figura.rotation -= 90;
				this.orientacao--;
			}
			/*var valor:Number = (this.figura.rotation < 0)?(360 - this.figura.rotation):this.figura.rotation;
			this.orientacao = this.definirOrientacao(valor / 90);-*/
			
			if (this.orientacao == -1) {
				this.orientacao = 3;
			}
			else if (this.orientacao == 4) {
				this.orientacao = 0;
			}
			trace("this.orientacao: " + this.orientacao);
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