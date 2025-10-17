import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'verify_email_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _pwd2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => v != null && v.trim().length >= 2 ? null : 'Enter name'),
                    const SizedBox(height: 12),
                    TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => v != null && v.contains('@') ? null : 'Enter valid email'),
                    const SizedBox(height: 12),
                    TextFormField(controller: _pwdCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v) => v != null && v.length >= 6 ? null : 'Password >= 6 chars'),
                    const SizedBox(height: 12),
                    TextFormField(controller: _pwd2Ctrl, decoration: const InputDecoration(labelText: 'Confirm password'), obscureText: true, validator: (v) => v == _pwdCtrl.text ? null : 'Passwords do not match'),
                    const SizedBox(height: 16),
                    _loading ? const CircularProgressIndicator() : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => _loading = true);
                        final err = await auth.signUp(email: _emailCtrl.text.trim(), password: _pwdCtrl.text.trim(), name: _nameCtrl.text.trim());
                        setState(() => _loading = false);
                        if (err != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                          return;
                        }
                        // show verify screen
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const VerifyEmailScreen()));
                      },
                      child: const Text('Create account'),
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
