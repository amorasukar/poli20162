package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author Amora
	 */
	public class ControleIntroducao extends MovieClip {
		
		
		public function ControleIntroducao() {
			this.verRegras_btn.addEventListener(MouseEvent.MOUSE_UP, this.verRegras);
		}
		
		private function verRegras(e:MouseEvent):void {
			this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.INTRODUCAOPASSARTELA) );
		}
	}
	
}