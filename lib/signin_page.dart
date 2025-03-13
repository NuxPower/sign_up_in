import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_up_in/signup_page.dart';
import 'package:sign_up_in/user_profile_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  void _setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  void _navigateToProfile(User? user) {
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage(user: user)),
      );
    }
  }

  Future<void> _signInWithEmail() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      _navigateToProfile(userCredential.user);
    } catch (e) {
      _setErrorMessage("Invalid email or password. Please try again.");
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
      _navigateToProfile(userCredential.user);
    } catch (e) {
      _setErrorMessage("Google Sign-In Failed: ${e.toString()}");
    }
  }

  Future<void> _signInWithGitHub() async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();
      githubProvider.setCustomParameters({'prompt': 'select_account'});

      UserCredential userCredential = await _auth.signInWithPopup(githubProvider);
      _navigateToProfile(userCredential.user);
    } catch (e) {
      _setErrorMessage("GitHub Sign-In Failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 📌 App Title
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // 📌 Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // 📌 Password Input
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // 📌 Error Message
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ),

              const SizedBox(height: 16),

              // 📌 Sign In Button
              ElevatedButton(
                onPressed: _signInWithEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Sign In", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 12),

              // 📌 Divider
              const Divider(height: 30, thickness: 1),

              // 📌 Sign In with Google
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Colors.grey),
                ),
                icon: _buildGoogleIcon(), // Use a helper method
                label: const Text(
                  "Sign In with Google",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),


              // 📌 Sign In with GitHub
              ElevatedButton.icon(
                onPressed: _signInWithGitHub,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.code, color: Colors.white),
                label: const Text("Sign In with GitHub", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),

              const SizedBox(height: 20),

              // 📌 Sign Up Option
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                ),
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildGoogleIcon() {
    return Image.asset(
      "google_logo.png",
      height: 24,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error, color: Colors.red); // Fallback icon if image is missing
      },
    );
  }
}
