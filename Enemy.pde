class Enemy {

  float x, y;
  float xpos, ypos;
  float size;

  float hp, max_hp;
  boolean immune, dead, hasBoat;
  private float targetx, targety;

  float anim;

  long pinador;
  long imunity;

  float atax, atay;
  Boat boat;
  float tab = 10;


  public Enemy(float xpos, float ypos, float size, float hp, boolean alive) {

    this.x = xpos;
    this.y = ypos;
    this.size = size;

    this.hp = hp;

    this.max_hp = hp;

    this.targetx = xpos;
    this.targety = ypos;

    this.dead = alive;
    this.hasBoat = true;
  }

  void update() {
    if (dead) {
      return;
    }
    if (imunity > millis()) {
      immune = true;
    } else {
      immune = false;
    }
    desenha();
    move();
  }

  void desenha() {
    pushMatrix();
    xpos = x + map.offsetX;
    ypos = y + map.offsetY;
    translate(xpos, ypos);
    barraVida();

    fill(100, 230, 120);
    strokeWeight(1);
    stroke(1);

    atay = targety - y;
    atax =  targetx - x;

    rotateZ(atan2(atay, atax) - PI/4);

    ellipse(0, 0, size, size);

    ellipse(size/2 + size/5, 0, size/4, size/4);

    ellipse(0, size/2 + size/5, size/4, size/4);

    popMatrix();
  }

  void barraVida() {

    stroke(1);
    strokeWeight(1.8);
    fill(200, 20, 20);
    rect(-size/2, -size, max_hp/3, 5);
    noStroke();
    fill(20, 200, 100);
    rect(-size/2, -size, hp/3, 5);
  }

  void damage(float damage) {
    if (immune) {
      return;
    }
    
     
    hp -= damage;

    imunity = millis() + 300;
    if (hp <= 0) {
      dead = true;
    }
  }

  void heal(float heal) {
    hp += heal;
    if (hp > max_hp) {
      hp = max_hp;
    }
  }

  // Fun��o que faz o player se mover
  void move() {
    float angle = atan2(targety - y, targetx - x);
    float speed = getSpeed(); // Obt�m a velocidade com base no terreno
    float nextX = x + cos(angle) * speed;
    float nextY = y + sin(angle) * speed;

    // Verifica se a pr�xima posi��o n�o colide com nenhum obst�culo
    if ((targety-y > 5 || targety-y < -5) || (targetx-x > 5 || targetx-x < -5 )) {
      if (!isColliding(nextX, nextY)) {
        x = nextX; // Atualiza posi��o x e y
        y = nextY;
      }
    }

    // Verifica se o player pegou o barco
    if (boat != null && !hasBoat && dist(x, y, boat.x, boat.y) < size) {
      hasBoat = true; // O player pegou o barco
      boat.visible = false; // Remover o barco da tela
      boat = null; // Remover a refer�ncia ao barco
      println("Player pegou o barco!");
    }
  }

  // Fun��o para obter a velocidade do player com base no terreno
  float getSpeed() {
    int gridX = map.gridPosX((int)xpos);
    int gridY = map.gridPosY((int)ypos);
    Terreno tile = map.getTileValue(gridX, gridY);

    if (tile instanceof Agua) {
      return hasBoat ? 1.5 : 0.0; // 2 blocos por segundo na �gua com barco, 0 sem barco
    } else if (tile instanceof Areia) {
      return 0.375; // 0.5 blocos por segundo na areia
    } else if (tile instanceof Grama) {
      return 0.75; // 1 bloco por segundo na grama
    }
    return 1.0; // Velocidade padr�o
  }

  // Fun��o que verifica se o player est� colidindo com algo
  boolean isColliding(float nextX, float nextY) {
    int gridX = map.gridPosX((int)(nextX + xpos - x));
    int gridY = map.gridPosY((int)(nextY + ypos - y));
    
    Terreno tile = map.getTileValue(gridX, gridY);
    Obstaculo obstaculo = map.getObstaculo(gridX, gridY);

    // Verifica se o terreno � de livre locomo��o
    if (tile instanceof Grama || tile instanceof Areia) {
      return false; // N�o h� colis�o, jogador pode se locomover
    }

    // Verifica se o terreno � �gua e o jogador n�o est� em um barco
    if (tile instanceof Agua && !hasBoat) {
      return true; // Colis�o detectada, jogador n�o pode andar na �gua sem o barco
    }

    // Verifica se h� um obst�culo na posi��o
    if (tile == null) {
      return true; // Colis�o detectada, h� um obst�culo na posi��o
    }

    return false; // N�o h� colis�o
  }


  void setTarget(float x1, float y1) {
    targetx = x1;
    targety = y1;
  } //funçao responsavel por mudar o target que é onde o player vai

  /*No geral os inimigos vao atras do player e tentam bater nele so isso
   */

  /* if (x + size > obj_x &&
   x < obj_x + obj_sizex &&
   y + size > obj_y &&
   y < obj_y + obj_sizey) {
   // Colisão detectada! Impedir o movimento.
   }*/
}
