import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../core/api_service.dart';

class ProjectProvider extends ChangeNotifier {
  List<ProjectModel> projects = [];
  bool loading = false;

  Future<void> loadProjects({String? role}) async {
    loading = true;
    notifyListeners();
    final r = await ApiService.viewProjects();
    final b = r['body'];
    projects = (b['projects'] as List).map((e) => ProjectModel.fromMap(e)).toList();

    if (role != null) {
      projects = projects.where((p) => p.membersNames.toLowerCase() == role.toLowerCase()).toList();
    }
    loading = false;
    notifyListeners();
  }

  Future<bool> updateStatusFlow({
    required ProjectModel project,
    required String currentRole,
    required String newStatus,
    String? reason,
    required int userId,
  }) async {
    final body1 = {
      'id': project.id.toString(),
      'status': newStatus,
      'user_id': userId.toString(),
      'reason_for_hold': reason ?? '',
    };

    final res = await ApiService.updateProjectStatus(body1);

    if (newStatus.toLowerCase() == "complete") {
      String next = nextRole(currentRole);

      if (next == "admin") {
        print("Final Stage ▶ Admin Handles Project");
      } else {
        final updateData = {
          'id': project.id.toString(),
          'client_name': project.clientName,
          'title': project.title,
          'description': project.description,
          'type': project.type,
          'status': "Pending",
          'members_names': next,
          'start_date': project.startDate,
          'end_date': project.endDate,
        };
        await ApiService.updateProject(updateData);
      }
    }

    await loadProjects(role: nextRole(currentRole) == "admin" ? currentRole : nextRole(currentRole));

    return res['statusCode'] == 200;
  }

  String nextRole(String role) {
    role = role.toLowerCase();
    if (role == "designer") return "developer";
    if (role == "developer") return "backend";
    if (role == "backend") return "tester";
    if (role == "tester") return "admin";
    return role;
  }
}
