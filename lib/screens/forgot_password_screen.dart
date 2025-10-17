import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Your account email',
              ),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () async {
                    setState(() => _loading = true);
                    final err = await auth.sendPasswordReset(
                      _emailCtrl.text.trim(),
                    );
                    setState(() => _loading = false);

                    if (err != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(err)));
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password reset email sent. Check your inbox.',
                        ),
                      ),
                    );
                  },
                  child: const Text('Send password reset email'),
                ),
          ],
        ),
      ),
    );
  }
}
