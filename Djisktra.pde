import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Stack;

// Definição da classe Djisktra
class Djisktra {

  ArrayList<String> passagem = new ArrayList<>();
  int mec, mac;

  public Djisktra() {
  }
  void caminho(float wayx, float wayy) {
    float sox = (-player.x + wayx)/map.tileSize;
    float soy = (-player.y + wayy)/map.tileSize;
    sox = (int)Math.ceil(sox);
    soy = (int)Math.ceil(soy);
    passagem.clear();
    mec = 0;
    mac = 0;
    float go = atan2(player.atay, player.atax);
    if (go > 1.6) {
      //<-v
      sox -= 1;
      soy += 1;

      for (int i = 0; i > sox; i -= 1) { //mouseX é MENOR
        mec++;
        for (int d = 0; d < soy; d += 1) { //mouseY é MAIOR
          passagem.add(String.valueOf(myterrain(i*map.tileSize + (int)player.x, d*map.tileSize + (int)player.y)) + "," + mac);
          mac++;
        }
      }
    } else if (go > 0) {
      //v->
      sox += 1;
      soy += 1;

      for (int i = 0; i < sox; i += 1) { //mouseX é MAIOR
        mec++;
        for (int d = 0; d < soy; d += 1) { //mouseY é MAIOR
          passagem.add(String.valueOf(myterrain(i*map.tileSize + (int)player.x, d*map.tileSize + (int)player.y)) + "," + mac);
          mac++;
        }
      }
    } else if (go > -1.6) {
      //^->
      sox += 1;
      soy -= 1;

      for (int i = 0; i < sox; i += 1) { //mouseX é MAIOR
        mec++;
        for (int d = 0; d > soy; d -= 1) { //mouseY é MENOR
          passagem.add(String.valueOf(myterrain(i*map.tileSize + (int)player.x, d*map.tileSize + (int)player.y)) + "," + mac);
          mac++;
        }
      }
    } else if (go < -1.6) {
      //<-^
      sox -= 1;
      soy -= 1;

      for (int i = 0; i > sox; i -= 1) { //mouseX é MENOR
        mec++;
        for (int d = 0; d > soy; d -= 1) {  //mouseY é MENOR
          passagem.add(String.valueOf(myterrain(i*map.tileSize + (int)player.x, d*map.tileSize + (int)player.y)) + "," + mac);
          mac++;
        }
      }
    }
  }



  int myterrain(int x1, int y1) {
    int gridX = map.gridPosX((int)(x1 + map.offsetX));
    int gridY = map.gridPosY((int)(y1 + map.offsetY));

    Terreno tile = map.getTileValue(gridX, gridY);
    int dif = 1000000;

    if (tile != null) {
      if (tile.dificuldade == 1 && player.hasBoat) {
        dif = 1;
        println("agua");
      } else if (tile.dificuldade == 2) {
        dif = 2;
        println("grama");
      } else if (tile.dificuldade == 4) {
        dif = 4;
        println("areia");
      }
    }
    println("Inandavel");
    return dif;
  }

  String criaGrafo() {
    Grafo<String> graph = new Grafo<>();

    // Adiciona todos os vértices ao grafo
    for (String vertice : passagem) {
      graph.adicionarVertice(vertice);
    }

    // Número total de células na passagem
    int totalPassagem = passagem.size();

    // Adiciona arestas entre vizinhos
    for (int i = 0; i < totalPassagem; i++) {
      String atual = passagem.get(i);

      int dificuldadeAtual;
      int numeroAtual;

      String[] partes = atual.split(",");
      if (partes.length == 2) {
        dificuldadeAtual = Integer.parseInt(partes[0].trim());
        numeroAtual = Integer.parseInt(partes[1].trim());
      } else {
        continue;
      }

      int[] direcoesX = {-1, 1, 0, 0}; // Movimentos em X: esquerda, direita, cima, baixo
      int[] direcoesY = {0, 0, -1, 1}; // Movimentos em Y: esquerda, direita, cima, baixo

      for (int d = 0; d < 4; d++) {
        int novoX = (i % mec) + direcoesX[d];
        int novoY = (i / mec) + direcoesY[d];

        if (novoX >= 0 && novoX < mec && novoY >= 0 && novoY < totalPassagem / mec) {
          int novoIndice = novoY * mec + novoX;
          if (novoIndice >= 0 && novoIndice < totalPassagem) {
            String vizinho = passagem.get(novoIndice);
            int dificuldadeVizinho;
            String[] partesVizinho = vizinho.split(",");
            if (partesVizinho.length == 2) {
              dificuldadeVizinho = Integer.parseInt(partesVizinho[0].trim());
              graph.adicionarAresta(dificuldadeVizinho, atual, vizinho);
            }
          }
        }
      }
    }

    for (Aresta<String> aresta : graph.arestas) {
      System.out.println("Aresta de " + aresta.getInicio().getDado() + " para " + aresta.getFim().getDado() + " com peso " + aresta.getPeso());
    }

    // Implementar algoritmo de Dijkstra
    String instruc = dijkstraAlgoritmo(graph, passagem.get(0), passagem.get(passagem.size() - 1));

    return instruc;
  }

