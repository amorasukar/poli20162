package {
	import fl.controls.Button;
	import fl.controls.progressBarClasses.IndeterminateBar;
	import fl.controls.TextArea;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.XMLSocket;
	
	/**
	* ...
	* @author Lorena Tablada
	*/
	public class ControleDistribuindoFrota extends MovieClip{
		
		private var submarino:MovieClip;
		private var destroyer:MovieClip;
		private var portaAvioes:MovieClip;
		private var _tabuleiro:MovieClip;
		private var _matrizTabuleiro:Array; //Matriz que auxilia na configuracao do tabuleiro.
		
		private var fala:TextArea;
		private var log:TextArea;
		
		
		/*Botoes*/
		private var sair:Button;
		private var enviar:Button;
		private var iniciarJogo:Button;
		/*Fim de Botoes*/
		
		/*Comunicacao*/
		private var comunicacao:XMLSocket;
		private var idCliente:int;
		/*Fim de Comunicacao*/
		
		/*Frota*/
		private var frota:Array;
		/*Fim frota*/
		
		/*Oponente*/
		private var tipoOponente:String;
		/*Fim Oponente*/
		
		public function ControleDistribuindoFrota(socket:XMLSocket, id:int, tipoOponente:String) {
			/*Comunicacao*/
			this.comunicacao = socket;
			this.idCliente = id;
			/*Fim de Comunicacao*/
			
			this.tipoOponente = tipoOponente;
			
			this.submarino = this.frota_mc.submarino_mc;
			this.submarino.addEventListener(EventosBatalhaNaval.APAGARPECASSUBMARINO, this.apagarPecasSubmarino);
			this.destroyer = this.frota_mc.destroyer_mc;
			this.destroyer.addEventListener(EventosBatalhaNaval.APAGARPECASDESTROYER, this.apagarPecasDestroyer);
			this.portaAvioes = this.frota_mc.portaAvioes_mc;			
			this.portaAvioes.addEventListener(EventosBatalhaNaval.APAGARPECASPORTAAVIOES, this.apagarPecasPortaAvioes);
			this._tabuleiro = this.tabuleiro_mc;
			this.tabuleiro.liberarClique(false);
			
			/*Botoes*/
			this.sair = this.sair_btn;
			this.sair.addEventListener(MouseEvent.MOUSE_UP, this.clicarSair);
			this.enviar = this.enviar_btn;
			this.iniciarJogo = this.iniciarJogo_btn;
			this.iniciarJogo.addEventListener(MouseEvent.MOUSE_UP, pressionarIniciarJogo);
			this.enviar.addEventListener(MouseEvent.MOUSE_UP, this.enviarTexto);
			/*Fim de Botoes*/
			
			this.log = this.log_txt;
			this.fala = this.fala_txt;
			this.fala.addEventListener(Event.CHANGE, this.habilitarEnviar);
			
			this.frota = new Array();
			
			this.inicializarMatriz();
			this.configurar();
			this.liberar();
		}
		
		private function apagarPecasSubmarino(e:Event):void {
			this.apagarPecas(2);
		}
		private function apagarPecasPortaAvioes(e:Event):void {
			this.apagarPecas(1);
		}
		private function apagarPecasDestroyer(e:Event):void {
			this.apagarPecas(0);
		}
		
		private function habilitarEnviar(e:Event):void{
			if (this.fala.text != "") {
				this.enviar.enabled = true;
			}
			else {
				this.enviar.enabled = false;
			}
		}
		
		private function enviarTexto(e:MouseEvent):void{
			var msg:Mensagem = new Mensagem();			
			msg.texto = this.fala.text;
			msg.tipo = "conversaFrota";
			this.comunicacao.send( msg.criarXML() );
			this.fala.text = "";
			this.enviar.enabled = false;
		}
		
		public function receberFala(remetente:String, fala:String):void {
			this.log_txt.text += (remetente + " falou: " + fala + "\n");
		}
		
		private function inicializarMatriz():void {
			this._matrizTabuleiro = new Array(10);
			for (var i:int = 0; i < 10; i++) {
				this._matrizTabuleiro[i] = new Array(10);
				for (var j:int = 0; j < 10; j++) {
					this._matrizTabuleiro[i][j] = "X";
				}						
			}
		}
		
		private function mostrarMatrizTabuleiro():void {
			for (var i:int = 0; i < 10; i++) {
				trace("this._matrizTabuleiro["+i+"] = "+ this._matrizTabuleiro[i]);
			}
		}
		
		private function pressionarIniciarJogo(e:Event):void {
			var msg:Mensagem = new Mensagem();
			msg.tipo = "frotaDistribuida";
			this.comunicacao.send(msg.criarXML());
			if (this.tipoOponente == "Computador") {
				this.dispatchEvent(new Event(EventosBatalhaNaval.INICIARJOGO));
			}else {
				habilitar(false);
				this.log.text += "\nAguardando confirmação";
			}
			
		}
		
		private function clicarSair(e:MouseEvent):void {
			this.dispatchEvent( new EventosBatalhaNaval(EventosBatalhaNaval.SAIR) );			
		}				
		
		public function habilitar(novoEstado:Boolean):void {
			
			if (novoEstado) {
				if (this.fala.text != "") {
					this.enviar.enabled = 
					this.enviar.mouseEnabled = novoEstado;
				}
			}else {
				this.enviar.enabled = 
				this.enviar.mouseEnabled = novoEstado;
			}
			this.fala.editable =
			this.sair.enabled = 
			this.sair.mouseEnabled =
			this.iniciarJogo.mouseEnabled =
			this.iniciarJogo.enabled = novoEstado;//falta criar condicao para habilitar o iniciarJogo
		}
		
		private function configurar():void {
			/*this.frota_mc.submarinoLinha_mc.visible =
			this.frota_mc.destroyerLinha_mc.visible =
			this.frota_mc.portaAvioesLinha_mc.visible = false;*/
			
			if (this.tipoOponente == "Computador") {
				this.fala.enabled =
				this.fala.editable =
				this.fala.mouseEnabled = false;				
			}/*else {*/
				//this.distribuirPecas();
				//this.habilitar(true);

				this.portaAvioes.addEventListener(EventosBatalhaNaval.SOLTAREMBARCACAO, this.soltarEmbarcacao);
				this.destroyer.addEventListener(EventosBatalhaNaval.SOLTAREMBARCACAO, this.soltarEmbarcacao);
				this.submarino.addEventListener(EventosBatalhaNaval.SOLTAREMBARCACAO, this.soltarEmbarcacao);
			//}
			
			/*this.submarino.addEventListener(MouseEvent.MOUSE_DOWN, arrastarEmbarcacao);
			this.submarino.addEventListener(MouseEvent.MOUSE_UP, soltarEmbarcacao);*/
			
			
		}
		
		/*//Nem esse método, nem os 4 próximos serão usados aqui posteriormente. Eles estão aqui por enquanto que a frota ainda não está sendo distribuida através de arrasto.
		private function distribuirPecas():void {
			this.tabuleiro.inicializarFrota();
			this.distribuirDestroyer();
			this.distribuirPortaAvioes();
			this.distribuirSubmarino();
			
			this.mostrarMatrizTabuleiro();			
		}*/
		
		private function posicaoLegal(linha:int, coluna:int, embarcacao:String, orientacao:int = undefined):Boolean {
			var retorno:Boolean = true;
			if (embarcacao == "S") {
				for (var i:int = (linha - 1); i <= (linha + 1) ; i++) {
					for (var j:int = (coluna - 1); j <= (coluna + 1) ; j++) {
						if (  (i >= 0) && (j >= 0) && (i <= (this._matrizTabuleiro.length - 1) ) && (j <= (this._matrizTabuleiro.length - 1) ) ) {
							if (this._matrizTabuleiro[i][j] != "X") {
								retorno = false;
								break;
							}
						}
					}
				}
			}
			else if (embarcacao == "P") {
				if (orientacao == 0) {					
					for (var a:int = (linha - 1); a <= (linha + 1) ; a++) {
						for (var b:int = (coluna - 1); b <= (coluna + 4) ; b++) {
							if (  (a >= 0) && (b >= 0) && (a <= (this._matrizTabuleiro.length - 1) ) && (b <= (this._matrizTabuleiro.length - 1) ) ) {
								if (this._matrizTabuleiro[a][b] != "X") {
									retorno = false;
									break;
								}
							}
						}
					}
					
				}
				else {
					for (var c:int = (linha - 1); c <= (linha + 4) ; c++) {
						for (var d:int = (coluna - 1); d <= (coluna + 1) ; d++) {
							if (  (c >= 0) && (d >= 0) && (c <= (this._matrizTabuleiro.length - 1) ) && (d <= (this._matrizTabuleiro.length - 1) ) ) {
								if (this._matrizTabuleiro[c][d] != "X") {
									retorno = false;
									break;
								}
							}
						}
					}
				}
			}
			else if (embarcacao == "D") {
				if (orientacao == 0) {					
					for (var e:int = (linha - 1); e <= (linha + 3) ; e++) {
						for (var f:int = (coluna - 1); f <= (coluna + 2) ; f++) {
							if (  (e >= 0) && (f >= 0) && (e <= (this._matrizTabuleiro.length - 1) ) && (f <= (this._matrizTabuleiro.length - 1) ) ) {
								if( !( ( e == (linha - 1) ) && ( f == (coluna + 2) ) ) && !( ( e == (linha + 3) ) && ( f == (coluna + 2) ) ) ){
									if (this._matrizTabuleiro[e][f] != "X") {
										retorno = false;
										break;
									}
								}
							}
						}
					}
					
				}
				else if(orientacao == 1){
					for (var g:int = (linha - 1); g <= (linha + 2) ; g++) {
						for (var h:int = (coluna - 1); h <= (coluna + 3) ; h++) {
							if (  (g >= 0) && (h >= 0) && (g <= (this._matrizTabuleiro.length - 1) ) && (h <= (this._matrizTabuleiro.length - 1) ) ) {
								if( !( ( g == (linha + 2) ) && ( h == (coluna - 1) ) ) && !( ( g == (linha + 2) ) && ( h == (coluna + 3) ) ) ){
									if (this._matrizTabuleiro[g][h] != "X") {
										retorno = false;
										break;
									}
								}
							}
						}
					}
				}
				else if(orientacao == 2){
					for (var m:int = (linha - 2); m <= (linha + 2) ; m++) {
						for (var n:int = (coluna - 1); n <= (coluna + 2) ; n++) {
							if (  (m >= 0) && (n >= 0) && (m <= (this._matrizTabuleiro.length - 1) ) && (n <= (this._matrizTabuleiro.length - 1) ) ) {
								if( !( ( m == (linha - 2) ) && ( n == (coluna - 1) ) ) && !( ( m == (linha + 2) ) && ( n == (coluna - 1) ) ) ){
									if (this._matrizTabuleiro[m][n] != "X") {
										retorno = false;
										break;
									}
								}
							}
						}
					}
				}
				else{
					for (var o:int = (linha - 2); o <= (linha + 1) ; o++) {
						for (var p:int = (coluna - 1); p <= (coluna + 3) ; p++) {
							if (  (o >= 0) && (p >= 0) && (o <= (this._matrizTabuleiro.length - 1) ) && (p <= (this._matrizTabuleiro.length - 1) ) ) {
								if( !( ( o == (linha - 2) ) && ( p == (coluna - 1) ) ) && !( ( o == (linha - 2) ) && ( p == (coluna + 3) ) ) ){
									if (this._matrizTabuleiro[o][p] != "X") {
										retorno = false;
										break;
									}
								}
							}
						}
					}
				}
			}
			return retorno;
		}	
		
		/*private function distribuirSubmarino():void {
			var linha:int = Math.floor(Math.random()*this._matrizTabuleiro.length);
			var coluna:int = Math.floor(Math.random() * this._matrizTabuleiro[0].length);
			if ( this.posicaoLegal(linha, coluna, "S") ) {
				this._matrizTabuleiro[linha][coluna] = "P";
				
				this.tabuleiro.frota[2].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
			}
			else {
				trace("Submarino nao pode ficar na posicao: " + linha + ", " + coluna);
				this.distribuirSubmarino();
			}
		}
		
		private function distribuirPortaAvioes():void {
			var orientacao:int = Math.floor(Math.random() * 2); // 0 horizontal, 1 vertical.
			var linha:int;
			var coluna:int;
			if (orientacao == 0) { // horizontal
				linha = Math.floor(Math.random() * this._matrizTabuleiro.length);
				coluna = Math.floor( Math.random() * (this._matrizTabuleiro[0].length - 3) );
				if ( this.posicaoLegal(linha, coluna, "P", 0) ) {
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha][coluna + 1] = "P";
					this._matrizTabuleiro[linha][coluna + 2] = "P";
					this._matrizTabuleiro[linha][coluna + 3] = "P";	
					
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 1]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 3]);
				}
				else {
					this.distribuirPortaAvioes();
				}
			}
			else { // vertical
				linha = Math.floor( Math.random() * (this._matrizTabuleiro.length - 3) );
				coluna = Math.floor( Math.random() * this._matrizTabuleiro[0].length );
				if ( this.posicaoLegal(linha, coluna, "P", 1) ) {
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha + 1][coluna] = "P";
					this._matrizTabuleiro[linha + 2][coluna] = "P";
					this._matrizTabuleiro[linha + 3][coluna] = "P";			
					
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha + 2][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha + 3][coluna]);
				}
				else {
					this.distribuirPortaAvioes();
				}
			}						
		}
		
		private function distribuirDestroyer():void {
			var orientacao:int = 0//Math.floor(Math.random() * 4);
			var linha:int;
			var coluna:int;
			if (orientacao == 0) {				
				linha = Math.floor(Math.random() * (this._matrizTabuleiro.length - 2) );
				coluna = Math.floor( Math.random() * (this._matrizTabuleiro[0].length - 1) );				
				if ( this.posicaoLegal(linha, coluna, "D", 0) ) {					
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha + 1][coluna + 1] = "P";
					this._matrizTabuleiro[linha + 2][coluna] = "P";		
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 2][coluna]);					
				}
				else {
					this.distribuirDestroyer();
				}
			}
			else if(orientacao == 1){
				linha = Math.floor(Math.random() * (this._matrizTabuleiro.length - 1) );
				coluna = Math.floor( Math.random() * (this._matrizTabuleiro[0].length - 2) );
				if ( this.posicaoLegal(linha, coluna, "D", 1) ) {
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha][coluna + 2] = "P";
					this._matrizTabuleiro[linha + 1][coluna + 1] = "P";		
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
				}
				else {
					this.distribuirDestroyer();
				}
			}
			else if(orientacao == 2){
				linha = Math.floor(Math.random() * (this._matrizTabuleiro.length - 1) );
				coluna = Math.floor( Math.random() * (this._matrizTabuleiro[0].length - 1) );
				if ( this.posicaoLegal(linha, coluna, "D", 2) ) {
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha - 1][coluna + 1] = "P";
					this._matrizTabuleiro[linha + 1][coluna + 1] = "P";	
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha - 1][coluna + 1]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
				}
				else {
					this.distribuirDestroyer();
				}
			}
			else{
				linha = Math.floor(Math.random() * (this._matrizTabuleiro.length - 2) ) + 1;
				coluna = Math.floor( Math.random() * (this._matrizTabuleiro[0].length - 2) );
				if ( this.posicaoLegal(linha, coluna, "D", 3) ) {
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha - 1][coluna + 1] = "P";
					this._matrizTabuleiro[linha][coluna + 2] = "P";	
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha - 1][coluna + 1]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
				}
				else {
					this.distribuirDestroyer();
				}
			}						
		}*/
		
		private function soltarEmbarcacao(e:EventosBatalhaNaval):void {
			var movie:MovieClip = MovieClip(e.currentTarget);
			var posicoes:Array = this.localizarPosicoes(movie);
			var tipo:String = movie.NOME;
			var orientacao:int = movie.orientacao;
			
			trace(posicoes)
			if (movie.pecas.length != posicoes.length) {//quando a embarcacao esta fora do tabuleiro ou parte fora
				//movie.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.FORATABULEIRO));
				movie.voltarPosicaoInicial();
				
			}else if(this.verificarPecas(posicoes)) {
				//movie.dispatchEvent(new EventosBatalhaNaval(EventosBatalhaNaval.FORATABULEIRO));
				movie.voltarPosicaoInicial();
				trace("colocou embarcacao em cima de outra embarcacao");
				
			}else {
				
				switch(tipo) {
					case "P":
						this.posicionarPortaAvioes(movie,posicoes,tipo,orientacao);
						break;
					case "D":
						this.posicionarDestroyer(movie, posicoes, tipo, orientacao);
						break;
					case "S":
						this.posicionarSubmarino(movie, posicoes, tipo, orientacao);
						break;
				}
				
 				//var embarcacao:Embarcacao = new Embarcacao();
				/*switch(movie.NOME) {
					case "portaAviao":
						//CONTINUAR COM LORENA DAQUI
					break;
				}
				for (var i:int = 0; i < posicoes.length; i++) {
					var peca:Peca = this.tabuleiro.pecas[posicoes[i][0]][posicoes[i][1]];
					embarcacao.adicionarPeca(peca);
				}
				this.frota.push(embarcacao);*/
			}
			
			
			
			
		}
		
		private function posicionarSubmarino(movie:MovieClip,posicoes:Array,tipo:String,orientacao:int):void{
			var linha:int = posicoes[0][0];
			var coluna:int = posicoes[0][1];
			if (this.posicaoLegal(linha, coluna, tipo, orientacao)) {
				this._matrizTabuleiro[linha][coluna] = "P";
				
				this.tabuleiro.frota[2].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
				
				this.tabuleiro.pecas[linha][coluna].estado = EstadoPeca.PECAEXPOSTA;
			}
			this.mostrarMatrizTabuleiro();
			movie.voltarPosicaoInicial();
		}
		
		private function posicionarDestroyer(movie:MovieClip,posicoes:Array,tipo:String,orientacao:int):void{
			var linha:int;
			var coluna:int;
			var indice:int;
			
			switch(orientacao) {
				case 0:
					indice = this.pegarIndice(posicoes, "linha", "menor");
					linha = posicoes[indice][0];
					coluna = posicoes[indice][1];
					if (this.posicaoLegal(linha, coluna, tipo, orientacao)) {
						this._matrizTabuleiro[linha][coluna] = "P";
						this._matrizTabuleiro[linha + 1][coluna + 1] = "P";
						this._matrizTabuleiro[linha + 2][coluna] = "P";		
						
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 2][coluna]);
						
						this.tabuleiro.pecas[linha][coluna].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha + 1][coluna + 1].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha + 2][coluna].estado = EstadoPeca.PECAEXPOSTA;
					}
					break;
				case 1:
					indice = this.pegarIndice(posicoes, "coluna", "menor");
					linha = posicoes[indice][0];
					coluna = posicoes[indice][1];
					if (this.posicaoLegal(linha, coluna, tipo, orientacao)) {
						this._matrizTabuleiro[linha][coluna] = "P";
						this._matrizTabuleiro[linha][coluna + 2] = "P";
						this._matrizTabuleiro[linha + 1][coluna + 1] = "P";		
						
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
						
						this.tabuleiro.pecas[linha][coluna].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha][coluna + 2].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha + 1][coluna + 1].estado = EstadoPeca.PECAEXPOSTA;
					}
					break;
				case 2:
					indice = this.pegarIndice(posicoes, "coluna", "menor");
					linha = posicoes[indice][0];
					coluna = posicoes[indice][1];
					if (this.posicaoLegal(linha, coluna, tipo, orientacao)) {
						this._matrizTabuleiro[linha][coluna] = "P";
						this._matrizTabuleiro[linha - 1][coluna + 1] = "P";
						this._matrizTabuleiro[linha + 1][coluna + 1] = "P";	
						
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha - 1][coluna + 1]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
						
						this.tabuleiro.pecas[linha][coluna].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha - 1][coluna + 1].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha + 1][coluna + 1].estado = EstadoPeca.PECAEXPOSTA;
					}
					break;
				case 3:
					indice = this.pegarIndice(posicoes, "coluna", "menor");
					linha = posicoes[indice][0];
					coluna = posicoes[indice][1];
					if (this.posicaoLegal(linha, coluna, tipo, orientacao)) {
						this._matrizTabuleiro[linha][coluna] = "P";
						this._matrizTabuleiro[linha - 1][coluna + 1] = "P";
						this._matrizTabuleiro[linha][coluna + 2] = "P";	
						
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha - 1][coluna + 1]);
						this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
						
						this.tabuleiro.pecas[linha][coluna].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha - 1][coluna + 1].estado = EstadoPeca.PECAEXPOSTA;
						this.tabuleiro.pecas[linha ][coluna + 2].estado = EstadoPeca.PECAEXPOSTA;
					}
					break;
			}
			
			this.mostrarMatrizTabuleiro();
			movie.voltarPosicaoInicial();
		}
		
		private function posicionarPortaAvioes(movie:MovieClip,posicoes:Array,tipo:String,orientacao:int):void{
			var linha:int;
			var coluna:int;
			var indice:int;
			if (orientacao == 0) {	
				indice = this.pegarIndice(posicoes, "linha", "menor");
				linha = posicoes[indice][0];
				coluna = posicoes[indice][1];
			}else {
				indice = this.pegarIndice(posicoes, "coluna", "menor");
				linha = posicoes[indice][0];
				coluna = posicoes[indice][1];
			}
			if (this.posicaoLegal(linha, coluna, tipo, orientacao)) {
				if (orientacao == 0) {
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha][coluna + 1] = "P";
					this._matrizTabuleiro[linha][coluna + 2] = "P";
					this._matrizTabuleiro[linha][coluna + 3] = "P";
					
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 1]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 3]);
					
					this.tabuleiro.pecas[linha][coluna].estado = EstadoPeca.PECAEXPOSTA;
					this.tabuleiro.pecas[linha][coluna + 1].estado = EstadoPeca.PECAEXPOSTA;
					this.tabuleiro.pecas[linha][coluna + 2].estado = EstadoPeca.PECAEXPOSTA;
					this.tabuleiro.pecas[linha][coluna + 3].estado = EstadoPeca.PECAEXPOSTA;
				}else {
					this._matrizTabuleiro[linha][coluna] = "P";
					this._matrizTabuleiro[linha + 1][coluna] = "P";
					this._matrizTabuleiro[linha + 2][coluna] = "P";
					this._matrizTabuleiro[linha + 3][coluna] = "P";			
					
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha + 2][coluna]);
					this.tabuleiro.frota[1].adicionarPeca(this.tabuleiro.pecas[linha + 3][coluna]);
					
					this.tabuleiro.pecas[linha][coluna].estado = EstadoPeca.PECAEXPOSTA;
					this.tabuleiro.pecas[linha + 1][coluna].estado = EstadoPeca.PECAEXPOSTA;
					this.tabuleiro.pecas[linha + 2][coluna].estado = EstadoPeca.PECAEXPOSTA;
					this.tabuleiro.pecas[linha + 3][coluna].estado = EstadoPeca.PECAEXPOSTA;
				}
				this.mostrarMatrizTabuleiro();
				
			}
			movie.voltarPosicaoInicial();
			
		}
		
		private function apagarPecas(indice:int):void {
			for (var i:int = 0; i < this.tabuleiro.frota[indice].pecas.length; i++) {
				var peca:Peca = this.tabuleiro.frota[indice].pecas[i];
				this._matrizTabuleiro[peca.linha][peca.coluna] = "X";
				peca.estado = EstadoPeca.PECAOCULTA;				
			}
			this.tabuleiro.frota[indice].pecas = new Array();
		}
		
		private function pegarIndice(array:Array,indice:String,tipo:String):int {
			var retorno:int = -1;
			var ind:int = -1;
			if (indice == "linha") {
				var linha = array[0][0];
				ind = 0;
				if (tipo == "maior") {
					for (var i:int = 1; i < array.length; i++) {
						if (array[i][0] > linha) {
							linha = array[i][0];
							ind = i;
						}
					}
				}else {
					for (var j:int = 1; j < array.length; j++) {
						if (array[j][0] < linha) {
							linha = array[j][0];
							ind = j;
						}
					}
				}
				retorno = ind;
			}else {
				var coluna = array[0][1];
				ind = 0;
				if (tipo == "maior") {
					for (var k:int = 1; k < array.length; k++) {
						if (array[k][1] > coluna) {
							coluna = array[k][1];
							ind = k;
						}
					}
				}else {
					for (var m:int = 1; m < array.length; m++) {
						if (array[m][1] < coluna) {
							coluna = array[m][1];
							ind = m;
						}
					}
				}
				retorno = ind;
			}
			return retorno;
		}
		
		private function localizarPosicoes(embarcacao:MovieClip):Array {
			var retorno:Array = new Array();
			var pecas:Array = embarcacao.pecas;
			var parar_bool:Boolean = false;
			for (var k:int = 0; k < pecas.length ; k++) {
				parar_bool = false;
				for (var i:int = 0; i < 10; i++) {
					for (var j:int = 0; j < 10 ; j++) {
						if (pecas[k].hitTestObject(this.tabuleiro["quad"+i+""+j+"_mc"])) {
							parar_bool = true;
							retorno.push([i, j]);
							break;
						}
					}
					if (parar_bool) break;
					
				}
			}
			/*trace("this.tabuleiro[quad+retorno[0][0]retorno[0][1]+_mc] = "+this.tabuleiro["quad"+retorno[0][0]+""+retorno[0][1]+"_mc"].name)
			embarcacao.figura.x = this.tabuleiro.x+this.tabuleiro["quad"+retorno[0][0]+""+retorno[0][1]+"_mc"].x
			embarcacao.figura.y = this.tabuleiro.y+this.tabuleiro["quad"+retorno[0][0]+""+retorno[0][1]+"_mc"].y*/
			return retorno;
		}
		
		private function verificarPecas(posicoes:Array):Boolean {
			var retorno:Boolean = false;
			for (var i:int = 0; i < this.frota.length; i++) {
				for (var j:int = 0; j <posicoes.length; j++) {
					if (this.frota[i].verificarPecaExistente(posicoes[j][0],posicoes[j][1])) {
						retorno = true;
						break;
					}
				}
				if (retorno) break;
				
			}
			return retorno;
		}
		
		/*private function arrastarEmbarcacao(e:MouseEvent):void {
			this.submarino.startDrag();
			
		}*/
		
		public function liberar():void {
			this.log_txt.htmlText += "Posicione sua frota nos locais desejados e clique em \"Iniciar jogo\".\n";						
			this.log_txt.htmlText += "Se você quiser reposicionar alguma embarcação, basta arrastá-la novamente que a primeira será apagada.\n";
		}
		
		public function get matrizTabuleiro():Array { 
			return _matrizTabuleiro;
		}
		
		public function get tabuleiro():MovieClip { 
			return _tabuleiro;
		}
		
		public function set tabuleiro(value:MovieClip):void {
			_tabuleiro = value;
		}
		
		/*private function terminarArrasto(e:Event):void {
			var embarcacao:PortaAvioes = PortaAvioes(e.currentTarget);
			this.estaDentroTabuleiro(embarcacao);
		}*/
		
		/*private function estaDentroTabuleiro(embarcacao:PortaAvioes):Boolean {				
			if (embarcacao.figura.x > this.tabuleiro.x - embarcacao.x - embarcacao.parent.x + embarcacao.figura.width / 2) {
				trace("está à direita do x mínimo");
			}
			else {
				trace("está à esquerda do x mínimo");
			}
			
			return true;
		}*/
		
	}
	
}