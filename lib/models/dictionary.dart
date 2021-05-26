class Dictionary {
  String uuid;
  String version;
  int recordTypeStart;
  int recordTypeLen;
  String positions;
  List<dynamic> languages;
  List<dynamic> relation;
  Level level;
  String name;
  String label;
  String note;
  bool zeroFill;
  bool decimalChar;

  Dictionary(
      {this.uuid,
      this.version,
      this.recordTypeStart,
      this.recordTypeLen,
      this.positions,
      this.languages,
      this.relation,
      this.level,
      this.name,
      this.label,
      this.note,
      this.zeroFill,
      this.decimalChar});

  Dictionary.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["version"] is String) this.version = json["version"];
    if (json["recordTypeStart"] is int)
      this.recordTypeStart = json["recordTypeStart"];
    if (json["recordTypeLen"] is int)
      this.recordTypeLen = json["recordTypeLen"];
    if (json["positions"] is String) this.positions = json["positions"];
    if (json["languages"] is List) this.languages = json["languages"] ?? [];
    if (json["relation"] is List) this.relation = json["relation"] ?? [];
    if (json["level"] is Map)
      this.level = json["level"] == null ? null : Level.fromJson(json["level"]);
    if (json["name"] is String) this.name = json["name"];
    if (json["label"] is String) this.label = json["label"];
    if (json["note"] is String) this.note = json["note"];
    if (json["zeroFill"] is bool) this.zeroFill = json["zeroFill"];
    if (json["decimalChar"] is bool) this.decimalChar = json["decimalChar"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["version"] = this.version;
    data["recordTypeStart"] = this.recordTypeStart;
    data["recordTypeLen"] = this.recordTypeLen;
    data["positions"] = this.positions;
    if (this.languages != null) data["languages"] = this.languages;
    if (this.relation != null) data["relation"] = this.relation;
    if (this.level != null) data["level"] = this.level.toJson();
    data["name"] = this.name;
    data["label"] = this.label;
    data["note"] = this.note;
    data["zeroFill"] = this.zeroFill;
    data["decimalChar"] = this.decimalChar;
    return data;
  }
}

class Level {
  List<IdItems> idItems;
  String name;
  String label;
  String note;
  List<Record> records;

  Level({this.idItems, this.name, this.label, this.note, this.records});

  Level.fromJson(Map<String, dynamic> json) {
    if (json["idItems"] is List)
      this.idItems = json["idItems"] == null
          ? []
          : (json["idItems"] as List).map((e) => IdItems.fromJson(e)).toList();
    if (json["name"] is String) this.name = json["name"];
    if (json["label"] is String) this.label = json["label"];
    if (json["note"] is String) this.note = json["note"];
    if (json["records"] is List)
      this.records = json["records"] == null
          ? []
          : (json["records"] as List).map((e) => Record.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.idItems != null)
      data["idItems"] = this.idItems.map((e) => e.toJson()).toList();
    data["name"] = this.name;
    data["label"] = this.label;
    data["note"] = this.note;
    if (this.records != null)
      data["records"] = this.records.map((e) => e.toJson()).toList();
    return data;
  }
}

class Record {
  String name;
  String label;
  String note;
  String recordTypeValue;
  bool required;
  int maxRecords;
  int recordLen;
  List<dynamic> occurrencesLabel;
  List<Items> items;

  Record(
      {this.name,
      this.label,
      this.note,
      this.recordTypeValue,
      this.required,
      this.maxRecords,
      this.recordLen,
      this.occurrencesLabel,
      this.items});

  Record.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) this.name = json["name"];
    if (json["label"] is String) this.label = json["label"];
    if (json["note"] is String) this.note = json["note"];
    if (json["recordTypeValue"] is String)
      this.recordTypeValue = json["recordTypeValue"];
    if (json["required"] is bool) this.required = json["required"];
    if (json["maxRecords"] is int) this.maxRecords = json["maxRecords"];
    if (json["recordLen"] is int) this.recordLen = json["recordLen"];
    if (json["occurrencesLabel"] is List)
      this.occurrencesLabel = json["occurrencesLabel"] ?? [];
    if (json["items"] is List)
      this.items = json["items"] == null
          ? []
          : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["label"] = this.label;
    data["note"] = this.note;
    data["recordTypeValue"] = this.recordTypeValue;
    data["required"] = this.required;
    data["maxRecords"] = this.maxRecords;
    data["recordLen"] = this.recordLen;
    if (this.occurrencesLabel != null)
      data["occurrencesLabel"] = this.occurrencesLabel;
    if (this.items != null)
      data["items"] = this.items.map((e) => e.toJson()).toList();
    return data;
  }
}

