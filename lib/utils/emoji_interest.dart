String getEmojiInterest(String interest) {
  String interestLower = interest.toLowerCase();
  Map<RegExp, String> emojiMap = {
    RegExp(r'programación|programacion|computadora|gaming|informatica|informática|tecnologia|tecnología') : '💻',
    RegExp(r'fútbol|futbol|balón pie|deportes|baseball') : '⚽',
    RegExp(r'deportes') : '🏈',
    RegExp(r'golf|mini-golf|mini golf') : '⛳️',
    RegExp(r'boxeo|combat|boxing') : '🥊',
    RegExp(r'comida|restaurantes|gastronomía|comer') : '🍔',
    RegExp(r'cocina|cocinar|recetas') : '🍳',
    RegExp(r'música|musica|cantar|instrumentos|bandas|conciertos|recitales') : '🎶',
    RegExp(r'películas|peliculas|series') : '🎬',
    RegExp(r'viajar|vacaciones|explorar|viajes') : '🏝️',
    RegExp(r'literatura|leer|escribir|novelas|poesía|poesia') : '✍️',
    RegExp(r'conocer gente|hablar|socializar|amistades') : '🙂',
    RegExp(r'teatro|actuar|drama|escenario') : '🎭',
    RegExp(r'museos|historia|exhibiciones|arqueología') : '🏛️',
    RegExp(r'arte|pintar|velas|cerámica|escultura|ceramica|dibujo') : '🎨',
    RegExp(r'naturaleza|aire libre|jardinería|jardineria|acampada') : '🍃',
    RegExp(r'bordado|costura|coser|manualidades') : '🪡',
    RegExp(r'crochet|tejer|macrame') : '🧶',
    RegExp(r'tenis|padel') : '🎾',
    RegExp(r'básquet') : '🏀',
    RegExp(r'natación') : '🤿',
    RegExp(r'lectura|poesía|poesia|libros|novelas') : '📖',
    RegExp(r'baile|bailar|danza|ritmo|ballet') : '💃',
    RegExp(r'fotografía|fotografia|fotos|cámaras|camaras') : '📸',
    RegExp(r'cine|filmes|director|actuar|actuacion|actuación') : '🎥',
    RegExp(r'ciencia|investigación|investigacion|tecnología|descubrimientos') : '🔬',
    RegExp(r'psicología|psicologia|mentes|bienestar') : '🧠',
    RegExp(r'política|politica|debate|noticias') : '🏛️',
    RegExp(r'voluntariado|ayudar|comunidad|solidaridad') : '🤝',
    RegExp(r'bienestar|meditación|meditacion|yoga|relajación|relajacion') : '🧘',
    RegExp(r'fitness|entrenamiento|ejercicio|gym|salud') : '🏋️',
    RegExp(r'animales|mascotas|perros|gatos|naturaleza') : '🐾',
    RegExp(r'montañismo|escalar|senderismo|trekking') : '⛰️',
    RegExp(r'astronomía|astronomia|espacio|estrellas|universo') : '🌌',
    RegExp(r'ciclismo|bicicleta|ciclismo de montaña|bici') : '🚴',
    RegExp(r'cerveza|vinos|licores|bebidas|cocteles|bares') : '🍷',
    RegExp(r'autos|carros|motos|vehículos|vehiculos|formula 1') : '🚗',
    RegExp(r'formula|fórmula|fórmula 1|formula 1|f1') : '🏎️',
    RegExp(r'ajedrez|juegos de mesa|juegos|estrategia|estrategia') : '♟️',
    RegExp(r'running|correr|ejercicio|caminar|maratón|maraton') : '🏃',
  };


   for (var entry in emojiMap.entries) {
    if (entry.key.hasMatch(interestLower)) {
      return entry.value;
    }
  }
  return '📌';
}

List<String> getInterestsList() {
  List<String> list = [
    'Seleccionar un interés',
    '💻 Programación',
    '🏈 Deportes',
    '⚽ Fútbol',
    '🏀 Básquet',
    '⛳️ Golf',
    '🥊 Boxeo', 
    '🍔 Comida', 
    '🍳 Cocina', 
    '🎶 Música', 
    '🎬 Películas y Series', 
    '🏝️ Viajar', 
    '✍️ Literatura', 
    '🙂 Conocer gente', 
    '🎭 Teatro', 
    '🏛️ Museos', 
    '🎨 Arte', 
    '♟️ Juegos', 
    '🍃 Naturaleza', 
    '🪡 Costura', 
    '🧶 Crochet', 
    '🎾 Tenis', 
    '📖 Lectura', 
    '💃 Baile', 
    '📸 Fotografía', 
    '🎥 Cine', 
    '🔬 Ciencia', 
    '🧠 Psicología', 
    '🏛️ Política', 
    '🤝 Voluntariado', 
    '🧘 Bienestar', 
    '🏋️ Fitness', 
    '🐾 Animales', 
    '⛰️ Montañismo', 
    '🌌 Astronomía',
    '🚴 Ciclismo', 
    '🍷 Cerveza y Vinos', 
    '🚗 Autos', 
    '🏎️ Fórmula 1', 
    '🏃 Running',
    '🤿 Natación',
  ];

  return list;
}

String extractInterest(String interestWithEmoji) {
  RegExp emojiRegex = RegExp(r'^[^\w]+');
  return interestWithEmoji.replaceAll(emojiRegex, '').trim();
}