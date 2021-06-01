class HouseHoldsPageData {
  Map<String, HouseHold> content;
  Pageable pageable;
  bool last;
  int totalPages;
  int totalElements;
  int number;
  int size;
  Sort sort;
  bool first;
  int numberOfElements;
  bool empty;

  HouseHoldsPageData(
      {this.content,
      this.pageable,
      this.last,
      this.totalPages,
      this.totalElements,
      this.number,
      this.size,
      this.sort,
      this.first,
      this.numberOfElements,
      this.empty});

  HouseHoldsPageData.fromJson(Map<String, dynamic> json) {
    if (json["content"] is List)
      this.content = json["content"] == null
          ? []
          : Map.fromEntries((json["content"] as List)
              .map((e) => MapEntry(e["uuid"], HouseHold.fromJson(e))));
    if (json["pageable"] is Map)
      this.pageable =
          json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]);
    if (json["last"] is bool) this.last = json["last"];
    if (json["totalPages"] is int) this.totalPages = json["totalPages"];
    if (json["totalElements"] is int)
      this.totalElements = json["totalElements"];
    if (json["number"] is int) this.number = json["number"];
    if (json["size"] is int) this.size = json["size"];
    if (json["sort"] is Map)
      this.sort = json["sort"] == null ? null : Sort.fromJson(json["sort"]);
    if (json["first"] is bool) this.first = json["first"];
    if (json["numberOfElements"] is int)
      this.numberOfElements = json["numberOfElements"];
    if (json["empty"] is bool) this.empty = json["empty"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null)
      data["content"] = this.content.values.map((e) => e.toJson()).toList();
    if (this.pageable != null) data["pageable"] = this.pageable.toJson();
    data["last"] = this.last;
    data["totalPages"] = this.totalPages;
    data["totalElements"] = this.totalElements;
    data["number"] = this.number;
    data["size"] = this.size;
    if (this.sort != null) data["sort"] = this.sort.toJson();
    data["first"] = this.first;
    data["numberOfElements"] = this.numberOfElements;
    data["empty"] = this.empty;
    return data;
  }
}

class ClustersPageData {
  Map<String, Cluster> content;
  Pageable pageable;
  bool last;
  int totalPages;
  int totalElements;
  int number;
  int size;
  Sort sort;
  bool first;
  int numberOfElements;
  bool empty;

  ClustersPageData(
      {this.content,
      this.pageable,
      this.last,
      this.totalPages,
      this.totalElements,
      this.number,
      this.size,
      this.sort,
      this.first,
      this.numberOfElements,
      this.empty});

  ClustersPageData.fromJson(Map<String, dynamic> json) {
    if (json["content"] is List)
      this.content = json["content"] == null
          ? []
          : Map.fromEntries((json["content"] as List)
              .map((e) => MapEntry(e["uuid"], Cluster.fromJson(e))));
    if (json["pageable"] is Map)
      this.pageable =
          json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]);
    if (json["last"] is bool) this.last = json["last"];
    if (json["totalPages"] is int) this.totalPages = json["totalPages"];
    if (json["totalElements"] is int)
      this.totalElements = json["totalElements"];
    if (json["number"] is int) this.number = json["number"];
    if (json["size"] is int) this.size = json["size"];
    if (json["sort"] is Map)
      this.sort = json["sort"] == null ? null : Sort.fromJson(json["sort"]);
    if (json["first"] is bool) this.first = json["first"];
    if (json["numberOfElements"] is int)
      this.numberOfElements = json["numberOfElements"];
    if (json["empty"] is bool) this.empty = json["empty"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null)
      data["content"] = this.content.values.map((e) => e.toJson()).toList();
    if (this.pageable != null) data["pageable"] = this.pageable.toJson();
    data["last"] = this.last;
    data["totalPages"] = this.totalPages;
    data["totalElements"] = this.totalElements;
    data["number"] = this.number;
    data["size"] = this.size;
    if (this.sort != null) data["sort"] = this.sort.toJson();
    data["first"] = this.first;
    data["numberOfElements"] = this.numberOfElements;
    data["empty"] = this.empty;
    return data;
  }
}

class Pageable {
  Sort sort;
  int offset;
  int pageSize;
  int pageNumber;
  bool paged;
  bool unpaged;

  Pageable(
      {this.sort,
      this.offset,
      this.pageSize,
      this.pageNumber,
      this.paged,
      this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    if (json["sort"] is Map)
      this.sort = json["sort"] == null ? null : Sort.fromJson(json["sort"]);
    if (json["offset"] is int) this.offset = json["offset"];
    if (json["pageSize"] is int) this.pageSize = json["pageSize"];
    if (json["pageNumber"] is int) this.pageNumber = json["pageNumber"];
    if (json["paged"] is bool) this.paged = json["paged"];
    if (json["unpaged"] is bool) this.unpaged = json["unpaged"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) data["sort"] = this.sort.toJson();
    data["offset"] = this.offset;
    data["pageSize"] = this.pageSize;
    data["pageNumber"] = this.pageNumber;
    data["paged"] = this.paged;
    data["unpaged"] = this.unpaged;
    return data;
  }
}

class Sort {
  bool sorted;
  bool unsorted;
  bool empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    if (json["sorted"] is bool) this.sorted = json["sorted"];
    if (json["unsorted"] is bool) this.unsorted = json["unsorted"];
    if (json["empty"] is bool) this.empty = json["empty"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sorted"] = this.sorted;
    data["unsorted"] = this.unsorted;
    data["empty"] = this.empty;
    return data;
  }
}

class HouseHold {
  String uuid;
  String code;
  int houseHoldNumber;
  int listedHouseHoldNumber;
  int structureNumber;
  int dwellingNumber;
  String address;
  String householdHeadName;
  String householdHeadFirstName;
  String householdHeadLastName;
  List<SubSample> subSample;
  Cluster cluster;

