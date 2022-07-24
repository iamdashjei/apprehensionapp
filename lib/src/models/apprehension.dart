class Apprehension {
    int apprehensionId;
    String apprehensionName;
    String barcode;
    String violations;
    String location;
    String dlNumber;
    String apprehendedBy;
    String createdAt;
    String updatedAt;


    Apprehension.fromJson(Map<String, dynamic> json){
      apprehensionId = json["apprehension_id"];
      apprehensionName = json["apprehension_name"];
      barcode = json["barcode"];
      violations = json["violations"];
      location = json["location"];
      dlNumber = json["dl_number"];
      apprehendedBy = json["apprehended_by"];
      createdAt = json["created_at"];
      updatedAt = json["updated_at"];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['apprehension_name'] = this.apprehensionName;
      data['barcode'] = this.barcode;
      data['violations'] = this.violations;
      data['location'] = this.location;
      data['dl_number'] = this.dlNumber;
      data['apprehended_by'] = this.apprehendedBy;
      data['created_at'] = this.createdAt;
      data['updated_at'] = this.updatedAt;
    }

}