class AppVersion {
  String? sId;
  String? latestVersion;
  String? minRequiredVersion;
  bool? forceUpdate;
  String? message;
  String? createdAt;
  String? updatedAt;

  AppVersion({
    this.sId,
    this.latestVersion,
    this.minRequiredVersion,
    this.forceUpdate,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  AppVersion.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    latestVersion = json['latest_version'];
    minRequiredVersion = json['min_required_version'];
    forceUpdate = json['force_update'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['latest_version'] = latestVersion;
    data['min_required_version'] = minRequiredVersion;
    data['force_update'] = forceUpdate;
    data['message'] = message;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
