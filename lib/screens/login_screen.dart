import 'package:flutter/material.dart';
import 'package:aplicativo_caa/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores dos campos de entrada
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Credenciais fictícias para teste
  final String _fakeEmail = "usuario@exemplo.com";
  final String _fakePassword = "senha123";

  // Variável para controlar a visualização da senha
  bool _obscureText = true;

  // Função de login que compara as credenciais e navega para a HomePage em caso de sucesso
  void _login() {
    final inputEmail = _emailController.text;
    final inputPassword = _passwordController.text;

    if (inputEmail == _fakeEmail && inputPassword == _fakePassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email ou senha incorretos!")),
      );
    }
  }

  // Função para o fluxo de redefinição de senha
  void _forgotPassword() {
    // Implemente sua lógica de redefinição de senha aqui
    print("Fluxo para redefinir a senha iniciado.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    // Imagem centralizada
                    Center(
                      child: Image.asset(
                        'assets/images/clinica.jpeg', // Caminho da sua imagem
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 80),
                    // Campos de entrada centralizados (ocupam 80% da largura)
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Column(
                        children: [
                          // Campo de email com bordas arredondadas e estilos para label
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Campo de senha com bordas arredondadas, estilos para label e botão para ocultar/exibir a senha
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Botão "Esqueceu a senha?" com texto na cor preta
                    TextButton(
                      onPressed: _forgotPassword,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text("Esqueceu a senha?"),
                    ),
                    SizedBox(height: 16),
                    // Botão de login centralizado (ocupando 80% da largura) com texto na cor preta
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, // Cor do texto
                        ),
                        onPressed: _login,
                        child: Text("Entrar"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}