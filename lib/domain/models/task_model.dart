class TaskModel {
  final String id;
  final String title;
  final String description;
  final String pictureUrl;
  final String assigneeId;
  final String status;
  final double reward;
  final String createdBy;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pictureUrl,
    required this.assigneeId,
    required this.status,
    required this.reward,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'pictureUrl': pictureUrl,
        'assigneeId': assigneeId,
        'status': status,
        'reward': reward,
        'createdBy': createdBy,
      };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        pictureUrl: map['pictureUrl'] ?? '',
        assigneeId: map['assigneeId'] ?? '',
        status: map['status'] ?? '',
        reward: (map['reward'] ?? 0).toDouble(),
        createdBy: map['createdBy'] ?? '',
      );

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? pictureUrl,
    String? assigneeId,
    String? status,
    double? reward,
    String? createdBy,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      assigneeId: assigneeId ?? this.assigneeId,
      status: status ?? this.status,
      reward: reward ?? this.reward,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
