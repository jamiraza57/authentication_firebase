import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(onPressed: () async { await auth.signOut(); }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 36, child: Text(user?.displayName != null && user!.displayName!.isNotEmpty ? user.displayName![0].toUpperCase() : 'U')),
                const SizedBox(height: 12),
                Text(user?.displayName ?? 'Anonymous', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text(user?.emailVerified == true ? 'Email verified' : 'Email not verified', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () async { await auth.sendEmailVerification(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification email sent'))); }, child: const Text('Resend verification email')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}