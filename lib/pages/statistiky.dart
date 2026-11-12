import 'package:flutter/material.dart';
import 'package:a_dysfagie/data/stats_service.dart';

class StatistikyPage extends StatefulWidget {
  const StatistikyPage({super.key});

  @override
  State<StatistikyPage> createState() => _StatistikyPageState();
}

class _StatistikyPageState extends State<StatistikyPage> {
  int dnesSekund = 0;
  int tydenSekund = 0;
  int dnyVTydnu = 0;
  double denniAdherence = 0.0;
  double tydenniAdherence = 0.0;
  String tydenPopisek = '';
  bool nacitam = true; // Na začátku načítáme = true

  @override
  void initState() {
    super.initState();
    _nactiData();
  }

  Future<void> _nactiData() async {
    try {
      final dnes = await StatsService.ziskejDnesniSekundy();
      final tyden = await StatsService.ziskejTydenniStatistiku();
      final adherence = await StatsService.ziskejAdherenci();

      if (mounted) {
        setState(() {
          dnesSekund = dnes;
          tydenSekund = tyden['celkemSekund'] ?? 0;
          dnyVTydnu = tyden['aktivniDni'] ?? 0;
          denniAdherence = (adherence['denniAdherence'] as num?)?.toDouble() ?? 0.0;
          tydenniAdherence = (adherence['tydenniAdherence'] as num?)?.toDouble() ?? 0.0;
          tydenPopisek = adherence['tydenPopisek'] as String? ?? '';
        });
      }
    } catch (e) {
      debugPrint('Chyba na stránce statistiky: $e');
    } finally {
      if (mounted) {
        setState(() {
          nacitam = false; // Načítání dokončeno = false
        });
      }
    }
  }

  String _formatujCas(int sekundy) {
    final min = sekundy ~/ 60;
    final sec = sekundy % 60;
    return '${min}m ${sec}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: const Text('Statistiky cvičení', style: TextStyle(color: Colors.white, fontSize: 26)),
        centerTitle: true,
      ),
      body: nacitam
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.today, color: Colors.teal[700], size: 36),
                title: const Text('Dnešní čas cvičení'),
                subtitle: Text(
                  _formatujCas(dnesSekund),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_view_week, color: Colors.teal[700], size: 36),
                title: const Text('Aktivita za posledních 7 dní'),
                subtitle: Text(
                  '$dnyVTydnu z 7 dní cvičeno',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.timer, color: Colors.teal[700], size: 36),
                title: const Text('Celkový čas za týden'),
                subtitle: Text(
                  _formatujCas(tydenSekund),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.check_circle_outline, color: Colors.teal[700], size: 36),
                title: const Text('Denní adherence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: const Text('Plnění dnešního cvičebního plánu'),
                trailing: Text(
                  '${denniAdherence.toStringAsFixed(1)} %',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(Icons.trending_up, color: Colors.teal[700], size: 36),
                title: const Text('Týdenní adherence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  'Období $tydenPopisek (Po–Ne)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  '${tydenniAdherence.toStringAsFixed(1)} %',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}