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
                onPressed: () async {
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
                },
                child: Text('$selectedDate'.split(' ')[0]),
              ),
              ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  setState(() {
                    if (time != null) {
                      selectedTime = time;
                    }
                  });
                },
                child: Text('$selectedTime'),
              ),
            ],
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isEmpty) return;

            final date = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );

            Navigator.of(context).pop(NewTodo(text: text, date: date));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
