// help.dart
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.pinkAccent, body: Column(children: [
      const SizedBox(height: 60),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)), const SizedBox(width: 10), const Text('Help & Support', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))])),
      const SizedBox(height: 20),
      Expanded(child: Container(width: double.infinity, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40))), padding: const EdgeInsets.all(20), child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildHelpItem('How to add a transaction?', 'Go to Transactions tab and click the + button to add new income or expense.'),
        _buildHelpItem('How to create categories?', 'Go to Categories tab and click the + button to create custom categories.'),
        _buildHelpItem('Where can I see my statistics?', 'Visit the Stats tab to see income/expense breakdown and category analysis.'),
        _buildHelpItem('How to update my profile?', 'Go to Profile tab and click Edit Profile to update info.'),
      ])))),
    ]));
  }

  Widget _buildHelpItem(String q, String a) {
    return Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(q, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(a, style: TextStyle(color: Colors.grey[600]))]));
  }
}
