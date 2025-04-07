import "package:flutter/material.dart";

class DateInputField extends StatefulWidget {
  final void Function(DateTime?) onDateSelected;

  const DateInputField({super.key, required this.onDateSelected});

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  final _controller = TextEditingController();
  DateTime? selectedDate;

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
      onTap: _pickDate,
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