  HouseHold(
      {this.uuid,
      this.code,
      this.houseHoldNumber,
      this.listedHouseHoldNumber,
      this.structureNumber,
      this.dwellingNumber,
      this.address,
      this.householdHeadName,
      this.householdHeadFirstName,
      this.householdHeadLastName,
      this.subSample,
      this.cluster});

  HouseHold.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["code"] is String) this.code = json["code"];
    if (json["houseHoldNumber"] is int)
      this.houseHoldNumber = json["houseHoldNumber"];
    if (json["listedHouseHoldNumber"] is int)
      this.listedHouseHoldNumber = json["listedHouseHoldNumber"];
    if (json["structureNumber"] is int)
      this.structureNumber = json["structureNumber"];
    if (json["dwellingNumber"] is int)
      this.dwellingNumber = json["dwellingNumber"];
    if (json["address"] is String) this.address = json["address"];
    if (json["householdHeadName"] is String)
      this.householdHeadName = json["householdHeadName"];
    if (json["householdHeadFirstName"] is String)
      this.householdHeadFirstName = json["householdHeadFirstName"];
    if (json["householdHeadLastName"] is String)
      this.householdHeadLastName = json["householdHeadLastName"];
    if (json["subSample"] is List)
      this.subSample = json["subSample"] == null
          ? []
          : (json["subSample"] as List)
              .map((e) => SubSample.fromJson(e))
              .toList();
    if (json["cluster"] is Map)
      this.cluster =
          json["cluster"] == null ? null : Cluster.fromJson(json["cluster"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["code"] = this.code;
    data["houseHoldNumber"] = this.houseHoldNumber;
    data["listedHouseHoldNumber"] = this.listedHouseHoldNumber;
    data["structureNumber"] = this.structureNumber;
    data["dwellingNumber"] = this.dwellingNumber;
    data["address"] = this.address;
    data["householdHeadName"] = this.householdHeadName;
    data["householdHeadFirstName"] = this.householdHeadFirstName;
    data["householdHeadLastName"] = this.householdHeadLastName;
    if (this.subSample != null)
      data["subSample"] = this.subSample.map((e) => e.toJson()).toList();
    if (this.cluster != null) data["cluster"] = this.cluster.toJson();
    return data;
  }
}

class Cluster {
  String uuid;
  int code;
  Province province;
  Region region;
  District district;
  Commune commune;
  Area area;

  Cluster(
      {this.uuid,
      this.code,
      this.province,
      this.region,
      this.district,
      this.commune,
      this.area});

  Cluster.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["code"] is int) this.code = json["code"];
    if (json["province"] is Map)
      this.province =
          json["province"] == null ? null : Province.fromJson(json["province"]);
    if (json["region"] is Map)
      this.region =
          json["region"] == null ? null : Region.fromJson(json["region"]);
    if (json["district"] is Map)
      this.district =
          json["district"] == null ? null : District.fromJson(json["district"]);
    if (json["commune"] is Map)
      this.commune =
          json["commune"] == null ? null : Commune.fromJson(json["commune"]);
    if (json["area"] is Map)
      this.area = json["area"] == null ? null : Area.fromJson(json["area"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["code"] = this.code;
    if (this.province != null) data["province"] = this.province.toJson();
    if (this.region != null) data["region"] = this.region.toJson();
    if (this.district != null) data["district"] = this.district.toJson();
    if (this.commune != null) data["commune"] = this.commune.toJson();
    if (this.area != null) data["area"] = this.area.toJson();
    return data;
  }
}

class Area {
  String uuid;
  int code;
  String name;

  Area({this.uuid, this.code, this.name});

  Area.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["code"] is int) this.code = json["code"];
    if (json["name"] is String) this.name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["code"] = this.code;
    data["name"] = this.name;
    return data;
  }
}

class Commune {
  String uuid;
  int code;
  String name;

  Commune({this.uuid, this.code, this.name});

  Commune.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["code"] is int) this.code = json["code"];
    if (json["name"] is String) this.name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["code"] = this.code;
    data["name"] = this.name;
    return data;
  }
}

class District {
  String uuid;
  int code;
  String name;

  District({this.uuid, this.code, this.name});

  District.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["code"] is int) this.code = json["code"];
    if (json["name"] is String) this.name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["code"] = this.code;
    data["name"] = this.name;
    return data;
  }
}

class Region {
  String uuid;
  String name;
  int code;

  Region({this.uuid, this.name, this.code});

  Region.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["name"] is String) this.name = json["name"];
    if (json["code"] is int) this.code = json["code"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["name"] = this.name;
    data["code"] = this.code;
    return data;
  }
}

class Province {
  String uuid;
  int code;
  String name;

  Province({this.uuid, this.code, this.name});

  Province.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["code"] is int) this.code = json["code"];
    if (json["name"] is String) this.name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["code"] = this.code;
    data["name"] = this.name;
    return data;
  }
}

class SubSample {
  String uuid;
  String code;
  String val;

  SubSample({this.uuid, this.code, this.val});

  SubSample.fromJson(Map<String, dynamic> json) {
    if (json["uuid"] is String) this.uuid = json["uuid"];
    if (json["code"] is String) this.code = json["code"];
    if (json["val"] is String) this.val = json["val"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uuid"] = this.uuid;
    data["code"] = this.code;
    data["val"] = this.val;
    return data;
  }
}
