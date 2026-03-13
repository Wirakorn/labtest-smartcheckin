import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import 'mood_selector.dart';

/// Pre-class reflection form.
/// [onSubmit] is called only after built-in validation passes.
class PreClassForm extends StatefulWidget {
  final void Function({
    required String previousTopic,
    required String expectedTopic,
    required int mood,
  }) onSubmit;

  const PreClassForm({super.key, required this.onSubmit});

  @override
  State<PreClassForm> createState() => _PreClassFormState();
}

class _PreClassFormState extends State<PreClassForm> {
  final _formKey = GlobalKey<FormState>();
  final _prevController = TextEditingController();
  final _expectedController = TextEditingController();
  int? _mood;

  @override
  void dispose() {
    _prevController.dispose();
    _expectedController.dispose();
    super.dispose();
  }

  void _submit() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;
    if (_mood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.moodRequired)),
      );
      return;
    }
    widget.onSubmit(
      previousTopic: _prevController.text.trim(),
      expectedTopic: _expectedController.text.trim(),
      mood: _mood!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Previous topic
          TextFormField(
            controller: _prevController,
            decoration: const InputDecoration(
              labelText: AppStrings.previousTopicLabel,
              hintText: AppStrings.previousTopicHint,
            ),
            maxLines: 2,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? AppStrings.fieldRequired : null,
          ),
          const SizedBox(height: 16),

          // Expected topic
          TextFormField(
            controller: _expectedController,
            decoration: const InputDecoration(
              labelText: AppStrings.expectedTopicLabel,
              hintText: AppStrings.expectedTopicHint,
            ),
            maxLines: 2,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? AppStrings.fieldRequired : null,
          ),
          const SizedBox(height: 24),

          // Mood
          MoodSelector(
            selectedMood: _mood,
            onChanged: (v) => setState(() => _mood = v),
          ),
          const SizedBox(height: 32),

          // Submit
          ElevatedButton(
            onPressed: _submit,
            child: const Text(AppStrings.confirmCheckIn),
          ),
        ],
      ),
    );
  }
}
