import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'verify_email_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff7F00FF), Color(0xffE100FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text('Welcome back', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _pwdCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                            validator: (v) => v != null && v.length >= 6 ? null : 'Password >= 6 chars',
                          ),
                          const SizedBox(height: 16),
                          _loading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) return;
                                    setState(() => _loading = true);
                                    final err = await auth.signIn(email: _emailCtrl.text.trim(), password: _pwdCtrl.text.trim());
                                    setState(() => _loading = false);
                                    if (err != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                                      return;
                                    }
                                    // After sign in, if email not verified, push verify screen
                                    if (auth.user != null && !auth.user!.emailVerified) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VerifyEmailScreen()));
                                    }
                                  },
                                  child: const Text('Sign in'),
                                ),
                          const SizedBox(height: 8),
                          TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())), child: const Text('Forgot password?')),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignUpScreen())), child: const Text('Sign up')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}