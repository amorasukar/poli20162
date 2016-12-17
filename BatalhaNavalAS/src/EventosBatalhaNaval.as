package {
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Saulo e Lorena
	 */
	public class EventosBatalhaNaval extends Event {
		
		public static const CONEXAOACEITA: String = "conexaoAceita";
		public static const CONTINUAR: String = "continuar";
		public static const SAIR: String = "sair";
		public static const ACEITARCONVITE: String = "aceitarConvite";
		public static const RECUSARCONVITE: String = "recusarConvite";
		public static const CANCELARCONVITE: String = "cancelarConvite";
		public static const ESCOLHERNOVOOPONENTE: String = "escolherNovoOponente";
		public static const VOLTARCONVIDANDOOPONENTE: String = "voltarConvidandoOponente";
		public static const CAIXAGERALOK: String = "caixaGeralOk";
		public static const CAIXACONFIRMACAOSIM: String = "caixaConfirmacaoSim";
		public static const CAIXACONFIRMACAONAO: String = "caixaConfirmacaoNao";
		public static const INICIARJOGO: String = "iniciarJogo";
		
		/*Jogo*/
		public static const CLICARPECA: String = "clicarPeca";
		public static const ATINGIRPECA: String = "atingirPeca"; //Peca dispara para Embarcacao escutar e Tabuleiro dispara para Computador escutar.
		public static const ACERTARAGUA: String = "acertarAgua";		
		public static const ABATEREMBARCACAO: String = "abaterEmbarcacao";		
		public static const TERMINARJOGO: String = "terminarJogo";		
		
		public static const APAGARPECASDESTROYER: String = "apagarPecasDestroyer";		
		public static const APAGARPECASPORTAAVIOES: String = "apagarPecasPortaAvioes";		
		public static const APAGARPECASSUBMARINO: String = "apagarPecasSubmarino";		
		/*Fim de Jogo*/
		
		
		/* Passar telas */
		
		public static const REGRASPASSARTELA: String = "regrasPassarTela";
		public static const INTRODUCAOPASSARTELA: String = "introducaoPassarTela";
		public static const CONVIDANDOOPONENTEPASSARTELA: String = "convidandoOponentePassarTela";
		public static const LOGINPASSARTELA: String = "loginPassarTela";
		public static const CONVIDANDOPCPASSARTELA: String = "condidandoPcPassarTela";
		
		/* Fim de Passar telas */
		
		/*Distrubuir Frota*/
		public static const SOLTAREMBARCACAO: String = "soltarEmbarcacao";
		public static const FORATABULEIRO: String = "foraTabuleiro";
		
		
		public function EventosBatalhaNaval(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new EventosBatalhaNaval(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("EventosBatalhaNaval", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}