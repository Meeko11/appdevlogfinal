import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isExpanded = false;
  bool _isWeatherExpanded = false; // 👈 added for expandable weather

  List<Map<String, dynamic>> _entries = [];

  void _saveEntry() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _entries.insert(0, {
        'title': 'diary ${DateTime.now().toLocal().toString().split(' ')[0]}',
        'content': _controller.text.trim(),
        'expanded': false,
      });
      _controller.clear();
      _isExpanded = false;
    });
  }

  void _toggleExpand(int index) {
    setState(() {
      _entries[index]['expanded'] = !_entries[index]['expanded'];
    });
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF063851),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello User',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),

            // Diary Input
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      maxLines: _isExpanded ? 10 : 1,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'write something',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      readOnly: !_isExpanded,
                      onTap: () {
                        setState(() => _isExpanded = true);
                      },
                    ),
                    if (_isExpanded)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _saveEntry,
                            icon: const Icon(Icons.save_alt, color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Weather Card (Expandable)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isWeatherExpanded = !_isWeatherExpanded;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade600,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rainy Today", style: TextStyle(color: Colors.purpleAccent)),
                            Text("Monday, July 7", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Icon(Icons.cloud, color: Colors.blueAccent),
                      ],
                    ),
                    if (_isWeatherExpanded) ...[
                      const SizedBox(height: 12),
                      const Text("Temperature: 27°C", style: TextStyle(color: Colors.white)),
                      const Text("Condition: Fair", style: TextStyle(color: Colors.white)),
                      const Text("Feels like: 31°C", style: TextStyle(color: Colors.white)),
                      const Text("Wind: North wind scale", style: TextStyle(color: Colors.white)),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Diary Entries List
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) => _deleteEntry(index),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: GestureDetector(
                      onTap: () => _toggleExpand(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade500,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['title'],
                              style: const TextStyle(color: Colors.pinkAccent, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry['expanded']
                                  ? entry['content']
                                  : entry['content'].length > 40
                                      ? '${entry['content'].substring(0, 40)}...'
                                      : entry['content'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
