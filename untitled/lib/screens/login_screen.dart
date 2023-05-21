import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Function(String, String) login;
  final Function(String, String, String) register;

  LoginScreen({required this.login, required this.register});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isLoginMode = true;

  void toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'Login' : 'Registration'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    labelText: 'Login',
                  ),
                ),
                SizedBox(height: 16.0),
                if (!isLoginMode)
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (isLoginMode) {
                      widget.login(
                        _loginController.text,
                        _passwordController.text,
                      );
                    } else {
                      widget.register(
                        _loginController.text,
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  child: Text(isLoginMode ? 'Login' : 'Register'),
                ),
                SizedBox(height: 8.0),
                TextButton(
                  onPressed: toggleMode,
                  child: Text(isLoginMode ? 'Switch to Registration' : 'Switch to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
