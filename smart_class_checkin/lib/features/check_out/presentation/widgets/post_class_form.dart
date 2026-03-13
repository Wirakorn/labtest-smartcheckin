import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Post-class reflection form (learnedToday + feedback + postClassMood).
class PostClassForm extends StatefulWidget {
  final void Function({
    required String learnedToday,
    required String feedback,
    required int postClassMood,
  }) onSubmit;

  const PostClassForm({super.key, required this.onSubmit});

  @override
  State<PostClassForm> createState() => _PostClassFormState();
}

class _PostClassFormState extends State<PostClassForm> {
  final _formKey = GlobalKey<FormState>();
  final _learnedController = TextEditingController();
  final _feedbackController = TextEditingController();
  int? _postClassMood;
  bool _moodError = false;

  @override
  void dispose() {
    _learnedController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submit() {
    final formValid = _formKey.currentState?.validate() ?? false;
    final moodValid = _postClassMood != null;
    setState(() => _moodError = !moodValid);
    if (!formValid || !moodValid) return;
    widget.onSubmit(
      learnedToday: _learnedController.text.trim(),
      feedback: _feedbackController.text.trim(),
      postClassMood: _postClassMood!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Learned today
          TextFormField(
            controller: _learnedController,
            decoration: const InputDecoration(
              labelText: AppStrings.learnedTodayLabel,
              hintText: AppStrings.learnedTodayHint,
            ),
            maxLines: 3,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? AppStrings.fieldRequired : null,
          ),
          const SizedBox(height: 16),

          // Feedback (optional)
          TextFormField(
            controller: _feedbackController,
            decoration: const InputDecoration(
              labelText: AppStrings.feedbackLabel,
              hintText: AppStrings.feedbackHint,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Post-class mood selector
          _PostClassMoodSelector(
            selectedMood: _postClassMood,
            onChanged: (v) => setState(() {
              _postClassMood = v;
              _moodError = false;
            }),
          ),
          if (_moodError) ...[            const SizedBox(height: 4),
            Text(
              AppStrings.moodRequired,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: _submit,
            child: const Text(AppStrings.confirmFinish),
          ),
        ],
      ),
    );
  }
}

// ── Post-class mood selector ──────────────────────────────────────────────────
class _PostClassMoodSelector extends StatelessWidget {
  final int? selectedMood;
  final ValueChanged<int> onChanged;

  static const List<String> _emojis = ['😫', '😒', '😐', '😊', '🤩'];
  static const List<String> _labels = ['ไม่สนุก', 'น่าเบื่อ', 'เฉยๆ', 'สนุก', 'สนุกมาก'];

  const _PostClassMoodSelector({
    required this.selectedMood,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.postClassMoodLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = selectedMood == value;
            return GestureDetector(
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 64,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.moodColors[index]
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.moodColors[index]
                        : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.moodColors[index].withAlpha(76),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_emojis[index], style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 2),
                    Text(
                      _labels[index],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
