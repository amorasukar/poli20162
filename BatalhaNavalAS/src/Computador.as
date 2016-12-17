package {
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class Computador extends Jogador {	
		private var inteligencia:Inteligencia;
		
		public function Computador(nome:String) {
			super(nome);			
		}	
		
		public function criarInteligencia(tabuleiro:Tabuleiro):void {
			this.inteligencia = new Inteligencia(tabuleiro);
		}				
		
		public function escolherJogada():Jogada {
			return( this.inteligencia.escolherJogada() );
		}
		
		public function atingirPeca():void{
			this.inteligencia.atingirPeca();
		}
		
		public function acertarAgua():void {
			this.inteligencia.acertarAgua();
		}		
		
		public function abaterEmbarcacao(embarcacao:Embarcacao):void {
			this.inteligencia.abaterEmbarcacao(embarcacao);
		}
								
	}
	
}