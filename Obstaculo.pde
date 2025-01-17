abstract class Obstaculo { // Classe abstrata com a cor do Obstaculo
  int cor;

  public Obstaculo(int cor) {
    this.cor = cor;
  }
}

//Outras classes
class Pedra extends Obstaculo {
  Pedra() {
    super(#A5A5A5);
  }
}
class Cactus extends Obstaculo {
  Cactus() {
    super(#008000);
  }
}
class Corais extends Obstaculo {
  Corais() {
    super(#FF00FF);
  }
}
