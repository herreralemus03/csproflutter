class Household {
  String xfname;
  String xlname;
  String xlisted;
  String xaddress;
  String xhousehold;
  String xsubsample;
  String xdwelling;
  String xstructure;
  String xname;

  Household(
      {this.xfname,
      this.xlname,
      this.xlisted,
      this.xaddress,
      this.xhousehold,
      this.xsubsample,
      this.xdwelling,
      this.xstructure,
      this.xname});

  Household.fromJson(Map<String, dynamic> json) {
    if (json["XFNAME"] is String) this.xfname = json["XFNAME"];
    if (json["XLNAME"] is String) this.xlname = json["XLNAME"];
    if (json["XLISTED"] is String) this.xlisted = json["XLISTED"];
    if (json["XADDRESS"] is String) this.xaddress = json["XADDRESS"];
    if (json["XHOUSEHOLD"] is String) this.xhousehold = json["XHOUSEHOLD"];
    if (json["XSUBSAMPLE"] is String) this.xsubsample = json["XSUBSAMPLE"];
    if (json["XDWELLING"] is String) this.xdwelling = json["XDWELLING"];
    if (json["XSTRUCTURE"] is String) this.xstructure = json["XSTRUCTURE"];
    if (json["XNAME"] is String) this.xname = json["XNAME"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["XFNAME"] = this.xfname;
    data["XLNAME"] = this.xlname;
    data["XLISTED"] = this.xlisted;
    data["XADDRESS"] = this.xaddress;
    data["XHOUSEHOLD"] = this.xhousehold;
    data["XSUBSAMPLE"] = this.xsubsample;
    data["XDWELLING"] = this.xdwelling;
    data["XSTRUCTURE"] = this.xstructure;
    data["XNAME"] = this.xname;
    return data;
  }
}
