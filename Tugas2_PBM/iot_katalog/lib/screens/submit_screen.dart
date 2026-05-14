import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});
  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _githubController = TextEditingController(text: 'http://github.com/Samuelloading13/tugas-pbm-2026');
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _submitTask() async {
    setState(() => _isLoading = true);
    bool success = await _apiService.submitTask(
      _nameController.text,
      int.tryParse(_priceController.text) ?? 0,
      _descController.text,
      _githubController.text,
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TUGAS BERHASIL DISUBMIT!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal Submit. Coba lagi.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FINAL SUBMIT')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Project Akhir', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Harga', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: 'Deskripsi Project', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _githubController, readOnly: true, decoration: const InputDecoration(labelText: 'Link GitHub', border: OutlineInputBorder())),
            const SizedBox(height: 30),
            _isLoading ? const CircularProgressIndicator() : ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: Colors.teal),
              onPressed: _submitTask,
              child: const Text('SUBMIT TUGAS SEKARANG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}