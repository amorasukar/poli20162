package {
	import fl.controls.Button;
	import fl.controls.TextArea;
	import flash.display.MovieClip;
	import flash.events.MouseEvent
	
	/**
	 * @author Jessica
	 */
	public class CaixaConfirmacao extends MovieClip {
		
		private var texto:String;
		private var campo:TextArea;
		private var sim:Button;
		private var nao:Button;
		
		public function CaixaConfirmacao(texto:String) {
			this.texto = texto;
			this.campo = this.campo_txt;
			this.sim = this.sim_btn;
			this.nao = this.nao_btn;
			this.campo.text = this.texto;
			this.sim.addEventListener(MouseEvent.MOUSE_UP, this.clicarSim);
			this.nao.addEventListener(MouseEvent.MOUSE_UP, this.clicarNao);
			
		}
		
		private function clicarNao(e:MouseEvent):void {
			this.nao.removeEventListener(MouseEvent.MOUSE_UP, clicarNao);
			this.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.CAIXACONFIRMACAONAO))
		}
		
		private function clicarSim(e:MouseEvent):void {
			this.sim.removeEventListener(MouseEvent.MOUSE_UP, clicarSim);
			this.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.CAIXACONFIRMACAOSIM))
			
		}
		
		
	}
	
}