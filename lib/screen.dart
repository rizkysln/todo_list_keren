import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'hapus.dart';
import 'edit.dart';  // Impor edit.dart

class Tugas {
  String nama;
  bool selesai;

  Tugas({required this.nama, this.selesai = false});

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'selesai': selesai,
      };

  static Tugas fromJson(Map<String, dynamic> json) => Tugas(
        nama: json['nama'],
        selesai: json['selesai'],
      );
}

class LayarDaftarTugas extends StatefulWidget {
  @override
  _LayarDaftarTugasState createState() => _LayarDaftarTugasState();
}

class _LayarDaftarTugasState extends State<LayarDaftarTugas> {
  final List<Tugas> _daftarTugas = [];

  @override
  void initState() {
    super.initState();
    _muatTugas();
  }

  void _muatTugas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tugasString = prefs.getString('daftarTugas');
    if (tugasString != null) {
      final List tugasList = jsonDecode(tugasString);
      setState(() {
        _daftarTugas.addAll(
            tugasList.map((data) => Tugas.fromJson(data)).toList());
      });
    }
  }

  void _simpanTugas() async {
    final prefs = await SharedPreferences.getInstance();
    final String tugasString =
        jsonEncode(_daftarTugas.map((tugas) => tugas.toJson()).toList());
    prefs.setString('daftarTugas', tugasString);
  }

  void _tambahTugas(String tugas) {
    if (tugas.isNotEmpty) {
      setState(() {
        _daftarTugas.add(Tugas(nama: tugas));
      });
      _simpanTugas();
    }
  }

  void _hapusTugas(int indeks) {
    setState(() {
      _daftarTugas.removeAt(indeks);
    });
    _simpanTugas();
  }

  void _editTugas(int indeks, String tugasBaru) {
    setState(() {
      _daftarTugas[indeks].nama = tugasBaru;
    });
    _simpanTugas();
  }

  void _toggleSelesai(int indeks) {
    setState(() {
      _daftarTugas[indeks].selesai = !_daftarTugas[indeks].selesai;
    });
    _simpanTugas();
  }

  void _promptTambahTugas() {
    String tugasBaru = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah tugas baru'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              tugasBaru = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () {
                _tambahTugas(tugasBaru);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _konfirmasiHapusTugas(int indeks) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogKonfirmasiHapus(
          onHapus: () {
            _hapusTugas(indeks);
          },
        );
      },
    );
  }

  void _promptEditTugas(int indeks) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogEditTugas(
          tugas: _daftarTugas[indeks].nama,
          onEdit: (tugasBaru) {
            _editTugas(indeks, tugasBaru);
          },
        );
      },
    );
  }

  Widget _bangunItemTugas(Tugas tugas, int indeks) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        title: Text(
          '${indeks + 1}. ${tugas.nama}',
          style: TextStyle(
              decoration: tugas.selesai ? TextDecoration.lineThrough : null),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
              value: tugas.selesai,
              onChanged: (bool? value) {
                _toggleSelesai(indeks);
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _promptEditTugas(indeks),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _konfirmasiHapusTugas(indeks),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunDaftarTugas() {
    return ListView.builder(
      itemCount: _daftarTugas.length,
      itemBuilder: (context, indeks) {
        return _bangunItemTugas(_daftarTugas[indeks], indeks);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Tugas',
          style: TextStyle(
            fontFamily: 'Pacifico', // Pastikan ini sesuai dengan font kustom Anda
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 128, 11, 231),
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.white,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: _bangunDaftarTugas(),
      floatingActionButton: FloatingActionButton(
        onPressed: _promptTambahTugas,
        tooltip: 'Tambah tugas',
        child: Icon(Icons.add),
      ),
    );
  }
}
