import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../models/project_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/project_provider.dart';

class UpdateStatusScreen extends StatefulWidget {
  final ProjectModel project;
  const UpdateStatusScreen({Key? key, required this.project}) : super(key: key);

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  String status = '';
  final reasonCtrl = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    status = widget.project.status;
    reasonCtrl.text = widget.project.reasonForHold ?? '';
  }

  @override
  void dispose() {
    reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final prov = Provider.of<ProjectProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (status == 'On Hold' && reasonCtrl.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Please provide reason for hold');
      return;
    }

    setState(() => loading = true);

    final ok = await prov.updateStatusFlow(
      project: widget.project,
      currentRole: auth.userRole,
      newStatus: status,
      reason: status == 'On Hold' ? reasonCtrl.text.trim() : null,
      userId: auth.user?.id ?? 0,
    );

    setState(() => loading = false);

    if (ok) {
      if (status.toLowerCase() == 'complete') {
        Fluttertoast.showToast(msg: 'Marked complete — sent to next role');
      } else {
        Fluttertoast.showToast(msg: 'Status updated');
      }
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: 'Failed to update status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          DropdownButtonFormField<String>(
            value: status.isEmpty ? widget.project.status : status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: ['Pending', 'On Hold', 'Continue', 'Complete']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => status = v ?? status),
          ),
          const SizedBox(height: 12),
          if (status == 'On Hold') TextField(controller: reasonCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Reason for hold')),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: loading ? null : _save,
              child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save'),
            ),
          )
        ]),
      ),
    );
  }
}
