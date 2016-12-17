package {
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.XMLSocket;
	import flash.events.DataEvent;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class ControleLogin extends MovieClip {
		
		private var comunicacao:XMLSocket;
		private var conexaoAceita_evt:Event;
		private var _idCliente:int;
		
		private var nomeCampo:TextArea;
		private var senhaCampo:TextInput;
		private var _nome:String;
		private var _senha:String;
		
		private var ipCampo:TextInput;
		
		public function ControleLogin(socket:XMLSocket) {
			this.nomeCampo = this.nome_txt;
			this.senhaCampo = this.senha_txt;
			this.ipCampo = this.ip_txt;
			this.nomeCampo.tabIndex = 1;
			this.senhaCampo.tabIndex = 2;
			this.ipCampo.tabIndex = 3;
			this.log_txt.tabEnabled = false;
			this.configurar();
			this.comunicacao = socket;
			this.conexaoAceita_evt = new EventosBatalhaNaval(EventosBatalhaNaval.CONEXAOACEITA);			
		}
		
		public function configurar():void {			
			this.nomeCampo.addEventListener(Event.CHANGE, this.modificar);						
			this.senhaCampo.addEventListener(Event.CHANGE, this.modificar);	
			this.ipCampo.addEventListener(Event.CHANGE, this.modificar);
			//this.humano_rb.addEventListener(Event.CHANGE, this.modificar);			
			//this.computador_rb.addEventListener(Event.CHANGE, this.modificar);
			this.ok_btn.addEventListener(MouseEvent.MOUSE_UP, this.logar);
		}	
		
		private function modificar(e:Event):void {			
			if ( (this.nomeCampo.text != "") && (this.senhaCampo.text != "")  && (this.ipCampo.text != "")/*&& (this.humano_rb.selected || this.computador_rb.selected)*/ ) {
				this.ok_btn.enabled = true;
			}
			else {
				this.ok_btn.enabled = false;
			}
		}
				
		private function logar(e:Event):void {
			//this.ok_btn.removeEventListener(MouseEvent.MOUSE_UP, this.logar);
			this.ok_btn.enabled = false;
			
			this.nome = this.nomeCampo.text;
			this.senha = this.senhaCampo.text;
			//if (this.humano_rb.selected) {
				this.log_txt.htmlText += "Conectando ao servidor...";
				//this.comunicacao.addEventListener(Event.CONNECT, confirmarConexao);
				//this.comunicacao.connect("localhost", 8090);
				this.comunicacao.connect(this.ipCampo.text, 8090);
				this.enviarNome();				
			/*}
			else {
				this.dispatchEvent(new Event(EventosBatalhaNaval.LOGINPASSARTELA));
			}*/
		}				
		
		public function enviarNome():void {
			var mensagem:Mensagem = new Mensagem();
			mensagem.tipo = "envioNome";
			//mensagem.idCliente = this.idCliente;
			mensagem.texto = this.nome_txt.text;
			mensagem.senha = this.senha;
			this.comunicacao.send(mensagem.criarXML());
		}
		
		private function confirmarConexao(e:Event):void {
			//var xml:XML = XML(e.data);
			this.log_txt.htmlText += "Conexão realizada com sucesso.";
			this.dispatchEvent(this.conexaoAceita_evt);
		}
		
		public function get idCliente():int { 
			return _idCliente;
		}
		
		public function set idCliente(value:int):void {
			_idCliente = value;
		}
		
		public function get nome():String { 
			return _nome;
		}
		
		public function set nome(value:String):void {
			_nome = value;
		}
		
		public function get senha():String { 
			return _senha;
		}
		
		public function set senha(value:String):void {
			_senha = value;
		}
		
		
	}
	
}