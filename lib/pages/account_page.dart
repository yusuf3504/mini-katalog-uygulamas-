import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  bool _loginPassObscure = true;
  bool _registerPassObscure = true;
  bool _registerPass2Obscure = true;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  
  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      isDense: false, 
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16, 
        horizontal: 14,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesabım"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TabBar(
                controller: _tab,
                labelColor: scheme.primary,
                unselectedLabelColor: Colors.black87,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                indicatorColor: scheme.primary,
                indicatorWeight: 3.2,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: "Giriş Yap"),
                  Tab(text: "Kayıt Ol"),
                ],
              ),
            ),
            const SizedBox(height: 12), 

            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  // --------------------------- GİRİŞ YAP ----------------------------
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Column(
                      children: [
                        TextField(
                          decoration: _input("E-posta", Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          obscureText: _loginPassObscure,
                          decoration: _input("Şifre", Icons.lock).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _loginPassObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _loginPassObscure = !_loginPassObscure;
                                });
                              },
                              tooltip: _loginPassObscure
                                  ? 'Şifreyi göster'
                                  : 'Şifreyi gizle',
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Giriş özelliği örnek amaçlı aktif değil."),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Giriş Yap",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        // Şifremi unuttum
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Şifre sıfırlama örnektir."),
                              ),
                            );
                          },
                          child: const Text("Şifremi Unuttum"),
                        ),
                      ],
                    ),
                  ),

                  // --------------------------- KAYIT OL ----------------------------
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Column(
                      children: [
                        TextField(
                          decoration: _input("Ad Soyad", Icons.person),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          decoration: _input("E-posta", Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          obscureText: _registerPassObscure,
                          decoration: _input("Şifre", Icons.lock).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _registerPassObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _registerPassObscure =
                                      !_registerPassObscure;
                                });
                              },
                              tooltip: _registerPassObscure
                                  ? 'Şifreyi göster'
                                  : 'Şifreyi gizle',
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          obscureText: _registerPass2Obscure,
                          decoration:
                              _input("Şifre Tekrar", Icons.lock).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _registerPass2Obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _registerPass2Obscure =
                                      !_registerPass2Obscure;
                                });
                              },
                              tooltip: _registerPass2Obscure
                                  ? 'Şifreyi göster'
                                  : 'Şifreyi gizle',
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Kayıt özelliği örnek amaçlı aktif değil."),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Kayıt Ol",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}