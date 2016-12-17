package {
	
	/**
	 * ...
	 * @author Saulo e Lorena
	 */
	public class Humano extends Jogador {
		private var _senha:String;
		private var _id:String;
		
		public function Humano(nome:String, senha:String) {
			super(nome);
		}
		
		public function get senha():String { 
			return _senha;
		}
		
		public function set senha(value:String):void {
			_senha = value;
		}
		
		public function get id():String { 
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
	}
	
}