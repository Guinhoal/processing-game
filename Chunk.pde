class Chunk { // Classe Chunk representa uma seção do mapa do jogo
  int chunkX, chunkY; // Coordenadas do chunk no mapa
  int chunkSize, tileSize;// Tamanho do chunk e tamanho de cada tile
  Terreno[][] tiles; //Matriz de Tiles terrenos do chunk
  Obstaculo[][] obstaculos; // Matriz de obst�culos do chunk

  // Construtor da classe Chunk
  Chunk(int chunkX, int chunkY, int chunkSize, int tileSize) {
    this.chunkX = chunkX; // Inicializa a coordenada X e Y do chunk
    this.chunkY = chunkY;
    this.chunkSize = chunkSize; //Inicializa o tamanho do chunk
    this.tileSize = tileSize; // Inicializa o tamanho de cada tile
    this.tiles = new Terreno[chunkSize / tileSize][chunkSize / tileSize]; // Inicializa a matriz de tiles
    this.obstaculos = new Obstaculo[chunkSize / tileSize][chunkSize / tileSize]; // Inicializa a matriz de obst�culos
    generateChunk(); //Gera o chunk
  }

  // Método para gerar o conteúdo do chunk
  void generateChunk() {
    // M�todo para gerar o conte�do do chunk
    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        // Calcula um valor de ru�do para determinar o tipo de terreno
        float noiseValue = noise((chunkX * chunkSize + x * tileSize) * 0.01, (chunkY * chunkSize + y * tileSize) * 0.01);
        // Define o tipo de terreno com base no valor de ru�do
        if (noiseValue < 0.3) {
          tiles[x][y] = new Agua(); // Define o tile como �gua

          // Adicionar obst�culos
          if (random(1) < 0.01) {// 0.5% de chance de adicionar um obst�culo
            obstaculos[x][y] = new Corais(); // Adiciona Cactus se o tile for Areia
            tiles[x][y] = null;
          }
        } else if (noiseValue < 0.6) {
          tiles[x][y] = new Grama(); // Define o tile como Grama

          // Adicionar obst�culos
          if (random(1) < 0.01) {// 0.5% de chance de adicionar um obst�culo
            obstaculos[x][y] = new Pedra(); // Adiciona Cactus se o tile for Areia
            tiles[x][y] = null;
          }
        } else {

          tiles[x][y] = new Areia(); // Define o tile como Areia

          // Adicionar obst�culos
          if (random(1) < 0.01) {// 0.5% de chance de adicionar um obst�culo
            obstaculos[x][y] = new Cactus(); // Adiciona Cactus se o tile for Areia
            tiles[x][y] = null;
          }
        }
      }
    }
  }

  // M�todo para obter o terreno em uma posi��o espec�fica dentro do chunk
  Terreno getTile(int localX, int localY) {
    // Verifica se as coordenadas est�o dentro dos limites da matriz de tiles
    if (localX >= 0 && localX < tiles.length && localY >= 0 && localY < tiles[0].length) {
      return tiles[localX][localY]; // Retorna o terreno na posi��o especificada
    } else {
      return null; //Se n existir retona null
    }
  }

  // M�todo para obter o obst�culo em uma posi��o espec�fica dentro do chunk
  Obstaculo getObstaculo(int localX, int localY) {
    if (localX >= 0 && localX < obstaculos.length && localY >= 0 && localY < obstaculos[0].length) {
      return obstaculos[localX][localY];
    } else {
      return null;
    }
  }

  // M�todo para exibir o chunk na tela
  void display(float offsetX, float offsetY) {
    //Itera sobre cada tile no chunk
    for (int x = 0; x < chunkSize / tileSize; x++) {
      for (int y = 0; y < chunkSize / tileSize; y++) {
        // Calcula a posi��o na tela para o tile atual
        float screenX = chunkX * chunkSize + x * tileSize + offsetX;
        float screenY = chunkY * chunkSize + y * tileSize + offsetY;

        // Verifica se o tile est� fora da tela e, se estiver, pula para o pr�ximo tile
        if (screenX + tileSize < 0 || screenX > width || screenY + tileSize < 0 || screenY > height) {
          continue;
        }

        pushMatrix();
        translate(screenX, screenY);
        if (tiles[x][y] != null) {

          fill(tiles[x][y].cor);
          rect(0, 0, tileSize, tileSize);
          // Se houver um obst�culo no tile, define a cor de preenchimento e desenha o ret�ngulo
        } else {
          fill(obstaculos[x][y].cor);
          rect(0, 0, tileSize, tileSize);
        }
        popMatrix();
      }
    }
  }

  /*void addChunkToGraph(Graph graph) {
   for (int x = 0; x < chunkSize / tileSize; x++) {
   for (int y = 0; y < chunkSize / tileSize; y++) {
   // Gerar identificador único para o bloco
   String vertexId = "BLOCO_" + (chunkX * chunkSize + x * tileSize) + "_" + (chunkY * chunkSize + y * tileSize);
   Terreno terreno = getTile(x, y);
   
   if (terreno != null) {
   // Adiciona o vértice ao grafo
   if (terreno.dificuldade == 1) {
   if (player.hasBoat) {
   graph.addVertex(vertexId, "AGUA COM BARCO");
   } else {
   graph.addVertex(vertexId, "AGUA SEM BARCO");
   }
   } else if (terreno.dificuldade == 2) {
   graph.addVertex(vertexId, "GRAMA");
   } else {
   graph.addVertex(vertexId, "AREIA");
   }
   
   // Conectar com o bloco à direita
   if (x + 1 < chunkSize / tileSize && getTile(x + 1, y) != null) {
   String rightVertexId = "BLOCO_" + (chunkX * chunkSize + (x + 1) * tileSize) + "_" + (chunkY * chunkSize + y * tileSize);
   graph.addEdge(vertexId, rightVertexId);
   }
   
   // Conectar com o bloco abaixo
   if (y + 1 < chunkSize / tileSize && getTile(x, y + 1) != null) {
   String belowVertexId = "BLOCO_" + (chunkX * chunkSize + x * tileSize) + "_" + (chunkY * chunkSize + (y + 1) * tileSize);
   graph.addEdge(vertexId, belowVertexId);
   }
   }
   }
   }
   }*/
}
