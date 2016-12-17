package {
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class Jogada {
		private var _linha:int;
		private var _coluna:int;
		
		public function Jogada(linha:int, coluna:int) {
			this.linha = linha;
			this.coluna = coluna;
			trace("Jogada = (" + linha + ", " + coluna + ")");
		}
		
		public function get linha():int { 
			return _linha;
		}
		
		public function set linha(value:int):void {
			_linha = value;
		}
		
		public function get coluna():int { 
			return _coluna;
		}
		
		public function set coluna(value:int):void {
			_coluna = value;
		}
	}
	
}