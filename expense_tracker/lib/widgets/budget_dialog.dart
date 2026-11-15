import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/formatters.dart';

/// Dialog for editing the monthly budget.
///
/// A StatefulWidget (rather than a controller created in Home) so the
/// TextEditingController is disposed only after the dialog has fully closed.
class BudgetDialog extends StatefulWidget {
  const BudgetDialog({super.key, required this.initialAmount});

  final double initialAmount;

  @override
  State<BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: Formatters.amount(widget.initialAmount),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.of(context).pop(double.tryParse(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Monthly budget'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          onFieldSubmitted: (_) => _submit(),
          decoration: const InputDecoration(
            labelText: 'Budget amount',
            prefixText: '₱ ',
          ),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return 'Enter a budget amount';
            final amount = double.tryParse(text);
            if (amount == null) return 'Enter a valid number';
            if (amount <= 0) return 'Budget must be greater than zero';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
