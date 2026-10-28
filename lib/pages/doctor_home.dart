import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:a_dysfagie/pages/home.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final List<String> availableExercises = [
    'Cviceni polykani',
    'Posilovani jazyka',
    'Nejaky dalsi',
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showAddPatientDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Připojit pacienta'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-mail pacienta',
            hintText: 'pacient@email.cz',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Zrušit'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;

              // Najdeme pacienta v databázi podle e-mailu
              final query = await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: email)
                  .where('role', isEqualTo: 'patient')
                  .get();

              if (query.docs.isNotEmpty) {
                final patientDoc = query.docs.first;
                // Nastavíme u pacienta doctorId na ID přihlášeného doktora
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(patientDoc.id)
                    .update({'doctorId': currentUser?.uid});

                if (!mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pacient $email byl úspěšně přidán.')),
                );
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pacient s tímto e-mailem nebyl nalezen.'),
                  ),
                );
              }
            },
            child: const Text('Přidat'),
          ),
        ],
      ),
    );
  }
  void _editPatientExercises(String patientId, String patientName) async {
    // Načteme stávající nastavené cviky pacienta z Firestore
    final docSnap = await FirebaseFirestore.instance
        .collection('assigned_exercises')
        .doc(patientId)
        .get();

    List<String> currentAssigned = [];
    String frequency = '3x týdně';

    if (docSnap.exists) {
      currentAssigned = List<String>.from(docSnap.get('exercises') ?? []);
      frequency = docSnap.get('frequency') ?? '3x týdně';
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cviky pro: $patientName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Zaškrtněte cviky, které má pacient provádět:',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  // Seznam zaškrtávacích políček pro jednotlivé cviky
                  ...availableExercises.map((exercise) {
                    final isChecked = currentAssigned.contains(exercise);
                    return CheckboxListTile(
                      title: Text(exercise),
                      value: isChecked,
                      onChanged: (bool? val) {
                        setModalState(() {
                          if (val == true) {
                            currentAssigned.add(exercise);
                          } else {
                            currentAssigned.remove(exercise);
                          }
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 16),
                  // Uložení do Firestore
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('assigned_exercises')
                            .doc(patientId)
                            .set({
                          'patientId': patientId,
                          'doctorId': currentUser?.uid,
                          'exercises': currentAssigned,
                          'frequency': frequency,
                          'updatedAt': FieldValue.serverTimestamp(),
                        });

                        if (!mounted) return;
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Plán cvičení byl úspěšně uložen.'),
                          ),
                        );
                      },
                      child: const Text('ULOŽIT PLÁN CVIČENÍ'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        title: const Text('Lékařský panel'),
        actions: [
          // TLAČÍTKO PRO SPUŠTĚNÍ PACIENTSKÉ APLIKACE V DEMO REŽIMU
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(isDemoMode: true),
                ),
              );
            },
            icon: const Icon(Icons.play_circle_fill, color: Colors.white),
            label: const Text(
              'Do aplikace',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Odhlásit se',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Načítáme reálně z databáze pouze pacienty, kteří patří tomuto doktorovi
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'patient')
            .where('doctorId', isEqualTo: currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Zatím nemáte přiřazené žádné pacienty.\nPřidejte pacienta pomocí tlačítka "+".',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          final patients = snapshot.data!.docs;

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index].data() as Map<String, dynamic>;
              final patientId = patients[index].id;
              final name = patient['name'] ?? 'Bez jména';
              final email = patient['email'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(email),
                  trailing: const Icon(Icons.edit_note, size: 28),
                  onTap: () => _editPatientExercises(patientId, name),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPatientDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Přidat pacienta'),
      ),
    );
  }
}
