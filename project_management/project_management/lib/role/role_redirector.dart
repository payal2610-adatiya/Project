import 'package:flutter/material.dart';
import 'backend_developer/backend_developer_dashboard.dart';
import 'designer/designer_dashboard.dart';
import 'developer/developer_dashboard.dart';
import 'tester/tester_dashboard.dart';

class RoleRedirector extends StatelessWidget {
  final String role;
  const RoleRedirector({required this.role});

  @override
  Widget build(BuildContext context) {
    final r = role.toLowerCase();
    if (r.contains('designer')) return DesignerDashboard();
    if (r.contains('app_dev') || r.contains('web_dev') || r.contains('developer')) return DeveloperDashboard();
    if (r.contains('backend')) return BackendDashboard();
    if (r.contains('tester')) return TesterDashboard();
    return Scaffold(body: Center(child: Text('Role not implemented: $role')));
  }
}