class Items {
  String name;
  String label;
  String note;
  bool zeroFill;
  bool decimalChar;
  String itemType;
  String dataType;
  int occurrences;
  int decimal;
  List<dynamic> occurrencesLabel;
  int start;
  int len;
  dynamic valueSet;

  Items(
      {this.name,
      this.label,
      this.note,
      this.zeroFill,
      this.decimalChar,
      this.itemType,
      this.dataType,
      this.occurrences,
      this.decimal,
      this.occurrencesLabel,
      this.start,
      this.len,
      this.valueSet});

  Items.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) this.name = json["name"];
    if (json["label"] is String) this.label = json["label"];
    if (json["note"] is String) this.note = json["note"];
    if (json["zeroFill"] is bool) this.zeroFill = json["zeroFill"];
    if (json["decimalChar"] is bool) this.decimalChar = json["decimalChar"];
    if (json["itemType"] is String) this.itemType = json["itemType"];
    if (json["dataType"] is String) this.dataType = json["dataType"];
    if (json["occurrences"] is int) this.occurrences = json["occurrences"];
    if (json["decimal"] is int) this.decimal = json["decimal"];
    if (json["occurrencesLabel"] is List)
      this.occurrencesLabel = json["occurrencesLabel"] ?? [];
    if (json["start"] is int) this.start = json["start"];
    if (json["len"] is int) this.len = json["len"];
    this.valueSet = json["valueSet"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["label"] = this.label;
    data["note"] = this.note;
    data["zeroFill"] = this.zeroFill;
    data["decimalChar"] = this.decimalChar;
    data["itemType"] = this.itemType;
    data["dataType"] = this.dataType;
    data["occurrences"] = this.occurrences;
    data["decimal"] = this.decimal;
    if (this.occurrencesLabel != null)
      data["occurrencesLabel"] = this.occurrencesLabel;
    data["start"] = this.start;
    data["len"] = this.len;
    data["valueSet"] = this.valueSet;
    return data;
  }
}

class IdItems {
  String name;
  String label;
  String note;
  bool zeroFill;
  bool decimalChar;
  String itemType;
  String dataType;
  int occurrences;
  int decimal;
  List<dynamic> occurrencesLabel;
  int start;
  int len;
  dynamic valueSet;

  IdItems(
      {this.name,
      this.label,
      this.note,
      this.zeroFill,
      this.decimalChar,
      this.itemType,
      this.dataType,
      this.occurrences,
      this.decimal,
      this.occurrencesLabel,
      this.start,
      this.len,
      this.valueSet});

  IdItems.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) this.name = json["name"];
    if (json["label"] is String) this.label = json["label"];
    if (json["note"] is String) this.note = json["note"];
    if (json["zeroFill"] is bool) this.zeroFill = json["zeroFill"];
    if (json["decimalChar"] is bool) this.decimalChar = json["decimalChar"];
    if (json["itemType"] is String) this.itemType = json["itemType"];
    if (json["dataType"] is String) this.dataType = json["dataType"];
    if (json["occurrences"] is int) this.occurrences = json["occurrences"];
    if (json["decimal"] is int) this.decimal = json["decimal"];
    if (json["occurrencesLabel"] is List)
      this.occurrencesLabel = json["occurrencesLabel"] ?? [];
    if (json["start"] is int) this.start = json["start"];
    if (json["len"] is int) this.len = json["len"];
    this.valueSet = json["valueSet"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data["label"] = this.label;
    data["note"] = this.note;
    data["zeroFill"] = this.zeroFill;
    data["decimalChar"] = this.decimalChar;
    data["itemType"] = this.itemType;
    data["dataType"] = this.dataType;
    data["occurrences"] = this.occurrences;
    data["decimal"] = this.decimal;
    if (this.occurrencesLabel != null)
      data["occurrencesLabel"] = this.occurrencesLabel;
    data["start"] = this.start;
    data["len"] = this.len;
    data["valueSet"] = this.valueSet;
    return data;
  }
}
