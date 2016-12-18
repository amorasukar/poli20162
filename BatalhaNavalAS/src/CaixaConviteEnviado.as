package {
	import fl.controls.Button;
	import fl.controls.TextArea;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;	
	
	/**
	 * @author Jessica
	 */
	public class CaixaConviteEnviado extends MovieClip {
		
		private var _nome:String;
		private var texto:String;
		private var campo:TextArea;
		private var botao:Button;
		
		public function CaixaConviteEnviado(nome:String) {
			this.nome = nome;
			this.texto = "Você convidou " + this.nome + " para jogar.";
			this.texto += "\nAguarde a resposta...";
			this.campo = this.campo_txt;
			this.campo.text = this.texto;
			this.botao = this.botao_btn;
			
			this.botao.addEventListener(MouseEvent.MOUSE_UP, this.clicar);
		}
		
		private function clicar(e:MouseEvent):void{
			switch (this.botao.label) {
				case "Cancelar":this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.CANCELARCONVITE) ); //Vai ser necessario enviar msh para o servidor
								break;
				case "Escolher":this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.ESCOLHERNOVOOPONENTE) ); //Aqui n vai ser necessario enviar msg. A classe ConvidandoOponente sozinha tratará esse evento.
								break;
			}					
		}
		
		public function mudarEstado(tipo:String):void {
			if (tipo == "respostaNegativa") {
				trace("CaixaConviteEnviado: receberRecusa");
				this.botao.label = "Escolher";
				this.campo.text += "\n" + this.nome + " recusou o seu convite."
				this.campo.text += "\nEscolha outro oponente."
			}
			else if (tipo == "respostaPositiva") {
				this.botao.enabled = false;
				this.botao.removeEventListener(MouseEvent.MOUSE_UP, this.clicar);
				this.campo.text += "\n" + this.nome + " aceitou o seu convite."
				this.campo.text += "\nVocê será encaminhado para o jogo."			
			}
			else if (tipo == "cancelamento") {
				this.botao.label = "Escolher";
				this.campo.text += "\nVocê cancelou o convite."
				this.campo.text += "\nEscolha outro oponente."
			}
			else {
				trace("Essa opcao n existe.");
			}
			
		}				
		
		public function get nome():String { return _nome; }
		
		public function set nome(value:String):void {
			_nome = value;
		}
		
	}
	
}