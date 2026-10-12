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
  bool nacteno = false;

  @override
  void initState() {
    super.initState();
    _nactiData();
  }

  Future<void> _nactiData() async {
    final dnes = await StatsService.ziskejDnesniSekundy();
    final tyden = await StatsService.ziskejTydenniStatistiku();

    setState(() {
      dnesSekund = dnes;
      tydenSekund = tyden['celkemSekund'];
      dnyVTydnu = tyden['aktivniDni'];
      nacteno = true;
    });
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
      body: !nacteno
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.today, color: Colors.teal[700], size: 36),
                title: const Text('Dnešní čas cvičení'),
                subtitle: Text(_formatujCas(dnesSekund), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_view_week, color: Colors.teal[700], size: 36),
                title: const Text('Aktivita za posledních 7 dní'),
                subtitle: Text('$dnyVTydnu z 7 dní cvičeno', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(Icons.timer, color: Colors.teal[700], size: 36),
                title: const Text('Celkový čas za týden'),
                subtitle: Text(_formatujCas(tydenSekund), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}