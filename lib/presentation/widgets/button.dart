import 'package:employer_test/presentation/widgets/theme/colors.dart';
import 'package:employer_test/presentation/widgets/theme/text_styles.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class PrimartTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimartTextButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(color: Colors.blue),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Icon icon;

  const AppIconButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      onPressed: onPressed,
      label: Text(label),
      icon: icon,
    );
  }
}
