
class Cvik {
  final String nazev;
  final String kategorie;
  final String popis;
  final String? pomucky;
  final String? videoCesta;
  bool isSelected;


  Cvik({
    required this.nazev,
    required this.kategorie,
    required this.popis,
    this.pomucky,
    this.videoCesta,
    this.isSelected = false,
  });
}