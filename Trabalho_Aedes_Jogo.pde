Mape map; // Mapa do jogo
Player player; // Inicialização do player
Boat boat; // Inicialização do barco
Enemy[] inimigo = new Enemy[0]; //inicializando inimigos
boolean dragging = false; // Verifica se o mouse está arrastando ou não
float lastMouseX, lastMouseY; // Última posição x e y
long spawner;
boolean pressed;
Djisktra moc = new Djisktra();
PVector rumo;

// Setup, inicia o grid, o framerate e outros detalhes de inicializa��o
void setup() {
  size(1200, 800, P3D);
  background(200, 125, 70);
  frameRate(80);
  map = new Mape(200, 25); // chunkSize = 200, tileSize = 25

  for (int i = 0; i < inimigo.length; i++) {
    inimigo[i] = new Enemy(random(200, 600), random(200, 600), random(25, 30), 100, true);
  }

  // Garantir que o jogador não nasça na água ou em um obstáculo
  float playerX, playerY;
  do {
    playerX = random(width); // Gera um lugar aleatório x
    playerY = random(height); // Gera um lugar aleatório y
  } while (map.getTileValue(map.gridPosX((int)playerX), map.gridPosY((int)playerY)) instanceof Agua || // Verifica para não nascer na água
    map.getObstaculo(map.gridPosX((int)playerX), map.gridPosY((int)playerY)) != null);

  player = new Player(playerX, playerY, 20, 100); // Instancia o Player e carrega a espada
  player.loadSword();

  // Adicionar o barco em uma posição aleatória, mas não mais distante do que 40 blocos do ponto inicial do player
  float boatX, boatY;
  do {
    boatX = player.x + random(40, 1) * map.tileSize;
    boatY = player.y + random(40, 1) * map.tileSize;
  } while ((map.getTileValue(map.gridPosX((int)boatX), map.gridPosY((int)boatY)) instanceof Agua) || // Verifica para nascer na água
    map.getObstaculo(map.gridPosX((int)boatX), map.gridPosY((int)boatY)) != null);

  println("Barco gerado em: (" + boatX + ", " + boatY + ")");

  boat = new Boat(boatX, boatY); // Instancia o barco
  player.boat = boat; // Associa o barco ao player
}

// Funções de atualização
void draw() {
  background(200, 125, 70);
  noStroke();
  map.display();
  if (!player.dead) {
    if (boat != null) {
      boat.display(); // Desenha o barco no mapa
    }
    player_spt();
    inimigo_spt();
    if (pressed) {
      map.offsetX = -player.x + width/2;
      map.offsetY = -player.y + height/2;
    }
  } else {
    fill(0);
    text("Voce Morreu", width/2, height/2);
  }
}

void inimigo_spt() {
  for (int i = 0; i < inimigo.length; i++) {
    if (inimigo[i].dead && spawner < millis()) {
      spawner = millis() + 5000;
      inimigo[i].dead = false;
      inimigo[i].hp = 100;

      float mox = player.x + random(-4, 4)*200;
      while (mox < player.x + 400 && mox > player.x - 400) {
        mox = player.x + random(-8, 8)*200;
        inimigo[i].x = mox;
      }

      float moy = player.y + random(-4, 4)*200;
      while (moy < player.y + 400 && moy > player.y - 400) {
        moy = player.y + random(-8, 8)*200;
        inimigo[i].y = moy;
      }
    }
    inimigo[i].update();
    inimigo[i].setTarget(player.x, player.y);
    //verfica se ta no alcance do ataque
    if (player.swordhand == 1 && dist(inimigo[i].xpos, inimigo[i].ypos, player.xpos, player.ypos) < 100) {
      //verifica se esta na direçao do ataque
      if (atan2(player.atax, player.atay)*100 - 140 < atan2(player.xpos - inimigo[i].xpos, player.ypos - inimigo[i].ypos)*100
        &&  atan2(player.atax, player.atay)*100 + 140 > atan2(player.xpos - inimigo[i].xpos, player.ypos - inimigo[i].ypos)*100 ) {
      } else {
        inimigo[i].damage(35);
      }
    }
    if (dist(inimigo[i].xpos, inimigo[i].ypos, player.xpos, player.ypos) < 30 && !player.immune && !inimigo[i].dead) {
      player.damage(15);
    }
  }
}

