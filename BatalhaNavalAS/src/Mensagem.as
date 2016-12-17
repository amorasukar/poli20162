package {
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class Mensagem {
		private var _nomeCliente:String;
		private var _idCliente:int;
		private var _tipo:String;
		private var _texto:String;
		private var _idDestinatario:int;
		private var _senha:String;
		private var _linha:int;
		private var _coluna:int;
		private var _embarcacoes:String;
		
		public function Mensagem() {
			this.texto = "";
			this.nomeCliente = "";
			this.embarcacoes = "";
		}
		
		public function get idCliente():int { 
			return _idCliente;
		}
		
		public function set idCliente(value:int):void {
			_idCliente = value;
		}
		
		public function get tipo():String { 
			return _tipo;
		}
		
		public function set tipo(value:String):void {
			_tipo = value;
		}
		
		public function get texto():String { 
			return _texto;
		}
		
		public function set texto(value:String):void {
			_texto = value;
		}
		
		public function get nomeCliente():String { 
			return _nomeCliente;
		}
		
		public function set nomeCliente(value:String):void {
			_nomeCliente = value;
		}
		
		public function get idDestinatario():int { 
			return _idDestinatario;
		}
		
		public function set idDestinatario(value:int):void {
			_idDestinatario = value;
		}
		
		public function get senha():String { return _senha; }
		
		public function set senha(value:String):void {
			_senha = value;
		}
		
		public function get linha():int { return _linha; }
		
		public function set linha(value:int):void {
			_linha = value;
		}
		
		public function get coluna():int { return _coluna; }
		
		public function set coluna(value:int):void {
			_coluna = value;
		}
		
		public function get embarcacoes():String { return _embarcacoes; }
		
		public function set embarcacoes(value:String):void {
			_embarcacoes = value;
		}
		
		
		public function criarXML():String {
			var retorno_str:String = new String();
			retorno_str += "<servidor.Mensagem>";
			retorno_str += "<idCliente>" + this.idCliente + "</idCliente>";			
			retorno_str += "<tipo>" + this.tipo + "</tipo>";					
			retorno_str += "<texto>" + this.texto+ "</texto>";			
			retorno_str += "<nomeCliente>" + this.nomeCliente+ "</nomeCliente>";			
			retorno_str += "<idDestinatario>" + this.idDestinatario + "</idDestinatario>";	
			retorno_str += "<senha>" + this.senha + "</senha>";
			retorno_str += "<linha>" + this.linha + "</linha>";
			retorno_str += "<coluna>" + this.coluna + "</coluna>";
			retorno_str += "<embarcacoes>"+this.embarcacoes+"</embarcacoes>";
			retorno_str += "</servidor.Mensagem>";
			return retorno_str;
		}
	}
	
}