import 'package:a_dysfagie/models/cvik.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Cvik> vsechnyCviky = [
  Cvik(nazev: 'Cviceni polykani', videoPath: 'assets/videos/meow.mp4'),
  Cvik(nazev: 'Posilovani jazyka', videoPath: 'assets/videos/meow.mp4'),
  Cvik(nazev: 'Nejaky dalsi', videoPath: 'assets/videos/meow.mp4'),
];

final _asyncPrefs = SharedPreferencesAsync();

Future<void> ulozitVybraneCviky() async{
  List<String> vybraneIds = vsechnyCviky
      .where((c) => c.isSelected)
      .map((c) => c.nazev)
      .toList();
  await _asyncPrefs.setStringList('vybrane_cviky_ids', vybraneIds);

}

Future<void> nacistVybraneCviky() async{
  List<String>? vybraneIds = await _asyncPrefs.getStringList('vybrane_cviky_ids');


  if (vybraneIds != null) {
    for (var cvik in vsechnyCviky) {
      cvik.isSelected = vybraneIds.contains(cvik.nazev);
    }
  }
}