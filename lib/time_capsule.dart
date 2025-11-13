import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth/auth.dart';

class TimeCapsuleScreen extends StatefulWidget {
  const TimeCapsuleScreen({super.key});

  @override
  State<TimeCapsuleScreen> createState() => _TimeCapsuleScreenState();
}

class _TimeCapsuleScreenState extends State<TimeCapsuleScreen> {
  final TextEditingController _controller = TextEditingController();

  int years = 0;
  int months = 0;
  int weeks = 0;

  Future<bool> _saveCapsule() async {
    final uid = appAuth.value.currentUser?.uid;
    final content = _controller.text.trim();
    if (uid == null || content.isEmpty) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in and enter content')),
      );
      return false;
    }
    try {
      final now = DateTime.now();
      final base = now.add(Duration(days: weeks * 7));
      final openAt = DateTime(base.year + years, base.month + months, base.day);
      await FirebaseFirestore.instance.collection('capsules').add({
        'uid': uid,
        'content': content,
        'years': years,
        'months': months,
        'weeks': weeks,
        'createdAt': FieldValue.serverTimestamp(),
        'openAt': Timestamp.fromDate(openAt),
      });
      return true;
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C3C4C), // dark teal bg
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Welcome to Time Capsule",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Textbox
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _controller,
                    expands: true,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "write something...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Set Time Section
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Set Time",
                        style: TextStyle(color: Colors.white)),
                    _timeBox("year", years, (val) {
                      setState(() => years = val);
                    }),
                    _timeBox("months", months, (val) {
                      setState(() => months = val);
                    }),
                    _timeBox("weeks", weeks, (val) {
                      setState(() => weeks = val);
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Save / Discard
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.black,
                      minimumSize: const Size(120, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        years = 0;
                        months = 0;
                        weeks = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.black,
                      minimumSize: const Size(120, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Discard"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirmation dialog
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: const Text(
          "Are you sure you want to save? It can’t be undone once you press yes. "
          "You cannot edit or add anything. Are you sure about this?",
          style: TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              final ok = await _saveCapsule();
              if (!mounted) return;
              if (!ok) return;
              Navigator.push(
                this.context,
                MaterialPageRoute(
                  builder: (context) => CapsuleResultScreen(
                    years: years,
                    months: months,
                    weeks: weeks,
                  ),
                ),
              );
            },
            child: const Text("Yes"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext); // just close
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(this.context);
            },
            child: const Text("Exit"),
          ),
        ],
      ),
    );
  }

  // Custom Time Input Box with + / - buttons
  Widget _timeBox(String label, int value, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white, size: 18),
              onPressed: () {
                if (value > 0) onChanged(value - 1);
              },
            ),
            Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "$value",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              onPressed: () {
                onChanged(value + 1);
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Result screen (like 2nd screenshot)
class CapsuleResultScreen extends StatelessWidget {
  final int years, months, weeks;

  const CapsuleResultScreen({
    super.key,
    required this.years,
    required this.months,
    required this.weeks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C3C4C),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/time_capsule.png"),
              ),
              const SizedBox(height: 10),
              const Text(
                "User name :",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$years years, $months months and $weeks weeks",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "time remaining\nwait to open",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Exit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
