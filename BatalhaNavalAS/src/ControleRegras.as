package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class ControleRegras extends MovieClip {
		private var clicar_evt:Event;
		
		public function ControleRegras() {
			this.clicar_evt = new EventosBatalhaNaval(EventosBatalhaNaval.REGRASPASSARTELA);
			this.configurar();
		}		
		
		private function configurar():void{
			this.ok_btn.addEventListener(MouseEvent.MOUSE_UP, this.clicar);
		}
		
		private function clicar(e:MouseEvent):void {
			this.dispatchEvent(this.clicar_evt);
		}
	}
	
}