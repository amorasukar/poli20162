package {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* @author Amora
	*/
	public class Resultado extends MovieClip {
		private var tipo:String;
		private var alvo:MovieClip;
		
		public function Resultado() {			
			this.alvo = this.alvo_mc;					
		}
		
		public function configurar(tipo:String):void {
			this.tipo = tipo;
			var figura_mc:MovieClip;
			if (this.tipo == TipoResultado.GANHOU) {
				figura_mc = new VcGanhou();
				this.alvo.addChild(figura_mc);
			}
			else {
				figura_mc = new VcPerdeu();
				this.alvo.addChild(figura_mc);
			}
		}
	}
	
}