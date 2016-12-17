package {
	import fl.controls.Button;
	import fl.controls.TextArea;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * @author Jessica
	 */
	public class CaixaGeral extends MovieClip {
		private var _campo:TextArea;
		private var _ok:Button;
		
		public function CaixaGeral(texto:String) {
			this.campo = this.campo_txt;
			this.campo.text = texto;
			this.ok = this.ok_btn;
			this.ok.addEventListener(MouseEvent.MOUSE_UP, this.clicar);
		}
		
		private function clicar(e:MouseEvent):void {
			this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.CAIXAGERALOK) );
		}
		
		public function get campo():TextArea {
			return _campo;
		}
		
		public function set campo(value:TextArea):void {
			_campo = value;
		}
		
		public function get ok():Button { 
			return _ok;
		}
		
		public function set ok(value:Button):void {
			_ok = value;
		}
	}
}