  String dijkstraAlgoritmo(Grafo<String> graph, String origem, String destino) {
    // Mapeia as distâncias mínimas e os predecessores
    Map<String, Float> distancias = new HashMap<>();
    Map<String, String> predecessores = new HashMap<>();
    PriorityQueue<Vertice<String>> pq = new PriorityQueue<>((a, b) -> Float.compare(distancias.get(a.getDado()), distancias.get(b.getDado())));

    for (Vertice<String> vertice : graph.vertices) {
      distancias.put(vertice.getDado(), Float.MAX_VALUE);
      predecessores.put(vertice.getDado(), null);
      pq.add(vertice);
    }
    distancias.put(origem, 0f);

    while (!pq.isEmpty()) {
      Vertice<String> u = pq.poll();

      if (distancias.get(u.getDado()) == Float.MAX_VALUE) break;

      for (Aresta<String> aresta : u.getArestasSaida()) {
        Vertice<String> v = aresta.getFim();
        float novaDistancia = distancias.get(u.getDado()) + aresta.getPeso();

        if (novaDistancia < distancias.get(v.getDado())) {
          distancias.put(v.getDado(), novaDistancia);
          predecessores.put(v.getDado(), u.getDado());
          pq.add(v);
        }
      }
    }

    // Reconstruir o caminho
    StringBuilder caminho = new StringBuilder();
    Stack<String> pilha = new Stack<>();
    String passo = destino;

    while (passo != null) {
      pilha.push(passo);
      passo = predecessores.get(passo);
    }

    // Convertendo o caminho para direções
    String instruc = converterParaDirecoes(pilha);

    return instruc;
  }

  String converterParaDirecoes(Stack<String> caminho) {
    StringBuilder instruc = new StringBuilder();
    String prev = null;
    String current;

    while (!caminho.isEmpty()) {
      current = caminho.pop();

      if (prev != null) {
        int[] coordsPrev = parseCoords(prev);
        int[] coordsCurr = parseCoords(current);

        if (coordsCurr[0] > coordsPrev[0]) {
          instruc.append('>');
        } else if (coordsCurr[0] < coordsPrev[0]) {
          instruc.append('<');
        }

        if (coordsCurr[1] > coordsPrev[1]) {
          instruc.append('v');
        } else if (coordsCurr[1] < coordsPrev[1]) {
          instruc.append('^');
        }
      }
      prev = current;
    }
    return instruc.toString();
  }

  int[] parseCoords(String vertice) {
    String[] partes = vertice.split(",");
    if (partes.length == 2) {
      return new int[]{Integer.parseInt(partes[0].trim()), Integer.parseInt(partes[1].trim())};
    }
    return new int[]{0, 0};
  }
}

// Outras classes necessárias para o funcionamento do código:
class Grafo<TIPO> {
  private ArrayList<Vertice<TIPO>> vertices;
  private ArrayList<Aresta<TIPO>> arestas;

  public Grafo() {
    this.vertices = new ArrayList<>();
    this.arestas = new ArrayList<>();
  }

  public void adicionarVertice(TIPO dado) {
    Vertice<TIPO> novoVertice = new Vertice<>(dado);
    this.vertices.add(novoVertice);
  }

  public void adicionarAresta(int peso, TIPO dadoInicio, TIPO dadoFim) {
    Vertice<TIPO> inicio = this.getVertice(dadoInicio);
    Vertice<TIPO> fim = this.getVertice(dadoFim);
    Aresta<TIPO> aresta = new Aresta<>(peso, inicio, fim);
    inicio.adicionarArestaSaida(aresta);
    fim.adicionarArestaEntrada(aresta);
    this.arestas.add(aresta);
  }

  public Vertice<TIPO> getVertice(TIPO dado) {
    for (Vertice<TIPO> vertice : this.vertices) {
      if (vertice.getDado().equals(dado)) {
        return vertice;
      }
    }
    return null;
  }
}

class Vertice<TIPO> {
  private TIPO dado;
  private ArrayList<Aresta<TIPO>> arestasSaida;
  private ArrayList<Aresta<TIPO>> arestasEntrada;

  public Vertice(TIPO dado) {
    this.dado = dado;
    this.arestasSaida = new ArrayList<>();
    this.arestasEntrada = new ArrayList<>();
  }

  public TIPO getDado() {
    return dado;
  }

  public ArrayList<Aresta<TIPO>> getArestasSaida() {
    return arestasSaida;
  }

  public ArrayList<Aresta<TIPO>> getArestasEntrada() {
    return arestasEntrada;
  }

  public void adicionarArestaSaida(Aresta<TIPO> aresta) {
    this.arestasSaida.add(aresta);
  }

  public void adicionarArestaEntrada(Aresta<TIPO> aresta) {
    this.arestasEntrada.add(aresta);
  }
}

class Aresta<TIPO> {
  private int peso;
  private Vertice<TIPO> inicio;
  private Vertice<TIPO> fim;

  public Aresta(int peso, Vertice<TIPO> inicio, Vertice<TIPO> fim) {
    this.peso = peso;
    this.inicio = inicio;
    this.fim = fim;
  }

  public int getPeso() {
    return peso;
  }

  public Vertice<TIPO> getInicio() {
    return inicio;
  }

  public Vertice<TIPO> getFim() {
    return fim;
  }
}
