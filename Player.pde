import java.util.List;

class Player {
  // Atributos do player
  float x, y;
  float xpos, ypos;
  float size;
  float hp, max_hp;
  boolean immune, dead, hasBoat;
  private float targetx, targety;
  boolean qDown, wDown, eDown;
  PImage sword;
  int swordhand, combo;
  float rool, rollx, rolly, startx, starty, rolx, roly;
  float swordx, swordy, swordsize;
  float anim;
  long contador;
  long[] pinador = new long[10];
  float atax, atay;
  Boat boat;
  float tab = 10;
  boolean inBoat;
  String camin;
  int camin_pointer;


  // Construtor do player
  public Player(float xpos, float ypos, float size, float hp) {
    this.x = xpos;
    this.y = ypos;
    this.size = size;
    this.hp = hp;
    this.max_hp = hp;
    this.targetx = xpos;
    this.targety = ypos;
    this.swordhand = 0;
    this.contador = millis();
  }

  // Adicionar um atributo para indicar a posse do barco
  boolean hasBoatIcon = false;

  // Carrega a imagem da espada
  void loadSword() {
    sword = loadImage("Item/7.png");
  }

  // Desenha o player, a barra de vida e a espada
  void desenha() {
    if (pinador[5] > millis()) {
      immune = true;
    } else {
      immune = false;
    }

    barraVida();
    pushMatrix();
    xpos = x + map.offsetX;
    ypos = y + map.offsetY;
    translate(xpos, ypos);

    if (swordhand != 1) {
      atay = mouseY - (ypos);
      atax = mouseX - (xpos);
    }
    rotateZ(atan2(atay, atax));

    if (inBoat) {
      fill(200, 100, 10);
      rect(-size/2 - 4, -size/2 - 2, size + 12, size + 4);
    }
    rotate( - PI/4);


    fill(255, 255, 255);
    ellipse(0, 0, size, size);
    ellipse(size/2 + size/5, 0, size/4, size/4);
    ellipse(0, size/2 + size/5, size/4, size/4);
    popMatrix();
    if (swordhand == 0) {
      drawSword(-size/2, -size/2-5, size, 800);
    }
  }

  // Desenha a barra de vida e o �cone do barco se o player tiver o barco
  void barraVida() {
    stroke(1);
    strokeWeight(5);
    fill(200, 20, 20);
    rect(30, 20, max_hp*7, 20);
    strokeWeight(1);
    fill(20, 200, 100);
    rect(30, 20, hp*7, 20);

    // Desenhar o �cone do barco se o player tiver o barco
    if (hasBoatIcon) {
      fill(0, 0, 255); // Cor azul para o �cone do barco
      rect(30 + max_hp*7 + 10, 10, 30, 30); // Desenha um ret�ngulo representando o �cone do barco
    }
  }

  // Fun��o que verifica se o player est� imune, se ele recebeu dano e atualiza a vida ou se ele se curou e atualiza a vida
  void damage(float damage) {
    if (immune) {
      return;
    }

    hp -= damage;

    pinador[5] = millis() + 500;

    if (hp < 0) {
      dead = true;
      hp = 0;
    }
  }

  void heal(float heal) {
    hp += heal;

    if (hp > max_hp) {
      hp = max_hp;
    }
  }

  void moveFromDjisktra(String caminho) {
    camin = caminho;
    camin_pointer = 0;
  }

  void andar (char c) {
    if (c == '^') {
      targety -= 25;
    }
    if (c == '>') {
      targetx += 25;
    }
    if (c == '<') {
      targetx -= 25;
    }
    if (c == 'v') {
      targety += 25;
    }
  }

  /*void andar(char c) {
   if (c == '^') {
   ir.add("^,-25");
   }
   if (c == '>') {
   ir.add(">,25");
   }
   if (c == '<') {
   ir.add("<,-25");
   }
   if (c == 'v') {
   ir.add("v,25");
   }
   }*/

  // Função que faz o player se mover
  void move() {
    inBoat = false;
    float angle = atan2(targety - y, targetx - x);
    float speed = getSpeed(); // Obtém a velocidade com base no terreno
    float nextX = x + cos(angle) * speed;
    float nextY = y + sin(angle) * speed;

    // Verifica se a próxima posição não colide com nenhum obstáculo
    if ((targety-y > 3 || targety-y < -3) || (targetx-x > 3 || targetx-x < -3 )) {
      if (!isColliding(nextX, nextY)) {
        x = nextX; // Atualiza posição x e y
        y = nextY;
      }
    } else if (camin != null) {
      if(camin.length() > camin_pointer) {
        char way[] = camin.toCharArray();
        andar(way[camin_pointer]);
        camin_pointer++;
      }
      
    }

    // Verifica se o player pegou o barco
    if (boat != null && !hasBoat && dist(x, y, boat.x, boat.y) < size) {
      hasBoat = true; // O player pegou o barco
      hasBoatIcon = true; // Exibir o ícone do barco
      boat.visible = false; // Remover o barco da tela
      boat = null; // Remover a referência ao barco
      println("Player pegou o barco!");
    }
  }

