package {
	import fl.controls.Button;
	import fl.controls.progressBarClasses.IndeterminateBar;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* @author Amora
	*/
	public class Inteligencia extends MovieClip{
		
		private var tabuleiro:Tabuleiro; //Tabuleiro da inteligencia
		private var matrizOponente:Array; // Essa eh a matriz que representa o que a inteligencia conhece da matriz de seu oponente (o humano).
		private var minhaMatriz:Array; // Matriz do usu?rio que est? jogando contra o computador	
		
		private var ultimaLinhaEscolhida:int;
		private var ultimaColunaEscolhida:int;
		
		private var tiposEmbarcacao:Array;
		
		public function Inteligencia(tabuleiro:Tabuleiro) {
			this.tabuleiro =  tabuleiro;	
			this.tiposEmbarcacao = ["portaAvioes", "destroyer"];
			
			this.inicializarMatrizes();			
			this.distribuirEmbarcacoes();
		}				
		
		private function inicializarMatrizes():void {
			this.matrizOponente = new Array(10);
			this.minhaMatriz = new Array(10);
			for (var i:int = 0; i < 10; i++) {
				this.matrizOponente[i] = new Array(10);
				this.minhaMatriz[i] = new Array(10);
				for (var j:int = 0; j < 10; j++) {
					this.matrizOponente[i][j] = "X";
					this.minhaMatriz[i][j] = "X";
				}						
			}
		}
		
		private function mostrarMinhaMatriz():void {
			for (var i:int = 0; i < 10; i++) {
				trace("this.minhaMatriz["+i+"] = "+ this.minhaMatriz[i]);
			}
		}
		
		private function mostrarMatrizOponente():void {
			for (var i:int = 0; i < 10; i++) {
				trace("this.matrizOponente["+i+"] = "+ this.matrizOponente[i]);
			}
		}
		
		private function distribuirEmbarcacoes():void {			
			this.distribuirDestroyer();
			this.distribuirPortaAvioes();
			this.distribuirSubmarino();
			
			this.mostrarMinhaMatriz();			
		}
		
		private function posicaoLegal(linha:int, coluna:int, embarcacao:String, orientacao:int = undefined):Boolean {
			var retorno:Boolean = true;
			if (embarcacao == "S") {
				for (var i:int = (linha - 1); i <= (linha + 1) ; i++) {
					for (var j:int = (coluna - 1); j <= (coluna + 1) ; j++) {
						if (  (i >= 0) && (j >= 0) && (i <= (this.minhaMatriz.length - 1) ) && (j <= (this.minhaMatriz.length - 1) ) ) {
							if (this.minhaMatriz[i][j] != "X") {
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
							if (  (a >= 0) && (b >= 0) && (a <= (this.minhaMatriz.length - 1) ) && (b <= (this.minhaMatriz.length - 1) ) ) {
								if (this.minhaMatriz[a][b] != "X") {
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
							if (  (c >= 0) && (d >= 0) && (c <= (this.minhaMatriz.length - 1) ) && (d <= (this.minhaMatriz.length - 1) ) ) {
								if (this.minhaMatriz[c][d] != "X") {
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
							if (  (e >= 0) && (f >= 0) && (e <= (this.minhaMatriz.length - 1) ) && (f <= (this.minhaMatriz[0].length - 1) ) ) {
								if( !( ( e == (linha - 1) ) && ( f == (coluna + 2) ) ) && !( ( e == (linha + 3) ) && ( f == (coluna + 2) ) ) ){
									if (this.minhaMatriz[e][f] != "X") {
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
							if (  (g >= 0) && (h >= 0) && (g <= (this.minhaMatriz.length - 1) ) && (h <= (this.minhaMatriz[0].length - 1) ) ) {
								if( !( ( g == (linha + 2) ) && ( h == (coluna - 1) ) ) && !( ( g == (linha + 2) ) && ( h == (coluna + 3) ) ) ){
									if (this.minhaMatriz[g][h] != "X") {
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
							if (  (m >= 0) && (n >= 0) && (m <= (this.minhaMatriz.length - 1) ) && (n <= (this.minhaMatriz[0].length - 1) ) ) {
								if( !( ( m == (linha - 2) ) && ( n == (coluna - 1) ) ) && !( ( m == (linha + 2) ) && ( n == (coluna - 1) ) ) ){
									if (this.minhaMatriz[m][n] != "X") {
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
							if (  (o >= 0) && (p >= 0) && (o <= (this.minhaMatriz.length - 1) ) && (p <= (this.minhaMatriz[0].length - 1) ) ) {
								if( !( ( o == (linha - 2) ) && ( p == (coluna - 1) ) ) && !( ( o == (linha - 2) ) && ( p == (coluna + 3) ) ) ){
									if (this.minhaMatriz[o][p] != "X") {
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
		
		private function distribuirSubmarino():void {
			var linha:int = Math.floor(Math.random()*this.minhaMatriz.length);
			var coluna:int = Math.floor(Math.random() * this.minhaMatriz[0].length);			
			if ( this.posicaoLegal(linha, coluna, "S") ) {
				this.minhaMatriz[linha][coluna] = "P";
				this.tabuleiro.frota[2].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
			}
			else {
				this.distribuirSubmarino();
			}
		}
		
		private function distribuirPortaAvioes():void {
			var orientacao:int = Math.floor(Math.random() * 2); // 0 horizontal, 1 vertical.
			var linha:int;
			var coluna:int;
			if (orientacao == 0) { // horizontal
				linha = Math.floor(Math.random() * this.minhaMatriz.length);
				coluna = Math.floor( Math.random() * (this.minhaMatriz[0].length - 3) );
				if ( this.posicaoLegal(linha, coluna, "P", 0) ) {
					this.minhaMatriz[linha][coluna] = "P";
					this.minhaMatriz[linha][coluna + 1] = "P";
					this.minhaMatriz[linha][coluna + 2] = "P";
					this.minhaMatriz[linha][coluna + 3] = "P";	
					
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
				linha = Math.floor( Math.random() * (this.minhaMatriz.length - 3) );
				coluna = Math.floor( Math.random() * this.minhaMatriz[0].length );
				if ( this.posicaoLegal(linha, coluna, "P", 1) ) {
					this.minhaMatriz[linha][coluna] = "P";
					this.minhaMatriz[linha + 1][coluna] = "P";
					this.minhaMatriz[linha + 2][coluna] = "P";
					this.minhaMatriz[linha + 3][coluna] = "P";			
					
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
			var orientacao:int = Math.floor(Math.random() * 4);
			var linha:int;
			var coluna:int;
			trace("orientacao = " + orientacao);
			if (orientacao == 0) {
				linha = Math.floor(Math.random() * (this.minhaMatriz.length - 2) );
				coluna = Math.floor( Math.random() * (this.minhaMatriz[0].length - 1) );
				trace("linha = " + linha);
				trace("coluna = " + coluna);
				if ( this.posicaoLegal(linha, coluna, "D", 0) ) {
					trace("---> OK");
					this.minhaMatriz[linha][coluna] = "P";
					this.minhaMatriz[linha + 1][coluna + 1] = "P";
					this.minhaMatriz[linha + 2][coluna] = "P";		
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 2][coluna]);
				}
				else {
					this.distribuirDestroyer();
				}
			}
			else if(orientacao == 1){
				linha = Math.floor(Math.random() * (this.minhaMatriz.length - 1) );
				coluna = Math.floor( Math.random() * (this.minhaMatriz[0].length - 2) );
				trace("linha = " + linha);
				trace("coluna = " + coluna);
				if ( this.posicaoLegal(linha, coluna, "D", 1) ) {
					trace("---> OK");
					this.minhaMatriz[linha][coluna] = "P";
					this.minhaMatriz[linha][coluna + 2] = "P";
					this.minhaMatriz[linha + 1][coluna + 1] = "P";		
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
				}
				else {
					this.distribuirDestroyer();
				}
			}
			else if(orientacao == 2){
				linha = Math.floor(Math.random() * (this.minhaMatriz.length - 2) ) + 1;
				coluna = Math.floor( Math.random() * (this.minhaMatriz[0].length - 1) );
				trace("linha = " + linha);
				trace("coluna = " + coluna);
				if ( this.posicaoLegal(linha, coluna, "D", 2) ) {
					trace("---> OK");
					this.minhaMatriz[linha][coluna] = "P";
					this.minhaMatriz[linha - 1][coluna + 1] = "P";
					this.minhaMatriz[linha + 1][coluna + 1] = "P";	
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha - 1][coluna + 1]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha + 1][coluna + 1]);
				}
				else {
					this.distribuirDestroyer();
				}
			}
			else{
				linha = Math.floor(Math.random() * (this.minhaMatriz.length - 1) ) + 1;
				coluna = Math.floor( Math.random() * (this.minhaMatriz[0].length - 2) );
				trace("linha = " + linha);
				trace("coluna = " + coluna);
				if ( this.posicaoLegal(linha, coluna, "D", 3) ) {
					trace("---> OK");
					this.minhaMatriz[linha][coluna] = "P";
					this.minhaMatriz[linha - 1][coluna + 1] = "P";
					this.minhaMatriz[linha][coluna + 2] = "P";	
					
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha - 1][coluna + 1]);
					this.tabuleiro.frota[0].adicionarPeca(this.tabuleiro.pecas[linha][coluna + 2]);
				}
				else {
					this.distribuirDestroyer();
				}
			}						
		}
		
		public function escolherJogada():Jogada {				
			var jogada:Jogada;						
			var peca:Array = this.procurarEmbarcacaoAtingida();			
			if ( (peca[0] == -1) && (peca[1] == -1) ) { // nao existe nenhuma peca atingida, entao escolhe qualquer peca
				this.ultimaLinhaEscolhida = Math.floor( Math.random() * this.tabuleiro.pecas.length );
				this.ultimaColunaEscolhida = Math.floor( Math.random() * this.tabuleiro.pecas[0].length );
				if ( (this.matrizOponente[this.ultimaLinhaEscolhida][this.ultimaColunaEscolhida] == "X") && (!this.temAbatidoAoRedor(new Array(this.ultimaLinhaEscolhida, this.ultimaColunaEscolhida)))) { //Se ainda n tiver atirado nessa posicao,					
					jogada = new Jogada(this.ultimaLinhaEscolhida, this.ultimaColunaEscolhida);				
				}
				else {
					jogada = this.escolherJogada(); //Se já tiver atirado nessa posicao, escolher outra.
				}
			}
			else { //existe uma peca atingida, entao procura com inteligencia				
				var pecaAtingida:Array = this.procurarOutraPeca(peca);
				this.ultimaLinhaEscolhida = pecaAtingida[0];
				this.ultimaColunaEscolhida = pecaAtingida[1];
				jogada = new Jogada(pecaAtingida[0], pecaAtingida[1]);
			}
			
			
			return jogada;
		}
		
		private function temAbatidoAoRedor(peca:Array):Boolean {
			var retorno:Boolean = false;
			for (var i:int = (peca[0] - 1); i <= (peca[0] + 1); i++) {
				for (var j:int = (peca[1] - 1); j <= (peca[1] + 1); j++) {
					if ( ( (i != peca[0]) || (j != peca[1]) ) && (i >= 0) && (i < this.matrizOponente.length) && (j >= 0) && (j < this.matrizOponente[0].length) ) {
						if (this.matrizOponente[i][j] == "P") {
							retorno = true;
							break;
						}
					}
				}
				if (retorno) {
					break;
				}
			}
			return retorno;
		}
		
		private function procurarOutraPeca(peca:Array):Array {
			var resultado:Array = this.darVolta(peca);
			var novaPeca:Array;			
			if(resultado[0] != "nada"){
				var tipoEmbarcacao:String = resultado[0];
				var orientacao:int = resultado[1];				
				
				if (tipoEmbarcacao == "portaAvioes") {				
					if (orientacao == 0) { //vertical					
						novaPeca = this.procurarVertical(peca);
					}
					else {
						novaPeca = this.procurarHorizontal(peca);
					}
				}
				else { //destroyer
					if (orientacao == 0) {
						novaPeca = this.procurar0(peca);
					}
					else if (orientacao == 1) {
						novaPeca = this.procurar1(peca);
					}
					else if (orientacao == 2) {
						novaPeca = this.procurar2(peca);
					}
					else if (orientacao == 3) {
						novaPeca = this.procurar3(peca);
					}				
				}
			}
			else { //só achou uma peça solitaria de uma embarcacao. procurar algo ao redor dela!				
				if (this.tiposEmbarcacao.length == 1) {
					trace("Só existe um tipo de embarcação e é do tipo " + this.tiposEmbarcacao[0]);
					if (this.tiposEmbarcacao[0] == "portaAvioes") {
						novaPeca = this.procurarVertical(peca);
						if (novaPeca[0] == "nada") {
							novaPeca = this.procurarHorizontal(peca);
						}
					}
					else { //destroyer
						novaPeca = this.procurarDiagonal(peca);
					}
				}
				else {
					novaPeca = this.procurarAoRedor(peca);
				}				
			}
			return novaPeca;
		}
		
		private function procurarDiagonal(peca:Array):Array {
			var retorno:Array;
			var linhas:Array = [-1, 1];
			var colunas:Array = [ -1, 1];
			var sorteio1:int = Math.floor(Math.random()*linhas.length);
			var sorteio2:int = Math.floor(Math.random() * colunas.length);
			var linha:int = peca[0] + linhas[sorteio1];
			var coluna:int = peca[1] + colunas[sorteio2];		
			
			if (this.matrizOponente[linha][coluna] == "X") {
				retorno = [linha, coluna];
			}
			else {
				retorno = this.procurarDiagonal(peca);
			}
			return retorno;
		}

		private function procurarAoRedor(peca:Array):Array {
			var retorno:Array = [-1, -1];
			var linha:int = peca[0] + Math.floor(Math.random() * 3) - 1;
			var coluna:int = peca[1] + Math.floor(Math.random() * 3) - 1;
			
			if ( (linha >= 0) && (linha < this.matrizOponente.length) && (coluna >= 0) && (coluna < this.matrizOponente[0].length) ) {
				if (this.matrizOponente[linha][coluna] == "X") {
					retorno = [linha, coluna];
				}
				else {
					retorno = this.procurarAoRedor(peca);
				}
			}			
			if (retorno[0] == -1) {
				retorno = this.procurarAoRedor(peca);
			}			
			return retorno;
		}
		
		private function procurarPortaAvioes(peca:Array):Array {
			var retorno:Array = [ -1, -1];
			var orientacao:int = Math.floor(Math.random() * 2);
			var linha:int;
			var coluna:int;
			if (orientacao == 0) { //horizontal
				linha = peca[0] + Math.floor(Math.random() * 3) - 1;
				while (linha == peca[0]) {
					linha = peca[0] + Math.floor(Math.random() * 3) - 1;
				}
				coluna = peca[1];
			}
			else { //vertical
				linha = peca[0];				
				coluna = peca[1] + Math.floor(Math.random() * 3) - 1;
				while (coluna == peca[1]) {
					coluna = peca[1] + Math.floor(Math.random() * 3) - 1;
				}
			}
			
			if ( (linha >= 0) && (linha < this.matrizOponente.length) && (coluna >= 0) && (coluna < this.matrizOponente[0].length) ) {
				if (this.matrizOponente[linha][coluna] == "X") {
					retorno = [linha, coluna];
				}
				else {
					retorno = this.procurarPortaAvioes(peca);
				}
			}
			return retorno;
		}
		
		private function procurar0(peca:Array):Array {
			var retorno:Array = new Array(2);
			var i:int;
			var j:int;
			var achou:Boolean = false;
			
			i = peca[0];
			j = peca[1] + 2;
			if ( this.iValido(i,j) ) {
				achou = true;
			}
			
			if (!achou) {
				i = peca[0] + 1;
				j = peca[1] + 1;			
				if ( this.iValido(i,j) ) {
					achou = true;
				}
			}
			
			if (!achou) {
				i = peca[0] - 1;
				j = peca[1] - 1;
				if ( this.iValido(i,j) ) {
					achou = true;
				}
			}
						
			if (!achou) {
				i = peca[0] - 2;
				j = peca[1];
				if ( this.iValido(i,j) ) {
					achou = true;
				}
			}			
			retorno = [i, j];
			return retorno;
		}
		
		private function iValido(i:int, j:int):Boolean {
			var retorno:Boolean = false;
			if( (i >= 0) && (i < this.matrizOponente.length) && (j >= 0) && (j < this.matrizOponente[0].length)  && (this.matrizOponente[i][j] == "X") ) {
				retorno = true;
			}
			return retorno;
		}
		
		private function procurar1(peca:Array):Array {
			var retorno:Array = new Array(2);
			var i:int;
			var j:int;
			var achou:Boolean = false;
			
			i = peca[0] + 1;
			j = peca[1] - 1;
			if ( this.iValido(i, j) ) {
				achou = true;
			}
			
			if (!achou) {
				i = peca[0] - 1;
				j = peca[1] + 1;
				if (this.iValido(i,j)) {
					achou = true;
				}
			}			
			
			if (!achou) {
				i = peca[0] - 2;
				j = peca[1];
				if (this.iValido(i,j)) {
					achou = true;
				}
			}			
			
			if (!achou) {
				i = peca[0];
				j = peca[1] - 2;
				if (this.iValido(i,j)) {
					achou = true;
				}
			}
						
			retorno = [i, j];
			return retorno;
		}
		
		private function procurar2(peca:Array):Array {
			var retorno:Array = new Array(2);
			var i:int;
			var j:int;
			var achou:Boolean = false;
			
			i = peca[0] + 1;
			j = peca[1] + 1;
			if (this.iValido(i,j)) {
				achou = true;
			}
			
			if (!achou) {
				i = peca[0] - 1;
				j = peca[1] - 1;
				if (this.iValido(i,j)) {
					achou = true;
				}
			}
			
			if (!achou) {
				i = peca[0];
				j = peca[1] - 2;
				if (this.iValido(i,j)) {
					achou = true;
				}
			}
			
			if (!achou) {
				i = peca[0] + 2;
				j = peca[1];
				if (this.iValido(i,j)) {
					achou = true;
				}
			}
							
			retorno = [i, j];
			return retorno;
		}
		
		private function procurar3(peca:Array):Array {
			var retorno:Array = new Array(2);
			var i:int;
			var j:int;
			var achou:Boolean = false;
			
			i = peca[0] - 1;
			j = peca[1] + 1;			
			if (this.iValido(i,j) ) {
				achou = true;
			}
			
			if (!achou) {
				i = peca[0] - 1;
				j = peca[1] - 1;
				if (this.iValido(i,j)) {
					achou = true;
				}
			}
			
			if (!achou) {
				i = peca[0] + 1;
				j = peca[1] - 1;
				if (this.iValido(i,j)) {
					achou = true;
				}
			}
			
			if (!achou) {
				i = peca[0];
				j = peca[1] + 2;
				if (this.iValido(i,j)) {
					achou = true;
				}
			}
					
			retorno = [i, j];
			return retorno;
		}
		
		private function procurarVertical(peca:Array):Array {
			var retorno:Array = ["nada", "nada"];
			if (this.cabeVertical(peca)) {
				retorno = this.procurarCima(peca);
				if (retorno[0] == "nada") {
					retorno = this.procurarBaixo(peca);
				}	
			}			
			return retorno;
		}
		
		private function cabeVertical(peca:Array):Boolean {
			var retorno:Boolean = false;
			var linha:int = peca[0]; //contando para cima
			var coluna:int = peca[1];
			var contador:int = 0;
			
			while ( this.iCabe(linha, coluna) ) {
				contador++;
				linha--;
			}
			
			linha = peca[0] + 1; //contando para baixo.
			while ( this.iCabe(linha, coluna) ) {
				contador++;
				linha++;
			}
			if (contador >= 4) {
				retorno = true;
			}
			return retorno;
		}
		
		private function iCabe(i:int, j:int):Boolean {
			var retorno:Boolean = false;
			if( (i >= 0) && (i < this.matrizOponente.length) && (j >= 0) && (j < this.matrizOponente[0].length)  && ( (this.matrizOponente[i][j] == "X") || (this.matrizOponente[i][j] == "P") ) ) {
				retorno = true;
			}
			return retorno;
		}
		
		private function procurarCima(peca:Array):Array {
			var retorno:Array = ["nada", "nada"];
			var linha:int = peca[0];
			var coluna:int = peca[1];
			var i:int = linha - 1;
			var j:int = coluna;
			while (i >= 0) {
				if (this.matrizOponente[i][j] == "X") {
					retorno[0] = i;
					retorno[1] = j;
					break;
				}
				else if (this.matrizOponente[i][j] == "A") {
					break;
				}
				i--;
			}
			return retorno;
		}
		
		private function procurarBaixo(peca:Array):Array {
			var retorno:Array = ["nada", "nada"];
			var linha:int = peca[0];
			var coluna:int = peca[1];
			var i:int = linha + 1;
			var j:int = coluna;
			while (i < this.matrizOponente.length) {
				if (this.matrizOponente[i][j] == "X") {
					retorno[0] = i;
					retorno[1] = j;
					break;
				}
				else if (this.matrizOponente[i][j] == "A") {
					break;
				}
				i++;
			}
			return retorno;
		}
		
		private function procurarHorizontal(peca:Array):Array {
			var retorno:Array = ["nada", "nada"];
			if (this.cabeHorizontal(peca)) {
				retorno = this.procurarDireita(peca);
				if (retorno[0] == "nada") {
					retorno = this.procurarEsquerda(peca);
				}	
			}			
			return retorno;
		}
		
		
		private function cabeHorizontal(peca:Array):Boolean {
			var retorno:Boolean = false;
			var linha:int = peca[0];
			var coluna:int = peca[1]; //contando para direita
			var contador:int = 0;
			
			while ( this.iCabe(linha, coluna) ) {
				contador++;
				coluna++;
			}
			coluna = peca[1] - 1; //contando para esquerda.
			while ( this.iCabe(linha, coluna) ) {
				contador++;
				coluna--;
			}
			if (contador >= 4) {
				retorno = true;
			}
			return retorno;
		}
		
		private function procurarDireita(peca:Array):Array {
			var retorno:Array = ["nada", "nada"];
			var linha:int = peca[0];
			var coluna:int = peca[1];
			var i:int = linha;
			var j:int = coluna + 1;
			while (j < this.matrizOponente[i].length) {
				if (this.matrizOponente[i][j] == "X") {
					retorno[0] = i;
					retorno[1] = j;
					break;
				}
				else if (this.matrizOponente[i][j] == "A") {
					break;
				}
				j++;
			}
			return retorno;
		}
		
		private function procurarEsquerda(peca:Array):Array {
			var retorno:Array = ["nada", "nada"];
			var linha:int = peca[0];
			var coluna:int = peca[1];
			var i:int = linha;
			var j:int = coluna - 1;
			while (j >= 0) {
				if (this.matrizOponente[i][j] == "X") {
					retorno[0] = i;
					retorno[1] = j;
					break;
				}
				else if (this.matrizOponente[i][j] == "A") {
					break;
				}
				j--;
			}
			return retorno;
		}
		
		private function darVolta(peca:Array):Array {
			var retorno:Array = new Array(2);
			retorno[0] = "nada";
			for (var i:int = (peca[0] - 1); i <= (peca[0] + 1); i++) {
				for (var j:int = (peca[1] - 1); j <= (peca[1] + 1); j++) {
					if ( ( (i != peca[0]) || (j != peca[1]) ) && (i >= 0) && (i < this.matrizOponente.length) && (j >= 0) && (j < this.matrizOponente[0].length) ) {						
						if (this.matrizOponente[i][j] == "P") { 
							if ( (i == peca[0]) || (j == peca[1]) ) {//Porta-avioes
								retorno[0] = "portaAvioes";
								retorno[1] = 0; //vertical
								if ( (i == peca[0]) && ( (j == (peca[1]-1) ) || (j == (peca[1]+1) ) )) { //porta-avioes horizontal
									retorno[1] = 1; //horizontal
								}
							}
							else { //destroyer
								retorno[0] = "destroyer";
								if ( (i == peca[0]-1) && (j == peca[1]+1) ) {
									retorno[1] = 0;
								}
								else if( (i == peca[0]-1) && (j == peca[1]-1) ){
									retorno[1] = 1;
								}
								else if( (i == peca[0]+1) && (j == peca[1]-1) ){
									retorno[1] = 2;
								}
								else if( (i == peca[0]+1) && (j == peca[1]+1) ){
									retorno[1] = 3;
								}
							}
							break;
						}						
					}
				}
				if (retorno[0] != "nada") {
					break;
				}
			}
			return retorno;
		}
		
		private function procurarEmbarcacaoAtingida():Array {
			var peca:Array = [ -1, -1];
			for (var i:int = 0; i < this.matrizOponente.length; i++) {
				for (var j:int = 0; j < this.matrizOponente[i].length; j++) {
					if (this.matrizOponente[i][j] == "P") {
						peca = [i, j];
						break;
					}
				}
			}
			return peca;
		}
		
		public function acertarAgua():void {
			this.matrizOponente[this.ultimaLinhaEscolhida][this.ultimaColunaEscolhida] = "A";
		}
		
		public function atingirPeca():void {
			this.matrizOponente[this.ultimaLinhaEscolhida][this.ultimaColunaEscolhida] = "P";
		}
		
		public function abaterEmbarcacao(embarcacaoAbatida:Embarcacao):void {			
			for (var i:int = 0; i < embarcacaoAbatida.pecas.length; i++) {
				this.matrizOponente[embarcacaoAbatida.pecas[i].linha][embarcacaoAbatida.pecas[i].coluna] = "F";
			}			
			if (embarcacaoAbatida.nome == "porta-avioes") {			
				trace("entrou em embarcacao abatida porta-avioes");
				this.tiposEmbarcacao = new Array(this.tiposEmbarcacao[1]);
				trace("this.tiposEmbarcacao = " + this.tiposEmbarcacao);
			}
			else if (embarcacaoAbatida.nome == "destroyer") {
				this.tiposEmbarcacao = new Array(this.tiposEmbarcacao[0]);
			}	
			trace("Abateu embarcação " + embarcacaoAbatida.nome + ". Agora só sobrou " + this.tiposEmbarcacao + ".");
		}
	}
	
}