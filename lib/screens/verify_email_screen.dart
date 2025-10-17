import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _sending = false;
  bool _checking = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text('A verification link was sent to your email. Please open it and then tap "I verified" below.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(children: [
              ElevatedButton(onPressed: _sending ? null : () async { setState(() => _sending = true); await auth.sendEmailVerification(); setState(() => _sending = false); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification email resent.'))); }, child: _sending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Resend email')),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _checking ? null : () async { setState(() => _checking = true); final ok = await auth.refreshAndCheckVerified(); setState(() => _checking = false); if (ok) { Navigator.of(context).pushReplacementNamed('/'); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Still not verified.'))); } }, child: _checking ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('I verified')),
            ]),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () async { await auth.signOut(); Navigator.of(context).popUntil((route) => route.isFirst); }, child: const Text('Cancel / Sign out')),
          ],
        ),
      ),
    );
  }
}