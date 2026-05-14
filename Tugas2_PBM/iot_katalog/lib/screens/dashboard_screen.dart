import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/iot_component.dart';
import 'add_draft_screen.dart';
import 'submit_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<IotComponent>> _draftsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _draftsFuture = _apiService.getDrafts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Katalog'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          IconButton(
            icon: const Icon(Icons.cloud_upload, color: Colors.tealAccent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmitScreen())),
          )
        ],
      ),
      body: FutureBuilder<List<IotComponent>>(
        future: _draftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Draft Kosong. Klik + untuk menambah.'));
          
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF2A2A2A),
                child: ListTile(
                  leading: const Icon(Icons.memory, color: Colors.teal),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Rp ${item.price}\n${item.description}'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddDraftScreen())).then((value) {
            if (value == true) _loadData(); // Otomatis refresh kalau berhasil tambah
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}