// M�todo que possui chamadas de fun��o que desenha espada, jogador e os atualiza
void player_spt() {
  player.showItem();
  player.desenha();
  player.move();
  player.CheckInput();
}

// Verifica se o mouse foi pressionado
void mousePressed() {
  if (mouseButton == LEFT) { // Caso o bot�o esquerdo seja pressionado
    if (player.tab > 0) {
      player.setTarget(mouseX - map.offsetX, mouseY - map.offsetY); // Define o "alvo" do player
    } else {
      println("mouse:" + mouseX + " | "  + mouseY);
      moc.caminho(mouseX - map.offsetX, mouseY - map.offsetY);
      String instruc =   moc.criaGrafo();
      
      println(instruc);
      player.moveFromDjisktra(instruc);
      
      


      // Acha o caminho mais curto do barco ate o destino considerando que o player pode andar na agua
      /* moc = new Djisktra(rumo, new PVector(boat.x, boat.y), player.hasBoat);
       // Junta os dois caminhos encontrados
       player.setCaminho(moc.caminho); */
    }
    for (int i = 0; i < inimigo.length; i++) {
      inimigo[i].setTarget(mouseX - map.offsetX, mouseY - map.offsetY);
    }
  } else if (mouseButton == RIGHT) { // Se o bot�o direito for pressionado
    dragging = true; // Status de arrastar fica verdadeiro
    lastMouseX = mouseX; // Atualiza a �ltima posi��o x e y
    lastMouseY = mouseY;
  }
}

// Fun��o para ver quando o mouse for solto, ela ocorre quando o arrastar for verdadeiro
// Assim ela verifica quando para de arrastar e o torna falso
void mouseReleased() {
  if (mouseButton == RIGHT) {
    dragging = false;
  } else if (mouseButton == LEFT) {
    if (player.tab > 0) {
      player.setTarget(mouseX - map.offsetX, mouseY - map.offsetY); // Define o "alvo" do player
    }

    for (int i = 0; i < inimigo.length; i++) {
      inimigo[i].setTarget(mouseX - map.offsetX, mouseY - map.offsetY);
    }
  }
}

// Fun��o chamada quando o mouse � arrastado
void mouseDragged() {
  if (dragging) { // Se o mouse estiver sendo arrastado
    float dx = mouseX - lastMouseX; // Calcula a diferen�a X e Y do movimento do mouse
    float dy = mouseY - lastMouseY;
    map.drag(dx, dy); // Move o mapa de acordo com a diferen�a calculada
    lastMouseX = mouseX; // Atualiza a �ltima posi��o X e Y do mouse
    lastMouseY = mouseY;

    // Em nosso c�digo quando � movido o grid o player se mant�m no mesmo lugar
    // Isso � feito para manter o player no lugar que ele sempre esteve, mas caso queira que ele acompanhe o movimento do grid est� abaixo
    // N�o atualizar a posi��o do jogador ap�s mover o grid
    // player.setTarget(player.x, player.y);
  }
}

// Fun��o para verificar quando uma tecla � pressionada
void keyPressed()
{
  if (key == CODED) {
    if (keyCode == UP) {
      player.tab *= -1;
      println(player.tab);
    }
  }
  if (key == ' ') {
    pressed = true;
  }

  if (key == 'q' || key == 'Q') {
    player.qDown = true;
  }
  if (key == 'w' || key == 'W') {
    player.wDown = true;
  }
  if (key == 'e' || key == 'E') {
    player.eDown = true;
  }
}

// Fun��o para verificar se uma tecla deixou de ser pressionada
void keyReleased()
{
  if (key == ' ') {
    pressed = false;
  }
  if (key == 'q' || key == 'Q') {
    player.qDown = false;
  }
  if (key == 'w' || key == 'W') {  
    player.wDown = false;
  }
  if (key == 'e' || key == 'E') {
    player.eDown = false;
  }
}
