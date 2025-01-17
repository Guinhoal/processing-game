class Mape { // Classe Map representa o mapa do jogo, composto por vários chunks
  HashMap<String, Chunk> chunks; // Mapa de chunks, indexado por strings de coordenadas
  float offsetX, offsetY; // Deslocamento do mapa na tela
  int chunkSize, tileSize; // Tamanho do chunk e tamanho de cada tile
  int maxChunksPerFrame = 20; // Aumentar o limite de chunks gerados por frame

  //Construtirzinho Padrão
  Mape(int chunkSize, int tileSize) {
    this.chunks = new HashMap<String, Chunk>(); // Inicializa o HashMap de chunks
    this.offsetX = 0; // Inicializa o deslocamento X e Y
    this.offsetY = 0;
    this.chunkSize = chunkSize; // Inicializa o tamanho do chunk e de cada tile
    this.tileSize = tileSize;
  }

  // M�todo para exibir o mapa na tela
  void display() {
    //Calcula os limites de chunks a serem exibidos com base no deslocamento e no tamanho da tela
    int startX = floor(-offsetX / chunkSize) - 2;
    int startY = floor(-offsetY / chunkSize) - 2;
    int endX = startX + ceil(width / chunkSize) + 4;
    int endY = startY + ceil(height / chunkSize) + 4;

    int chunksGenerated = 0;  // Contador de chunks gerados no frame atual

    // Itera sobre a faixa de chunks a serem exibidos
    for (int x = startX; x < endX; x++) {
      for (int y = startY; y < endY; y++) {
        String key = x + "," + y; // Gera a chave do chunk com base nas coordenadas
        if (!chunks.containsKey(key)) { // Verifica se o chunk j� existe no HashMap
          if (chunksGenerated < maxChunksPerFrame) { // Verifica se o limite de chunks gerados por frame foi atingido
            chunks.put(key, new Chunk(x, y, chunkSize, tileSize)); // Gera e adiciona um novo chunk ao HashMap
            chunksGenerated++; // Incrementa o contador de chunks gerados
          } else {
            continue; // Se o limite foi atingido, pula para o pr�ximo chunk
          }
        }
        chunks.get(key).display(offsetX, offsetY); // Exibe o chunk na tela com o deslocamento aplicado
      }
    }
  }

  // Método para arrastar o mapa, ajustando o deslocamento
  void drag(float _offsetX, float _offsetY) {
    offsetX += _offsetX;
    offsetY += _offsetY;
  }

  // Método para converter a posição X da tela para a posição X da grade
  int gridPosX(int xScreen) {
    return floor((-offsetX + xScreen) / tileSize);
  }
  // Método para converter a posição Y da tela para a posição Y da grade
  int gridPosY(int yScreen) {
    return floor((-offsetY + yScreen) / tileSize);
  }

  //Faz o contrário do gridPosX
  int screenPosX(int gridX) {
    return (gridX * tileSize + (int)offsetX) + tileSize / 2;
  }

  //Faz o contrário do gridPosY
  int screenPosY(int gridY) {
    return (gridY * tileSize + (int)offsetY) + tileSize / 2;
  }
  // M�todo para obter o valor do terreno em uma posi��o espec�fica da grade
  Terreno getTileValue(int gridX, int gridY) {
    int chunkX = floor(gridX * tileSize / (float) chunkSize);
    int chunkY = floor(gridY * tileSize / (float) chunkSize);
    String key = chunkX + "," + chunkY; // Gera a chave do chunk com base nas coordenadas

    // Verifica se o chunk j� existe no HashMap, se n�o, cria um novo chunk
    if (!chunks.containsKey(key)) {
      chunks.put(key, new Chunk(chunkX, chunkY, chunkSize, tileSize)); // Adiciona um novo chunk ao HashMap
    }
    Chunk chunk = chunks.get(key); // Obt�m o chunk do HashMap
    int localX = gridX % (chunkSize / tileSize);// Calcula a posi��o X  e Y local dentro do chunk
    int localY = gridY % (chunkSize / tileSize);
    return chunk.getTile(localX, localY); // Retorna o terreno na posi��o local dentro do chunk
  }
  // M�todo para obter o obst�culo em uma posi��o espec�fica da grade
  Obstaculo getObstaculo(int gridX, int gridY) {
    int chunkX = floor(gridX * tileSize / (float) chunkSize);
    int chunkY = floor(gridY * tileSize / (float) chunkSize);
    String key = chunkX + "," + chunkY;

    if (!chunks.containsKey(key)) {
      chunks.put(key, new Chunk(chunkX, chunkY, chunkSize, tileSize));
    }
    Chunk chunk = chunks.get(key);
    int localX = gridX % (chunkSize / tileSize);
    int localY = gridY % (chunkSize / tileSize);

    return chunk.getObstaculo(localX, localY);
  }
}
