package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* @author Jessica
	*/
	public class Peca extends MovieClip {
		private var _linha:int;
		private var _coluna:int;
		private var _estado:String;
		private var _observadores:Array;
		
		public function Peca() {
			var nome:String = this.name;
			this._linha = int(this.name.substr(4, 1));
			this._coluna = int(this.name.substr(5, 1));
			this.estado = EstadoPeca.PECAOCULTA;
			this.observadores = new Array();
			this.addEventListener(MouseEvent.MOUSE_UP, this.clicar);
		}
				
		public function clicar(e:Event = null):void {	
			this.mouseEnabled = false;
			this.notificar();			
		}
		
		public function get estado():String { 
			return _estado;
		}
		
		public function set estado(value:String):void {				
			_estado = value;
			this.gotoAndStop(this.estado);
		}
		
		private function notificar():void {
			for (var i:int = 0; i < this.observadores.length; i++) {
				this.observadores[i].atualizar("peca", this);
			}
		}
		
		public function get linha():int { 
			return _linha;
		}
		
		private function set linha(value:int):void {
			_linha = value;
		}
		
		public function get coluna():int {
			return _coluna;
		}
		
		private function set coluna(value:int):void {
			_coluna = value;
		}
		
		public function get observadores():Array { 
			return _observadores;
		}
		
		public function set observadores(value:Array):void {
			_observadores = value;
		}
			
	}
	
}