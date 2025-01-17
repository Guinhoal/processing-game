abstract class Terreno { // Classe abstrata do tipo do terreno que tem cor e dificuldade
  int dificuldade;
  int cor;

  //Construtor
  public Terreno(int dificuldade, int cor) {
    this.dificuldade = dificuldade;
    this.cor = cor;
  }
}

//Diversos tipos de classe de terreno com cor e dificuldade
class Agua extends Terreno {
  Agua() {
    super(1, #2797F0);
  }
}
class Areia extends Terreno {
  Areia() {
    super(4, #D8BB51);
  }
}
class Grama extends Terreno {
  Grama() {
    super(2, #0A9D08);
  }
}
