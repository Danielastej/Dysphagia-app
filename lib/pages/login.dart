import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Controllery a stav specifický pro pacienta
  final _ageController = TextEditingController();
  final _reasonController = TextEditingController();
  String? _selectedGender;

  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedRole = 'patient';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();
    final reason = _reasonController.text.trim();

    // Základní kontrola společných polí
    if (email.isEmpty || password.isEmpty || (!_isLogin && name.isEmpty)) {
      _showErrorDialog('Vyplňte prosím všechna povinná pole.');
      return;
    }

    if (!_isLogin && password != confirmPassword) {
      _showErrorDialog('Zadaná hesla se neshodují.');
      return;
    }

    // Kontrola doplňkových polí, pokud se registruje pacient
    int? parsedAge;
    if (!_isLogin && _selectedRole == 'patient') {
      if (ageText.isEmpty || _selectedGender == null || reason.isEmpty) {
        _showErrorDialog('Vyplňte prosím věk, pohlaví a důvod obtíží.');
        return;
      }
      parsedAge = int.tryParse(ageText);
      if (parsedAge == null || parsedAge <= 0 || parsedAge > 120) {
        _showErrorDialog('Zadejte prosím platný věk (1–120 let).');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // --- PŘIHLÁŠENÍ ---
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!mounted) return;

        if (userDoc.exists) {
          String role = userDoc.get('role') ?? 'patient';
          _navigateByRole(role);
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // --- REGISTRACE ---
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Společná data pro pacienta i lékaře
        final Map<String, dynamic> userData = {
          'uid': userCredential.user!.uid,
          'name': name,
          'email': email,
          'role': _selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Doplňková data pouze pro pacienta
        if (_selectedRole == 'patient') {
          userData['age'] = parsedAge;
          userData['gender'] = _selectedGender;
          userData['illnessReason'] = reason;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userData);

        if (!mounted) return;

        _navigateByRole(_selectedRole);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Došlo k chybě.';

      switch (e.code) {
        case 'user-not-found':
          message = 'Zadaný e-mail neexistuje.';
          break;
        case 'wrong-password':
          message = 'Zadali jste špatné heslo.';
          break;
        case 'invalid-credential':
          message = 'Zadaný e-mail nebo heslo nejsou správné.';
          break;
        case 'invalid-email':
          message = 'Zadaný e-mail nemá správný formát.';
          break;
        case 'email-already-in-use':
          message = 'Účet s tímto e-mailem již existuje.';
          break;
        case 'weak-password':
          message = 'Heslo je příliš slabé. Musí mít alespoň 6 znaků.';
          break;
        case 'too-many-requests':
          message = 'Příliš mnoho neúspěšných pokusů. Zkuste to prosím později.';
          break;
        case 'network-request-failed':
          message = 'Chyba připojení k síti. Zkontrolujte internetové připojení.';
          break;
        default:
          message = e.message ?? 'Při přihlašování došlo k chybě.';
      }
      _showErrorDialog(message);
    } catch (e) {
      _showErrorDialog('Chyba: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateByRole(String role) {
    if (role == 'doctor') {
      Navigator.pushReplacementNamed(context, '/doctor_home');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chyba'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.health_and_safety,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isLogin ? 'Přihlášení' : 'Registrace nového účtu',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Jméno a příjmení (společné při registraci)
                  if (!_isLogin) ...[
                    TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Jméno a příjmení',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // E-mail
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Heslo
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Heslo',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Potvrzení hesla (společné při registraci)
                  if (!_isLogin) ...[
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Potvrzení hesla',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Výběr role pomocí moderního RadioGroup
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Registrovat se jako:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    RadioGroup<String>(
                      groupValue: _selectedRole,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedRole = val);
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Pacient'),
                              value: 'patient',
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Lékař'),
                              value: 'doctor',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // --- POLE SPECIFICKÁ POUZE PRO PACIENTA ---
                    if (_selectedRole == 'patient') ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Údaje pro rehabilitaci:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Věk a Pohlaví vedle sebe
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Věk',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedGender,
                              decoration: const InputDecoration(
                                labelText: 'Pohlaví',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Žena',
                                  child: Text('Žena'),
                                ),
                                DropdownMenuItem(
                                  value: 'Muž',
                                  child: Text('Muž'),
                                ),
                                DropdownMenuItem(
                                  value: 'Jiné / Neuvedeno',
                                  child: Text('Neuvedeno'),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() => _selectedGender = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Důvod nemoci / diagnóza
                      TextField(
                        controller: _reasonController,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Důvod nemoci / příčina obtíží',
                          hintText:
                          'např. po CMP, neurologické onemocnění, operace...',
                          prefixIcon: Icon(Icons.medical_information),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],

                  // Tlačítko pro odeslání
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        _isLogin ? 'PŘIHLÁSIT SE' : 'ZAREGISTROVAT SE',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Přepínač mezi přihlášením a registrací
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Nemáte účet? Zaregistrujte se'
                          : 'Již máte účet? Přihlaste se',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}