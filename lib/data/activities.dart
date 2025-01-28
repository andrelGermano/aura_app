class Activity {
  final String name;
  final String description;
  final String image;

  Activity({required this.name, required this.description, required this.image});
}

List<Activity> getActivities() {
  return [
    Activity(
      name: 'Alongamento',
      description: 'Realize alongamentos dinâmicos para melhorar a flexibilidade, aliviar tensões musculares e prevenir lesões. Exemplos: "Postura do Gato e Vaca" para mobilizar a coluna e melhorar a postura, ou "Postura do Cachorro olhando para baixo" para alongar a cadeia posterior.',
      image: 'assets/images/stretching.png',
    ),
    Activity(
      name: 'Caminhada Rápida',
      description: 'A caminhada rápida é uma excelente forma de ativar a circulação sanguínea e aumentar a energia. Caminhe por 15-20 minutos com foco na postura, e inclua variações de ritmo para um treino de resistência cardiovascular leve.',
      image: 'assets/images/walking.png',
    ),
    Activity(
      name: 'Meditação Guiada - Concentração',
      description: 'Pratique uma meditação focada no controle da respiração e na concentração. Durante 10 minutos, feche os olhos, observe sua respiração e traga sua atenção para o momento presente, ajudando a reduzir o estresse e aumentar a clareza mental.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Meditação - Relaxamento Profundo',
      description: 'Faça uma meditação profunda para liberar o estresse e tensões acumuladas. Foque em relaxar cada parte do corpo, começando pelos pés e subindo até a cabeça. Essa prática de 15 minutos é ideal antes de dormir para melhorar a qualidade do sono.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Yoga - Postura do Guerreiro (Virabhadrasana)',
      description: 'A Postura do Guerreiro é uma posição de força que trabalha as pernas e o equilíbrio. Aprofunde a postura para abrir o quadril e fortalecer os músculos das coxas, e mantenha o olhar focado à frente para melhorar a concentração e o foco.',
      image: 'assets/images/yoga.png',
    ),
    Activity(
      name: 'Yoga - Postura da Árvore (Vrksasana)',
      description: 'Esta postura melhora o equilíbrio e a flexibilidade, além de fortalecer os músculos das pernas. Pratique com os pés bem ancorados no chão e concentre-se na linha reta do corpo enquanto mantém uma respiração profunda e estável.',
      image: 'assets/images/yoga.png',
    ),
    Activity(
      name: 'Corrida Rápida',
      description: 'Corra por 10-15 minutos a uma velocidade moderada a alta para melhorar a resistência cardiovascular. Aumente gradualmente a intensidade para maximizar os benefícios aeróbicos e ajudar na queima de calorias.',
      image: 'assets/images/running.png',
    ),
    Activity(
      name: 'Desafio de Mobilidade - Flexibilidade e Força',
      description: 'Esse desafio consiste em um circuito de 10 flexões, 15 abdominais e 20 polichinelos. Faça 3 a 4 repetições, focando na técnica e no controle do movimento, o que ajuda a melhorar a resistência, a força muscular e a flexibilidade articular.',
      image: 'assets/images/mobility_challenge.png',
    ),
    Activity(
      name: 'Desafio de Mobilidade - Mobilização Articular',
      description: 'Faça 10 minutos de mobilização articular, com rotações de tornozelos, joelhos, quadris, ombros e pescoço, para aumentar a amplitude de movimento. Conclua com alongamentos dinâmicos para otimizar a flexibilidade e a mobilidade das articulações.',
      image: 'assets/images/mobility_challenge.png',
    ),
    Activity(
      name: 'Alongamento para Dormir',
      description: 'Pratique alongamentos suaves antes de dormir, como a "Postura do Pombo" e "Postura da Criança". Esses alongamentos ajudam a liberar as tensões acumuladas durante o dia e a promover um sono tranquilo, reduzindo a rigidez muscular.',
      image: 'assets/images/stretching.png',
    ),
    Activity(
      name: 'Respiração Profunda - Redução de Estresse',
      description: 'Respire profundamente por 5-10 minutos para ativar o sistema nervoso parassimpático, ajudando a reduzir o estresse e a ansiedade. Utilize a técnica de respiração abdominal para maximizar os efeitos de relaxamento.',
      image: 'assets/images/breathing.png',
    ),
    Activity(
      name: 'Meditação - Mindfulness para Iniciantes',
      description: 'Realize uma meditação de mindfulness para aumentar a atenção plena e reduzir a reatividade emocional. Durante 10 minutos, observe seus pensamentos sem julgamento, trazendo sua atenção de volta à respiração sempre que se distrair.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Dança Livre',
      description: 'Dançar livremente é uma excelente forma de liberar tensões e se conectar com o corpo. Escolha suas músicas favoritas e movimente-se por 20-30 minutos, deixando o ritmo guiar o movimento. É uma ótima atividade para liberar endorfina e melhorar o humor.',
      image: 'assets/images/dance.png',
    ),
    Activity(
      name: 'Leitura Rápida - Estímulo Mental',
      description: 'Leia por 30 minutos em um ambiente tranquilo. Isso ajuda a estimular a mente, melhorar a concentração e a memória, além de proporcionar um momento de descanso mental. Escolha temas que desafiem seu pensamento e ampliem seu vocabulário.',
      image: 'assets/images/reading.png',
    ),
    Activity(
      name: 'Massagem Facial',
      description: 'Realize uma massagem facial suave para melhorar a circulação sanguínea e aliviar a tensão acumulada no rosto. Use movimentos circulares, focando nas áreas da testa, bochechas e mandíbula, para ajudar a reduzir os sinais de estresse e cansaço.',
      image: 'assets/images/facial_massage.png',
    ),
    Activity(
      name: 'Tomar um Banho Relaxante',
      description: 'Tome um banho quente de 15-20 minutos com óleos essenciais de lavanda ou camomila. A água morna ajuda a relaxar os músculos e a mente, e os óleos essenciais podem promover o alívio de tensões e o sono profundo.',
      image: 'assets/images/bath.png',
    ),
    Activity(
      name: 'Meditação - Respiração Alternada (Nadi Shodhana)',
      description: 'Pratique a técnica de respiração alternada para equilibrar as energias do corpo e acalmar a mente. Feche uma narina, respire profundamente pela outra, depois troque as narinas e continue alternando. Isso ajuda a melhorar a concentração e o foco.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Yoga - Postura do Cão Olhando para Baixo (Adho Mukha Svanasana)',
      description: 'Esta postura de yoga trabalha a flexibilidade e fortalece os ombros, braços, costas e pernas. Ao se inclinar para a frente, mantenha a coluna reta e os calcanhares em direção ao chão para alongar a cadeia posterior do corpo.',
      image: 'assets/images/yoga.png',
    ),
    Activity(
      name: 'Desafio de Mobilidade - Rotação de Quadris',
      description: 'Execute 10 minutos de rotações de quadris para aumentar a mobilidade da articulação e reduzir tensões na região lombar. A posição de pé ou sentada é ideal para realizar os movimentos circulares de forma controlada e eficaz.',
      image: 'assets/images/mobility_challenge.png',
    ),
    Activity(
      name: 'Alongamento - Posição do Alongamento Lateral',
      description: 'Alongue os músculos laterais do tronco com a postura lateral. Sente-se e estenda uma perna à frente, dobrando a outra por cima. Com as mãos, segure o pé da perna esticada enquanto alonga o tronco para o lado oposto, focando no alongamento dos músculos abdominais e laterais.',
      image: 'assets/images/stretching.png',
    ),
    Activity(
      name: 'Caminhada Mindful',
      description: 'Durante uma caminhada, concentre-se no ato de andar, prestando atenção a cada passo e à sensação de seus pés tocando o chão. Isso ajuda a reduzir o estresse, melhorar o equilíbrio mental e aumentar a sensação de bem-estar.',
      image: 'assets/images/walking.png',
    ),
    Activity(
      name: 'Yoga - Postura da Criança (Balasana)',
      description: 'Postura relaxante, ideal para restaurar a energia. Sente-se sobre os calcanhares e estique os braços para a frente no tapete, com a testa tocando o chão. A postura alivia a tensão na coluna, ombros e pescoço, promovendo sensação de calma e centramento.',
      image: 'assets/images/yoga.png',
    ),
    Activity(
      name: 'Meditação - Observação do Corpo',
      description: 'Realize uma prática de meditação guiada focada em observar o seu corpo, prestando atenção nas sensações físicas e nas áreas de tensão. Essa técnica ajuda a aumentar a percepção corporal e a aliviar tensões específicas.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Desafio de Mobilidade - Agachamento Profundo',
      description: 'Realize agachamentos profundos para trabalhar a mobilidade do quadril e tornozelos. Mantenha os pés alinhados com os ombros, as costas retas e desça o mais baixo possível, ativando glúteos, coxas e core durante o movimento.',
      image: 'assets/images/mobility_challenge.png',
    ),
    Activity(
      name: 'Respiração Ujjayi (Respiração Vitoriosa)',
      description: 'Pratique a respiração Ujjayi, uma técnica de respiração que ajuda a aquecer o corpo e aumentar a concentração durante a prática de yoga. Inspire e expire profundamente pela garganta, criando um som suave que ajuda a concentrar a mente.',
      image: 'assets/images/breathing.png',
    ),
    Activity(
      name: 'Dança Livre - Movimento Espontâneo',
      description: 'Dance de forma livre e espontânea, sem pensar em passos, apenas sentindo a música. Essa atividade ajuda a liberar a criatividade, melhora a coordenação motora e oferece um alívio emocional através da expressão corporal.',
      image: 'assets/images/dance.png',
    ),
    Activity(
      name: 'Alongamento - Flexão Lateral Sentado',
      description: 'Sente-se no chão e estique uma perna enquanto dobra a outra sobre ela. Incline o tronco lateralmente em direção à perna esticada para alongar os músculos laterais do tronco e aumentar a flexibilidade da coluna.',
      image: 'assets/images/stretching.png',
    ),
    Activity(
      name: 'Yoga - Postura do Triângulo (Trikonasana)',
      description: 'A postura do triângulo é excelente para alongar as laterais do corpo, fortalecer as pernas e melhorar o equilíbrio. Com as pernas afastadas, estique os braços em direções opostas e toque o pé da perna esticada com a mão, mantendo o tronco aberto.',
      image: 'assets/images/yoga.png',
    ),
    Activity(
      name: 'Meditação - Visualização Criativa',
      description: 'Pratique uma meditação com foco na visualização positiva. Feche os olhos e imagine-se alcançando seus objetivos ou em um ambiente que traga paz, como uma praia ou uma floresta. Essa prática ajuda a aumentar a motivação e o bem-estar geral.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Desafio de Mobilidade - Alongamento de Pernas',
      description: 'Execute alongamentos dinâmicos para melhorar a flexibilidade das pernas. Faça movimentos controlados, como alcançar os pés com as mãos enquanto mantém os joelhos esticados, para melhorar a amplitude de movimento dos quadris e membros inferiores.',
      image: 'assets/images/mobility_challenge.png',
    ),
    Activity(
      name: 'Meditação - Atenção Plena (Mindfulness)',
      description: 'Pratique a meditação de mindfulness, focando totalmente no momento presente. Sente-se em um local tranquilo e observe seus pensamentos sem julgamento, trazendo a atenção para a respiração e sensações corporais. Isso ajuda a reduzir o estresse e a aumentar o foco.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Meditação - Técnica do Som (Nada Yoga)',
      description: 'Pratique meditação ouvindo sons suaves, como um sino tibetano ou mantras, para acalmar a mente e conectar-se com a vibração do som. A técnica é ideal para restaurar o equilíbrio emocional e promover a serenidade.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Dança Livre - Expressão Corporal',
      description: 'Dança focada em expressão pessoal. Deixe que seus movimentos fluam sem pensar em passos específicos, apenas sentindo a música e explorando as emoções que ela desperta. Isso melhora a conexão entre corpo e mente.',
      image: 'assets/images/dance.png',
    ),
    Activity(
      name: 'Dança - Dança Contemporânea',
      description: 'Experimente uma coreografia de dança contemporânea, misturando movimentos fluidos e expressivos com elementos de outras danças. A dança contemporânea melhora a flexibilidade, a coordenação e a criatividade, além de ajudar na expressão emocional.',
      image: 'assets/images/dance.png',
    ),
    Activity(
      name: 'Meditação - Meditação Guiada para Relaxamento',
      description: 'Ouça uma meditação guiada focada no relaxamento profundo. Imagine uma onda de relaxamento percorrendo seu corpo, desde a cabeça até os pés, ajudando a aliviar o estresse acumulado e promovendo uma sensação de leveza e paz.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Meditação - Meditação do Amor e Compaixão',
      description: 'Pratique uma meditação focada no amor e compaixão, enviando bons desejos para si mesmo e para os outros. Essa prática ajuda a aumentar a empatia e fortalecer as relações, promovendo uma sensação de conexão e paz interior.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Dança - Dança de Salão',
      description: 'Experimente dançar uma coreografia simples de dança de salão, como a valsa ou o tango. A dança de salão trabalha o equilíbrio, a coordenação e a comunicação não-verbal, além de ser uma forma divertida de socializar e relaxar.',
      image: 'assets/images/dance.png',
    ),
    Activity(
      name: 'Dança - Hip Hop',
      description: 'Solte-se ao ritmo do hip hop! Aprenda alguns passos básicos dessa dança energética e divertida. O hip hop melhora a resistência física, coordenação e a capacidade de se expressar através da música.',
      image: 'assets/images/dance.png',
    ),
    Activity(
      name: 'Meditação - Meditação para Iniciantes',
      description: 'Se você é iniciante em meditação, comece com uma prática simples de 5 minutos. Foque na sua respiração e no momento presente. Essa prática ajuda a melhorar a concentração e a reduzir a ansiedade.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Meditação - Meditação de Apreciar o Corpo',
      description: 'Pratique uma meditação focada em apreciar cada parte do seu corpo. Imagine uma luz suave percorrendo seu corpo, começando pelos pés e subindo até a cabeça. Isso ajuda a aumentar a consciência corporal e promover o autocuidado.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Dança Livre - Improviso com Música',
      description: 'Dança espontânea ao som de músicas variadas. Deixe seu corpo seguir o ritmo da música, criando movimentos que se encaixam com a melodia e o batimento. Isso permite uma expressão mais fluida e uma conexão mais profunda com a música.',
      image: 'assets/images/dance.png',
    ),
    Activity(
      name: 'Meditação - Meditação para Redução de Ansiedade',
      description: 'Pratique uma meditação focada na redução da ansiedade. Sente-se confortavelmente e concentre-se na sua respiração, permitindo que cada inspiração e expiração ajude a liberar a tensão e acalmar a mente. Ideal para momentos de estresse elevado.',
      image: 'assets/images/meditation.png',
    ),
    Activity(
      name: 'Dança - Jazz Funk',
      description: 'A dança jazz funk combina movimentos rápidos e enérgicos com expressão pessoal. Siga a música e adicione sua própria interpretação ao estilo. A prática de jazz funk melhora a flexibilidade e a resistência, além de ser muito divertida!',
      image: 'assets/images/dance.png',
    ),
  ];
}
