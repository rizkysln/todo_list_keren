import 'package:flutter/material.dart';

class DialogKonfirmasiHapus extends StatelessWidget {
  final VoidCallback onHapus;

  DialogKonfirmasiHapus({required this.onHapus});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Konfirmasi Hapus'),
      content: Text('Apakah Anda yakin ingin menghapus tugas ini?'),
      actions: <Widget>[
        TextButton(
          child: Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            onHapus();
            Navigator.of(context).pop();
          },
          child: Text('Hapus'),
        ),
      ],
    );
  }
}
