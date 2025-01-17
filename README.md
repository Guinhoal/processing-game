# Trabalho Aedes Jogo

Este projeto foi desenvolvido por estudantes do COLTEC na UFMG. Trata-se de um jogo onde o jogador deve navegar por um mapa, coletar itens e evitar inimigos. O jogo foi desenvolvido utilizando Processing.

## Estrutura do Projeto

O projeto possui a seguinte estrutura de arquivos:

### Arquivos e Funções

- **Boat.pde**  
  Define a classe Boat, que representa um barco no jogo. O barco pode ser coletado pelo jogador para navegar na água.

- **Chunk.pde**  
  Define a classe Chunk, que representa uma seção do mapa do jogo. Cada chunk é composto por tiles de terreno e obstáculos.

- **Djisktra.pde**  
  Implementa o algoritmo de Dijkstra para encontrar o caminho mais curto no mapa. A classe Djisktra é responsável por calcular o caminho e converter as coordenadas em direções para o jogador seguir.

- **Enemy.pde**  
  Define a classe Enemy, que representa os inimigos no jogo. Os inimigos perseguem o jogador e podem causar dano.

- **Map.pde**  
  Define a classe Map, que representa o mapa do jogo. O mapa é composto por vários chunks e pode ser arrastado pelo jogador.

- **Obstaculo.pde**  
  Define a classe abstrata Obstaculo e suas subclasses (Pedra, Cactus, Corais), que representam os diferentes tipos de obstáculos no jogo.

- **Player.pde**  
  Define a classe Player, que representa o jogador no jogo. O jogador pode se mover, atacar inimigos, coletar itens e navegar no mapa.

- **Terreno.pde**  
  Define a classe abstrata Terreno e suas subclasses (Agua, Areia, Grama), que representam os diferentes tipos de terreno no jogo.

- **Trabalho_Aedes_Jogo.pde**  
  Arquivo principal do jogo. Contém as funções `setup` e `draw`, que inicializam o jogo e atualizam a tela a cada frame, respectivamente. Também contém funções para lidar com a entrada do jogador (mouse e teclado).

## Funcionalidades do Jogo

- **Movimentação do Jogador**: O jogador pode se mover pelo mapa clicando com o botão esquerdo do mouse. O jogador também pode usar o algoritmo de Dijkstra para encontrar o caminho mais curto até um destino.
- **Inimigos**: Os inimigos perseguem o jogador e causam dano ao entrar em contato. O jogador pode atacar os inimigos com uma espada.
- **Terrenos e Obstáculos**: O mapa é composto por diferentes tipos de terreno (água, areia, grama) e obstáculos (pedras, cactos, corais). O jogador precisa de um barco para navegar na água.
- **Barco**: O jogador pode coletar um barco para navegar na água. O barco é representado por um retângulo marrom no mapa.
- **Vida e Cura**: O jogador possui uma barra de vida que é reduzida ao receber dano dos inimigos. O jogador pode se curar pressionando a tecla `W`.

## Como Jogar

- **Movimentação**: Clique com o botão esquerdo do mouse para definir o destino do jogador. O jogador se moverá automaticamente para o destino.
- **Ataque**: Pressione a tecla `Q` para atacar com a espada.
- **Cura**: Pressione a tecla `W` para se curar.
- **Rolamento**: Pressione a tecla `E` para realizar um rolamento.
- **Arrastar Mapa**: Clique e segure o botão direito do mouse para arrastar o mapa.

## Requisitos

- Processing 3.0 ou superior

## Como Executar

1. Baixe e instale o Processing.
2. Abra o arquivo `Trabalho_Aedes_Jogo.pde` no Processing.
3. Clique no botão "Run" para iniciar o jogo.

## Créditos

Este projeto foi desenvolvido por estudantes do COLTEC na UFMG.

## Contribuições

Contribuições são bem-vindas! Se você deseja melhorar o projeto ou adicionar novas funcionalidades, siga os seguintes passos:

1. **Fork** o repositório.
2. Crie uma branch para sua feature (`git checkout -b feature/nome-da-feature`).
3. Faça suas alterações e commit (`git commit -am 'Adiciona nova feature'`).
4. Envie para a branch principal (`git push origin feature/nome-da-feature`).
5. Abra um pull request.

