package {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class Resultado extends MovieClip {
		private var tipo:String;
		private var alvo:MovieClip;
		/*public var continuar_evt:Event;
		public var sair_evt:Event;
		private var sim:Button;
		private var nao:Button;*/
		
		public function Resultado() {			
			this.alvo = this.alvo_mc;					
			/*this.sim = this.sim_btn;
			this.nao = this.sim_btn;
			
			this.sim.addEventListener(MouseEvent.MOUSE_UP, this.clicar);
			this.nao.addEventListener(MouseEvent.MOUSE_UP, this.clicar);*/
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
		
		/*function clicar(e:MouseEvent):void{
			var botao_btn:Button = Button(e.currentTarget);
			if (botao_btn.name == "sim_btn") {
				this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.CONTINUAR) );
			}
			else {
				this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.SAIR) );
			}
		}*/
	}
	
}