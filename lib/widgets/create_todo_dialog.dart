import 'package:flutter/material.dart';
import '../models.dart';

class CreateTodoDialog extends StatefulWidget {
  const CreateTodoDialog({Key? key}) : super(key: key);

  @override
  State<CreateTodoDialog> createState() => _CreateTodoDialogState();
}

class _CreateTodoDialogState extends State<CreateTodoDialog> {
  late final TextEditingController controller;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    controller = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter task'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: selectDate,
                child: DatePreview(selectedDate: selectedDate),
              ),
              ElevatedButton(
                onPressed: selectTime,
                child: TimePreview(selectedTime: selectedTime),
              ),
            ],
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: createTodo,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  void createTodo() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final date = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    Navigator.of(context).pop(Todo(text: text, dateTime: date));
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    setState(() {
      if (date != null) {
        selectedDate = date;
      }
    });
  }

  Future<void> selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    setState(() {
      if (time != null) {
        selectedTime = time;
      }
    });
  }
}

class TimePreview extends StatelessWidget {
  const TimePreview({
    Key? key,
    required this.selectedTime,
  }) : super(key: key);

  final TimeOfDay selectedTime;

  @override
  Widget build(BuildContext context) {
    return Text('$selectedTime');
  }
}

class DatePreview extends StatelessWidget {
  const DatePreview({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Text('$selectedDate'.split(' ')[0]);
  }
}
