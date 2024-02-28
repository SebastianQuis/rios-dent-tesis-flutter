
String capitalizarPalabra(String? palabra){
  dynamic palabras = palabra?.split(' ') ?? '';
  palabras = palabras.map( (p) => p[0].toUpperCase() + p.substring(1) );
  return palabras.join(' ');
}