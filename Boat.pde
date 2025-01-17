class Boat {
  float x, y; // Posição do barco no mapa
  boolean visible = true; // Visibilidade do barco

  // Construtor
  Boat(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // Método para desenhar o barco no mapa
  void display() {
    if (visible) {
      fill(139, 69, 19); // Cor marrom para o barco
      rect(x + map.offsetX, y + map.offsetY, 25, 25); // Desenha um retângulo representando o barco
    }
  }
}