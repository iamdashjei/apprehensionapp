class Violation{
  int violationId;
  String violationName;
  String value;
  String createdAt;
  String updatedAt;

  Violation({
      this.violationName,
      this.value,
      this.createdAt,
      this.updatedAt
  });

  Violation.fromJson(Map<String, dynamic> json){
    violationId = json["violation_id"];
    violationName = json["violation_name"];
    value = json["value"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['violation_name'] = this.violationName;
    data['value'] = this.value;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
  }
}