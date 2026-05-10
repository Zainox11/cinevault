import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Requirement: Form validation ke liye GlobalKey
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _movieController = TextEditingController();
  final _reasonController = TextEditingController();

  void _submitForm() {
    // Proper Validation logic
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movie Suggestion Sent! Thanks for contributing.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Submit karne ke baad fields saaf kar dena
      _nameController.clear();
      _movieController.clear();
      _reasonController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _movieController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggest a Movie'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Missing a Movie?',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tell us which movie we should add next to CineVault.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // 1. User Name Field
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildDecoration('Your Name', Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 2. Movie Title Field
                TextFormField(
                  controller: _movieController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildDecoration('Movie Title', Icons.movie_outlined),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'What is the movie name?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 3. Reason/Message Field
                TextFormField(
                  controller: _reasonController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: _buildDecoration('Why should we add it?', Icons.edit_note_rounded),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please tell us something about this movie';
                    } else if (value.length < 10) {
                      return 'Please write at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Send Suggestion',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input styling ko saaf rakhne ke liye helper function
  InputDecoration _buildDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey, size: 20),
      labelStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white12),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}