  // Função para obter a velocidade do player com base no terreno
  float getSpeed() {
    int gridX = map.gridPosX((int)xpos);
    int gridY = map.gridPosY((int)ypos);
    Terreno tile = map.getTileValue(gridX, gridY);

    if (tile instanceof Agua) {
      return hasBoat ? 2.0 : 0.0; // 2 blocos por segundo na água com barco, 0 sem barco
    } else if (tile instanceof Areia) {
      return 0.5; // 0.5 blocos por segundo na areia
    } else if (tile instanceof Grama) {
      return 1.0; // 1 bloco por segundo na grama
    }
    return 1.0; // Velocidade padrão
  }

  // Função que verifica se o player esta colidindo com algo
  boolean isColliding(float nextX, float nextY) {
    int gridX = map.gridPosX((int)(nextX + xpos - x));
    int gridY = map.gridPosY((int)(nextY + ypos - y));

    Terreno tile = map.getTileValue(gridX, gridY);

    // Verifica se o terreno é de livre locomoção
    if (tile instanceof Grama || tile instanceof Areia) {
      return false; // Não há colisão, jogador pode se locomover
    }

    // Verifica se o terreno é água e o jogador não está em um barco
    if (tile instanceof Agua && !hasBoat) {
      return true; // Colisão detectada, jogador não pode andar na água sem o barco
    } else if (tile instanceof Agua) {
      inBoat = true;
    }

    // Verifica se há um obstáculo na posição
    if (tile == null) {
      return true; // Colisã detectada, há um obstáculo na posição
    }

    return false; // Não há colisão
  }

  void setTarget(float x1, float y1) { // Define o "alvo" do player
    int gridX = map.gridPosX((int)x1 + (int)map.offsetX);
    int gridY = map.gridPosY((int)y1 + (int)map.offsetY);

    targetx = gridX*25 + map.tileSize/2;
    targety = gridY*25 + map.tileSize/2;
  }

  // Verifica a entrada do jogador
  void CheckInput() {
    if (pinador[1] < millis()) {
      /*reseta ataque*/
      swordhand = 0;
    }
    if (qDown == true) {
      if (pinador[1] < millis()) {
        pinador[1] = millis() + 300/*recargaAtaque*/;
        anim = 0;
        swordhand++;
      }
      /* quebrando a cabeça pra fazer o ataque prestar :))))))))))) ;-; socoro
       fiz um broxa ;(((((*/
    }

    //uma Cura quando aperta W
    if (wDown == true) {
      if (pinador[2] < millis() && hp != max_hp) {
        heal(80);
        pinador[2] = millis() + 15000/*recargaCura*/;
      }
    }
    //rolamento
    if (pinador[4] > millis()) {
      float angle = atan2(rolly - roly - map.offsetY, rollx - rolx - map.offsetX);
      rool = 20;
      y += sin(angle)*rool;
      x += cos(angle)*rool;

      targetx = x;
      targety = y;
    }
    if (eDown == true) {
      if (pinador[3] < millis()) {
        rool = 0;
        pinador[3] = millis() + 3000; /* recargaAvanço*/

        pinador[4] = millis() + 100; //duracao avanço
        pinador[5] = millis() + 150;
        rollx = mouseX;
        rolly = mouseY;
        rolx = x;
        roly = y;
      }
    }
  }

  // Mostra o item do jogador (espada)
  void showItem() {
    anim++;
    if (swordhand == 1) {
      drawSword(10, 10, 60, 1800 + anim * -200);
    } else {
      swordhand = 0;
    }
  }

  // Desenha a espada
  void drawSword(float xx, float yy, float sizer, float aa) {
    pushMatrix();
    translate(x + map.offsetX, y + map.offsetY);
    rotateZ(atan2(atay, atax));
    translate(xx, yy);
    float t = 0.5;
    rotateZ(PI * (aa) / 3600);
    image(sword, 0, 0, lerp(swordsize, sizer, t), lerp(swordsize, sizer, t));
    swordx = xx;
    swordy = yy;
    swordsize = sizer;
    popMatrix();
  }
}
