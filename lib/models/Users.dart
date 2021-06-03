class Users {
  String uuid;
  String version;
  int recordTypeStart;
  int recordTypeLen;
  String positions;
  Map<String, String> languages;
  List<String> relation;
  Level level;
  String name;
  String label;
  String note;
  bool zeroFill;
  bool decimalChar;

  Users(
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

  Users.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    version = json['version'];
    recordTypeStart = json['recordTypeStart'];
    recordTypeLen = json['recordTypeLen'];
    positions = json['positions'];
    if (json['languages'] != null) {
      languages = Map<String, String>();
      (json['languages'] as Map).forEach((k, v) {
        languages[k] = v;
      });
    }
    if (json['relation'] != null) {
      relation = [];
      json['relation'].forEach((v) {
        relation.add(v);
      });
    }
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    name = json['name'];
    label = json['label'];
    note = json['note'];
    zeroFill = json['zeroFill'];
    decimalChar = json['decimalChar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['version'] = this.version;
    data['recordTypeStart'] = this.recordTypeStart;
    data['recordTypeLen'] = this.recordTypeLen;
    data['positions'] = this.positions;
    if (this.languages != null) {
      data['languages'] = this.languages;
    }
    if (this.relation != null) {
      data['relation'] = this.relation;
    }
    if (this.level != null) {
      data['level'] = this.level.toJson();
    }
    data['name'] = this.name;
    data['label'] = this.label;
    data['note'] = this.note;
    data['zeroFill'] = this.zeroFill;
    data['decimalChar'] = this.decimalChar;
    return data;
  }
}

class Level {
  List<IdItems> idItems;
  String name;
  String label;
  String note;
  List<Records> records;

  Level({this.idItems, this.name, this.label, this.note, this.records});

  Level.fromJson(Map<String, dynamic> json) {
    if (json['idItems'] != null) {
      idItems = [];
      json['idItems'].forEach((v) {
        idItems.add(new IdItems.fromJson(v));
      });
    }
    name = json['name'];
    label = json['label'];
    note = json['note'];
    if (json['records'] != null) {
      records = [];
      json['records'].forEach((v) {
        records.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.idItems != null) {
      data['idItems'] = this.idItems.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['label'] = this.label;
    data['note'] = this.note;
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
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
  List<String> occurrencesLabel;
  int start;
  int len;

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
      this.len});

  IdItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    note = json['note'];
    zeroFill = json['zeroFill'];
    decimalChar = json['decimalChar'];
    itemType = json['itemType'];
    dataType = json['dataType'];
    occurrences = json['occurrences'];
    decimal = json['decimal'];
    if (json['occurrencesLabel'] != null) {
      occurrencesLabel = [];
      json['occurrencesLabel'].forEach((v) {
        occurrencesLabel.add(v);
      });
    }
    start = json['start'];
    len = json['len'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['note'] = this.note;
    data['zeroFill'] = this.zeroFill;
    data['decimalChar'] = this.decimalChar;
    data['itemType'] = this.itemType;
    data['dataType'] = this.dataType;
    data['occurrences'] = this.occurrences;
    data['decimal'] = this.decimal;
    if (this.occurrencesLabel != null) {
      data['occurrencesLabel'] = this.occurrencesLabel;
    }
    data['start'] = this.start;
    data['len'] = this.len;
    return data;
  }
}

class Records {
  String name;
  String label;
  String note;
  String recordTypeValue;
  bool required;
  int maxRecords;
  int recordLen;
  List<String> occurrencesLabel;
  List<Items> items;

  Records(
      {this.name,
      this.label,
      this.note,
      this.recordTypeValue,
      this.required,
      this.maxRecords,
      this.recordLen,
      this.occurrencesLabel,
      this.items});

  Records.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    note = json['note'];
    recordTypeValue = json['recordTypeValue'];
    required = json['required'];
    maxRecords = json['maxRecords'];
    recordLen = json['recordLen'];
    if (json['occurrencesLabel'] != null) {
      occurrencesLabel = [];
      json['occurrencesLabel'].forEach((v) {
        occurrencesLabel.add(v);
      });
    }
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['note'] = this.note;
    data['recordTypeValue'] = this.recordTypeValue;
    data['required'] = this.required;
    data['maxRecords'] = this.maxRecords;
    data['recordLen'] = this.recordLen;
    if (this.occurrencesLabel != null) {
      data['occurrencesLabel'] = this.occurrencesLabel;
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
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
  List<String> occurrencesLabel;
  int start;
  int len;
  ValueSet valueSet;

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
    name = json['name'];
    label = json['label'];
    note = json['note'];
    zeroFill = json['zeroFill'];
    decimalChar = json['decimalChar'];
    itemType = json['itemType'];
    dataType = json['dataType'];
    occurrences = json['occurrences'];
    decimal = json['decimal'];
    if (json['occurrencesLabel'] != null) {
      occurrencesLabel = [];
      json['occurrencesLabel'].forEach((v) {
        occurrencesLabel.add(v);
      });
    }
    start = json['start'];
    len = json['len'];
    valueSet = json['valueSet'] != null
        ? new ValueSet.fromJson(json['valueSet'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['note'] = this.note;
    data['zeroFill'] = this.zeroFill;
    data['decimalChar'] = this.decimalChar;
    data['itemType'] = this.itemType;
    data['dataType'] = this.dataType;
    data['occurrences'] = this.occurrences;
    data['decimal'] = this.decimal;
    if (this.occurrencesLabel != null) {
      data['occurrencesLabel'] = this.occurrencesLabel;
    }
    data['start'] = this.start;
    data['len'] = this.len;
    if (this.valueSet != null) {
      data['valueSet'] = this.valueSet.toJson();
    }
    return data;
  }
}

class ValueSet {
  String label;
  String name;
  List<Values> values;

  ValueSet({this.label, this.name, this.values});

  ValueSet.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    name = json['name'];
    if (json['values'] != null) {
      values = [];
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['name'] = this.name;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  String key;
  String value;

  Values({this.key, this.value});

  Values.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
