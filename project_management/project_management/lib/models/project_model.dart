class ProjectModel {
  final int id;
  final String clientName, title, description, type, status, membersNames;
  final String startDate, endDate;
  final String? reasonForHold;

  ProjectModel({
    required this.id,
    required this.clientName,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.membersNames,
    required this.startDate,
    required this.endDate,
    this.reasonForHold,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> j) {
    return ProjectModel(
      id: int.parse(j['id'].toString()),
      clientName: j['client_name'] ?? '',
      title: j['title'] ?? '',
      description: j['description'] ?? '',
      type: j['type'] ?? '',
      status: j['status'] ?? 'Pending',
      membersNames: j['members_names'] ?? '',
      startDate: j['start_date'] ?? '',
      endDate: j['end_date'] ?? '',
      reasonForHold: j['reason_for_hold'] ?? '',
    );
  }
}
