class MotivationalPhrases {
  final String phrase;

  MotivationalPhrases({required this.phrase});
}

List<MotivationalPhrases> getPhrases(){
  return [
    MotivationalPhrases(
      phrase: "Acredite em você mesmo e em tudo que você é."
    ),
    MotivationalPhrases(
        phrase: "Cada dia é uma nova chance de ser melhor."
    ),
    MotivationalPhrases(
        phrase: "Você é mais forte do que imagina."
    ),
    MotivationalPhrases(
        phrase: "Grandes conquistas começam com pequenos passos."
    ),
    MotivationalPhrases(
        phrase: "Confie no processo e continue avançando."
    ),
  ];
}