import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/project_model.dart';
import '../../screens/status/update_status_screen.dart';

class TesterDashboard extends StatefulWidget {
  const TesterDashboard({Key? key}) : super(key: key);

  @override
  State<TesterDashboard> createState() => _TesterDashboardState();
}

class _TesterDashboardState extends State<TesterDashboard> {
  String roleName = 'tester';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).loadProjects(role: roleName);
    });
  }

  Future<void> _refresh() async {
    await Provider.of<ProjectProvider>(context, listen: false).loadProjects(role: roleName);
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProjectProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tester Dashboard'),
        actions: [
          IconButton(onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(context), icon: const Icon(Icons.logout))
        ],
      ),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refresh,
        child: prov.projects.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [SizedBox(height: 200), Center(child: Text('No projects assigned'))],
        )
            : ListView.builder(
          itemCount: prov.projects.length,
          itemBuilder: (ctx, i) {
            final p = prov.projects[i];
            return _projectCard(p, auth.userRole);
          },
        ),
      ),
    );
  }

  Widget _projectCard(ProjectModel p, String currentRole) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 6),
          Text('Client: ${p.clientName}'),
          const SizedBox(height: 4),
          Text('Status: ${p.status}'),
          if (p.reasonForHold != null && p.reasonForHold!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Reason: ${p.reasonForHold}'),
          ],
          const SizedBox(height: 4),
          Text('Assigned Role: ${p.membersNames}'),
        ]),
        isThreeLine: true,
        trailing: ElevatedButton(
          child: const Text('Update'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateStatusScreen(project: p)));
          },
        ),
      ),
    );
  }
}
