String getEmojiInterest(String interest) {
  String interestLower = interest.toLowerCase();
  Map<RegExp, String> emojiMap = {
    RegExp(r'programación|programacion|computadora|gaming|informatica|informática') : '💻',
    RegExp(r'fútbol|futbol|balón pie|deportes|baseball') : '⚽',
    RegExp(r'golf|mini-golf|mini golf') : '⛳️',
    RegExp(r'boxeo|combat|boxing') : '🥊',
    RegExp(r'comida') : '🍔',
    RegExp(r'cocina|cocinar') : '🍳',
    RegExp(r'música|musica|cantar') : '🎶',
    RegExp(r'películas|peliculas|series') : '🎬',
    RegExp(r'viajar|vacaciones|explorar|viajes') : '🏝️',
    RegExp(r'literatura|leer|escribir') : '✍️',
    RegExp(r'conocer gente|hablar|socializar') : '🙂',
    RegExp(r'teatro|actuar|drama') : '🎭',
    RegExp(r'museos|historia|exhibiciones') : '🏛️',
    RegExp(r'arte|pintar|velas|cerámica|escultura|ceramica|cerámica') : '🎨',
    RegExp(r'naturaleza|aire libre|jardinería|jardineria|acampada') : '🍃',
    RegExp(r'bordado|costura|coser') : '🪡',
    RegExp(r'crochet|tejer|macrame') : '🧶',
    RegExp(r'tenis|padel') : '🎾',
    RegExp(r'lectura|poesía|poesia') : '📖',
    RegExp(r'baile|bailar|danza') : '💃',
    RegExp(r'fotografía|fotografia|fotos') : '📸',
    RegExp(r'cine|filmes|películas') : '🎥',
    RegExp(r'ciencia|investigación|investigacion') : '🔬',
    RegExp(r'psicología|psicologia|mentes') : '🧠',
    RegExp(r'política|politica|debate') : '🏛️',
    RegExp(r'voluntariado|ayudar|comunidad') : '🤝',
    RegExp(r'bienestar|meditación|meditacion|yoga') : '🧘',
    RegExp(r'fitness|entrenamiento|ejercicio|gym') : '🏋️',
    RegExp(r'animales|mascotas|perros|gatos') : '🐾',
    RegExp(r'montañismo|escalar|senderismo') : '⛰️',
    RegExp(r'astronomía|astronomia|espacio|estrellas') : '🌌',
    RegExp(r'ciclismo|bicicleta|ciclismo de montaña') : '🚴',
    RegExp(r'cerveza|vinos|licores|bebidas') : '🍷',
    RegExp(r'autos|carros|motos|vehículos|formula 1') : '🚗',
    RegExp(r'formula|fórmula|fórmula 1|formula 1|f1') : '🏎️',
    RegExp(r'ajedrez|juegos de mesa|juegos') : '♟️',
    RegExp(r'running|correr|ejercicio|caminar') : '🏃‍➡️',
  };

   for (var entry in emojiMap.entries) {
    if (entry.key.hasMatch(interestLower)) {
      return entry.value;
    }
  }
  return '📌';
}
