import 'dart:convert';

SectorSettingsModel sectorSettingsModelFromJson(String str) =>
    SectorSettingsModel.fromJson(json.decode(str));

String sectorSettingsModelToJson(SectorSettingsModel data) =>
    json.encode(data.toJson());

class SectorSettingsModel {
  SectorSettingsModel({
    this.sector1,
    this.sector2,
    this.sector3,
    this.sector4,
  });

  String sector1;
  String sector2;
  String sector3;
  String sector4;

  factory SectorSettingsModel.fromJson(Map<String, dynamic> json) =>
      SectorSettingsModel(
        sector1: json["sector1"],
        sector2: json["sector2"],
        sector3: json["sector3"],
        sector4: json["sector4"],
      );

  Map<String, dynamic> toJson() => {
        "sector1": sector1,
        "sector2": sector2,
        "sector3": sector3,
        "sector4": sector4,
      };
}
