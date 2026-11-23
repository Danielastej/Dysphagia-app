import 'package:a_dysfagie/models/cvik.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Cvik> vsechnyCviky = [
  // --- Posturální techniky ---
  Cvik(
    kategorie: 'Posturální techniky',
    nazev: 'Přítah brady k hrudníku/chin tuck',
    popis: 'Posaďte se a připravte si sousto, které vám doporučil logoped. Než polknete, přitáhněte bradu k hrudníku, jako byste se dívali do svého klína. V této poloze sousto polkněte a potom hlavu vraťte zpět.',
  ),
  Cvik(
    kategorie: 'Posturální techniky',
    nazev: 'Rotace hlavy',
    popis: 'Připravte si sousto. Před polknutím otočte hlavu na stranu, kterou vám určil logoped, jako byste se chtěli podívat na své rameno. Hlavu nechte otočenou a v této poloze polkněte. Potom hlavu vraťte zpět.',
  ),
  Cvik(
    kategorie: 'Posturální techniky',
    nazev: 'Úklon hlavy 1',
    popis: 'Připravte si sousto. Ukloňte hlavu na stranu, kterou vám určil logoped, tak aby se ucho přiblížilo k rameni. Hlavu přitom neotáčejte. V této poloze polkněte a potom hlavu vraťte zpět.',
  ),
  Cvik(
    kategorie: 'Posturální techniky',
    nazev: 'Úklon hlavy 2',
    popis: 'Připravte si sousto. Ukloňte hlavu na stranu, kterou vám určil logoped, tak aby se ucho přiblížilo k rameni. Hlavu přitom neotáčejte. V této poloze polkněte a potom hlavu vraťte zpět.',
  ),
  Cvik(
    kategorie: 'Posturální techniky',
    nazev: 'Přítah brady s rotací hlavy 1',
    popis: 'Připravte si sousto. Přitáhněte bradu šikmo dolů k rameni na straně, kterou vám určil logoped. V této poloze polkněte a potom hlavu vraťte zpět.',
  ),
  Cvik(
    kategorie: 'Posturální techniky',
    nazev: 'Přítah brady s rotací hlavy 2',
    popis: 'Připravte si sousto. Přitáhněte bradu šikmo dolů k rameni na straně, kterou vám určil logoped. V této poloze polkněte a potom hlavu vraťte zpět.',
  ),

  // --- Polykací manévry ---
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Supraglotické polknutí',
    popis: 'Zhluboka se nadechněte a zadržte dech, jako byste se chystali skočit do bazénu. Dech stále držte a polkněte. Ihned po polknutí si odkašlete.',
  ),
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Super-supraglotické polknutí',
    popis: 'Nadechněte se a pevně zadržte dech, jako byste tlačili do krku. Měli byste cítit, že se zapojují i břišní svaly. Zatímco dech stále zadržujete a tlačíte, polkněte. Ihned po polknutí si odkašlete a ještě jednou polkněte.',
  ),
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Usilovné polknutí',
    popis: 'Představte si, že polykáte něco hodně velkého, třeba celé vejce. Zapojte všechny svaly v ústech a v krku a polkněte co nejsilněji.',
  ),
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Mendelsohnův manévr 1',
    popis: 'Jemně si položte prsty na ohryzek. Polkněte a vnímejte prsty, jak se ohryzek při polknutí zvedne nahoru a potom zase klesne dolů. Tento pohyb si dobře zapamatujte, budete ho potřebovat při dalším nácviku.',
  ),
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Mendelsohnův manévr 2',
    popis: 'Polkněte a ve chvíli, kdy je ohryzek v nejvyšší poloze, se ho snažte nahoře udržet jen pomocí svých svalů. Chvíli v této poloze vydržte. Potom svaly uvolněte a polknutí dokončete.',
  ),
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Mendelsohnův manévr 3',
    popis: 'Přiložte prsty na ohryzek. Polkněte, a jakmile se ohryzek zvedne, jemně ho prsty podržte nahoře. Chvíli takto vydržte. Potom ohryzek pusťte a polknutí dokončete.',
  ),
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Masako manévr 1',
    popis: 'Vysuňte jazyk z úst a jeho špičku lehce skousněte mezi zuby. Jazyk nechte mezi zuby a v této poloze polkněte sliny. Potom jazyk uvolněte a vraťte do úst.',
  ),
  Cvik(
    kategorie: 'Polykací manévry',
    nazev: 'Masako manévr 2',
    popis: 'Vysuňte jazyk z úst. Špičku jazyka chyťte přes gázu a přidržte ji prsty, aby se jazyk nevracel do úst. Takto polkněte sliny. Potom jazyk pusťte.',
    pomucky: 'Pomůcky: gáza/kapesník',
  ),

  // --- Posilovací cvičení ---
  Cvik(
    kategorie: 'Posilovací cvičení',
    nazev: 'Shakerův cvik 1',
    popis: 'Lehněte si na záda na rovnou podložku a ruce nechte volně podél těla. Zvedněte hlavu tak, abyste viděli na prsty u nohou. Ramena přitom zůstávají na podložce. Hlavu ihned opatrně položte zpět. Pohyb opakujte několikrát za sebou, nejvýše třicetkrát.',
    pomucky: 'Pomůcky: podložka (postel nebo podložka na cvičení). Pozor: Při potížích s krční páteří tento cvik nedělejte, dokud to nepovolí lékař.',
  ),
  Cvik(
    kategorie: 'Posilovací cvičení',
    nazev: 'Shakerův cvik 2',
    popis: 'Lehněte si na záda na rovnou podložku. Zvedněte hlavu tak, abyste viděli na prsty u nohou, ramena nechte na podložce. V této poloze vydržte, nejdéle jednu minutu. Potom hlavu opatrně položte a jednu minutu odpočívejte. Celé cvičení zopakujte třikrát.',
    pomucky: 'Pomůcky: podložka (postel nebo podložka na cvičení). Pozor: Při potížích s krční páteří tento cvik nedělejte, dokud to nepovolí lékař.',
  ),
  Cvik(
    kategorie: 'Posilovací cvičení',
    nazev: 'Přítah brady proti odporu 1',
    popis: 'Sedněte si rovně a dejte si palce pod bradu. Bradou tlačte dolů proti palcům, jako byste ji chtěli přitáhnout k hrudníku. Chvíli tlačte a potom povolte. Tlačení a uvolnění několikrát vystřídejte.',
  ),
  Cvik(
    kategorie: 'Posilovací cvičení',
    nazev: 'Přítah brady proti odporu 2',
    popis: 'Sedněte si rovně a dejte si pod bradu smotaný menší ručník nebo molitanový míček. Bradou tlačte dolů proti ručníku, jako byste ji chtěli přitáhnout k hrudníku. Chvíli tlačte a potom povolte. Tlačení a uvolnění několikrát vystřídejte.',
    pomucky: 'Pomůcky: smotaný menší ručník nebo molitanový míček.',
  ),
  Cvik(
    kategorie: 'Posilovací cvičení',
    nazev: 'Posilování hlasivkového uzávěru 1',
    popis: 'Sedněte si rovně. Nadechněte se a zadržte dech. Přiložte dlaně k sobě na úrovni hrudníku a silně je zatlačte proti sobě. Chvíli vydržte, potom povolte a vydechněte.',
  ),
  Cvik(
    kategorie: 'Posilovací cvičení',
    nazev: 'Posilování hlasivkového uzávěru 2',
    popis: 'Sedněte si rovně a položte si dlaň na čelo. Nadechněte se a zadržte dech. Tlačte dlaní proti čelu a čelem zároveň proti dlani. Chvíli vydržte, potom povolte a vydechněte.',
  ),
  Cvik(
    kategorie: 'Posilovací cvičení',
    nazev: 'Posilování hlasivkového uzávěru 3',
    popis: 'Sedněte si na pevnou židli. Nadechněte se a zadržte dech. Uchopte židli zespodu po stranách a tlačte, jako byste ji chtěli přitáhnout k sobě a zabořit se do ní. Chvíli vydržte, potom povolte a vydechněte.',
    pomucky: 'Pomůcky: pevná židle bez koleček.',
  ),

  // --- Oromotorická cvičení ---
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Vyplazování jazyka rovně – bez odporu',
    popis: 'Otevřete ústa a vyplázněte jazyk rovně dopředu co nejdále. Jazyk držte uprostřed, aby neuhýbal do strany. Chvíli vydržte a potom jazyk pomalu vraťte do úst.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Vyplazování jazyka rovně – proti odporu',
    popis: 'Otevřete ústa a vyplázněte jazyk, držte ho rovně. Přiložte špátli ke špičce jazyka a tlačte jí proti jazyku, jazykem přitom tlačte proti špátli. Ústa nechte otevřená a dolní čelist nepředsouvejte.',
    pomucky: 'Pomůcky: dřevěná lékařská špátle.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Vyplazování jazyka do stran – bez odporu',
    popis: 'Otevřete ústa a vyplázněte jazyk. Posuňte ho do jednoho koutku úst, chvíli vydržte a potom ho přesuňte do druhého koutku. Hlavou ani bradou přitom nehýbejte.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Vyplazování jazyka do stran – proti odporu',
    popis: 'Vyplázněte jazyk a přiložte špátli k jeho boku. Špátlí tlačte proti jazyku a jazykem zároveň proti špátli. Potom totéž zopakujte na druhé straně jazyka. Brada by se přitom neměla posouvat do strany.',
    pomucky: 'Pomůcky: dřevěná lékařská špátle.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Olizování stoliček 1',
    popis: 'Otevřete ústa. Špičkou jazyka pomalu olízněte zadní zuby (stoličky), nejdříve na jedné straně, potom na druhé. Snažte se dosáhnout co nejdále dozadu.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Olizování stoliček 2',
    popis: 'Otevřete ústa. Špičkou jazyka pomalu olízněte zadní zuby (stoličky), nejdříve na jedné straně, potom na druhé. Snažte se dosáhnout co nejdále dozadu.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Přisátí jazyka k patru',
    popis: 'Otevřete ústa. Přisajte celý jazyk k patru, jako byste chtěli mlasknout, a v této poloze chvíli vydržte. Potom jazyk uvolněte.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Špulení rtů – zepředu',
    popis: 'Sevřete rty k sobě a vyšpulte je co nejvíce dopředu, jako byste chtěli dát pusu. Chvíli vydržte a potom rty uvolněte.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Špulení rtů – z boku',
    popis: 'Sevřete rty k sobě a vyšpulte je co nejvíce dopředu, jako byste chtěli dát pusu. Chvíli vydržte a potom rty uvolněte.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Vtahování rtů – bez pomůcky',
    popis: 'Zavřete ústa a vtáhněte oba rty dovnitř úst. Chvíli vydržte a potom rty uvolněte.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Vtahování rtů – se špátlí',
    popis: 'Vložte si špátli mezi rty a pevně je sevřete. Prsty zkoušejte špátli jemně vytahovat, rty ji přitom držte. Špátli držte jen rty, ne zuby ani dásněmi.',
    pomucky: 'Pomůcky: dřevěná lékařská špátle.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Knoflík na niti',
    popis: 'Na větší knoflík uvažte zubní nebo obyčejnou nit. Knoflík vložte do úst přímo za rty, před zuby, a rty pevně sevřete. Za nit lehce tahejte a snažte se knoflík udržet v ústech. Knoflík držte jen rty, ne zuby ani dásněmi.',
    pomucky: 'Pomůcky: větší knoflík a zubní nebo obyčejná nit.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Boule jazykem do tváří – bez odporu',
    popis: 'Zavřete ústa. Jazykem zatlačte zevnitř do tváře, aby se na ní vytvořila boule, a chvíli vydržte. Potom totéž udělejte na druhé straně.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Boule jazykem do tváří – proti odporu',
    popis: 'Zavřete ústa a jazykem zatlačte zevnitř do tváře. Prstem zvenku tlačte proti bouli a jazykem zároveň proti prstu. Chvíli vydržte a potom totéž udělejte na druhé straně.',
  ),
  Cvik(
    kategorie: 'Oromotorická cvičení',
    nazev: 'Otevírání úst',
    popis: 'Pomalu otevřete ústa co nejvíce. V této poloze chvíli vydržte a potom ústa pomalu zavřete.',
  ),
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