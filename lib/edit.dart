import 'package:flutter/material.dart';

class DialogEditTugas extends StatelessWidget {
  final String tugas;
  final ValueChanged<String> onEdit;

  DialogEditTugas({required this.tugas, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    String tugasBaru = tugas;

    return AlertDialog(
      title: Text('Edit Tugas'),
      content: TextField(
        autofocus: true,
        controller: TextEditingController(text: tugas),
        onChanged: (value) {
          tugasBaru = value;
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            onEdit(tugasBaru);
            Navigator.of(context).pop();
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
