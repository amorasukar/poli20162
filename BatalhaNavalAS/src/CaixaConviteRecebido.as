package {
	import fl.controls.Button;
	import fl.controls.TextArea;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	
	/**
	 * @author Jessica
	 */
	public class CaixaConviteRecebido extends MovieClip {
		
		private var _nome:String;
		private var texto:String;
		private var campo:TextArea;
		private var aceitar:Button;
		private var recusar:Button;
		private var ok:Button;
		
		public function CaixaConviteRecebido(nome:String) {
			this.nome = nome;
			this.texto = nome + " está te convidando para jogar.";
			this.campo = this.campo_txt;
			this.campo.text = this.texto;
			this.aceitar = this.aceitar_btn;
			this.recusar = this.recusar_btn;
			this.ok = this.ok_btn;
			
			this.aceitar.addEventListener(MouseEvent.MOUSE_UP, this.aceitarConvite);
			this.recusar.addEventListener(MouseEvent.MOUSE_UP, this.recusarConvite);
		}
		
		private function aceitarConvite(e:MouseEvent):void {
			this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.ACEITARCONVITE) );
		}
		
		private function recusarConvite(e:MouseEvent):void {
			this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.RECUSARCONVITE) );
		}
		
		public function receberCancelamento():void {
			this.campo.text += "\n" + this.nome + " cancelou o convite.";
			this.ok.visible = true;
			this.ok.addEventListener(MouseEvent.MOUSE_UP, this.voltarConvidandoOponente);
			
			this.aceitar.visible = false;
			this.aceitar.removeEventListener(MouseEvent.MOUSE_UP, this.aceitarConvite);
			this.recusar.visible = false;
			this.recusar.removeEventListener(MouseEvent.MOUSE_UP, this.recusarConvite);
		}
		
		private function voltarConvidandoOponente(e:MouseEvent):void{
			this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.VOLTARCONVIDANDOOPONENTE) );
		}
		
		public function enviarAceitacao():void {
			this.campo.text += "\nVocê aceitou o convite."
			this.campo.text += "\nVocê será redirecionado para o jogo em instantes."
		}
		
		public function enviarRecusa():void {
			this.campo.text += "\nVocê recusou o convite."			
		}
		
		public function get nome():String { return _nome; }
		
		public function set nome(value:String):void {
			_nome = value;
		}
	}
	
}