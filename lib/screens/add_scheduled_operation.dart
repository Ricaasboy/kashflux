import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';
import '../services/scheduled_operation_service.dart';

class AddScheduledOperation extends StatefulWidget {
  const AddScheduledOperation({super.key});

  @override
  State<AddScheduledOperation> createState() => _AddScheduledOperationState();
}

class _AddScheduledOperationState extends State<AddScheduledOperation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _type = 'expense';
  String _category = 'Food';
  String _repeatType = 'monthly';

  int _scheduledDay = 1;
  int _scheduledMonth = 1;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Housing',
    'Shopping',
    'Salary',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = await SecureStorageService.getEmail();

    if (!mounted) return;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User email not found')),
      );
      return;
    }

    final result = await ScheduledOperationService.addScheduledOperation(
      email: email,
      type: _type,
      category: _category,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      repeatType: _repeatType,
      scheduledDay: _scheduledDay,
      scheduledMonth: _repeatType == 'yearly' || _repeatType == 'once'
          ? _scheduledMonth
          : null,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'No response from server'),
      ),
    );

    if (result['success'] == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool needsMonth = _repeatType == 'yearly' || _repeatType == 'once';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Operation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'expense',
                    label: Text('Expense'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: 'income',
                    label: Text('Income'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (value) {
                  setState(() {
                    _type = value.first;
                  });
                },
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Amount',
                  prefixText: '€ ',
                  border: UnderlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: UnderlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _category = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<String>(
                value: _repeatType,
                decoration: const InputDecoration(
                  labelText: 'Repeat',
                  border: UnderlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'once',
                    child: Text('Once'),
                  ),
                  DropdownMenuItem(
                    value: 'monthly',
                    child: Text('Monthly'),
                  ),
                  DropdownMenuItem(
                    value: 'yearly',
                    child: Text('Yearly'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _repeatType = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              DropdownButtonFormField<int>(
                value: _scheduledDay,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  border: UnderlineInputBorder(),
                ),
                items: List.generate(31, (index) {
                  final day = index + 1;
                  return DropdownMenuItem(
                    value: day,
                    child: Text(day.toString()),
                  );
                }),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _scheduledDay = value;
                  });
                },
              ),

              if (needsMonth) ...[
                const SizedBox(height: 24),
                DropdownButtonFormField<int>(
                  value: _scheduledMonth,
                  decoration: const InputDecoration(
                    labelText: 'Month',
                    border: UnderlineInputBorder(),
                  ),
                  items: List.generate(12, (index) {
                    final month = index + 1;
                    return DropdownMenuItem(
                      value: month,
                      child: Text(month.toString()),
                    );
                  }),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _scheduledMonth = value;
                    });
                  },
                ),
              ],

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save Schedule',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}