import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentseller/view/loginview.dart';
import '../view_model/authview.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  final TextEditingController reset = TextEditingController();

  @override
  void dispose() {
    reset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon:  Icon(CupertinoIcons.back),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                   SizedBox(height: 20),
                   Text(
                    "Forgot Password?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                   SizedBox(
                    height: 50,
                    child: Text(
                      "Change your password",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon:  Icon(Icons.email),
                        hintText: "Enter your email address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: reset,
                    ),
                  ),
                   SizedBox(height: 10),
                  GestureDetector(
                    onTap: authVM.isLoading
                        ? null
                        : () async {
                      var email = reset.text.trim();
                      if (email.contains("@")) {
                        bool success = await authVM.forgotPassword(email: email);

                        if (!mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Reset link sent successfully"),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginView()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Failed to send reset link."),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            backgroundColor: Colors.orange,
                            content: Text("Please enter a valid email address"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: authVM.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                          "Send reset link",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}