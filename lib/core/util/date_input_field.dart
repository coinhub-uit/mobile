import "package:flutter/material.dart";

class DateInputField extends StatefulWidget {
  final void Function(DateTime?) onDateSelected;
  final DateTime initialDate;
  // ignore: prefer_typing_uninitialized_variables
  final isReadOnly;

  const DateInputField({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
    required this.isReadOnly,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  final _controller = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    _controller.text =
        "${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100);
    final lastDate = now;

    final date = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: selectedDate ?? now,
      helpText: "Select your day of birth",
      cancelText: "Cancel",
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Theme.of(context).colorScheme.primary,
              colorScheme: Theme.of(context).colorScheme,
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              datePickerTheme: const DatePickerThemeData(),
            ),

            child: IconTheme(
              data: const IconThemeData(size: 24),
              child: child!,
            ),
          ),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        _controller.text = "${date.day}/${date.month}/${date.year}";
      });
      widget.onDateSelected(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: widget.isReadOnly ? null : _pickDate,
      decoration: const InputDecoration(
        hintText: "Date of Birth",
        prefixIcon: Icon(Icons.calendar_today),
        border: UnderlineInputBorder(),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty ? "Please select a date" : null,
    );
  }
}
