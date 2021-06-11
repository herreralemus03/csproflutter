import 'package:boletas_app/models/household.dart';
import 'package:database/sql.dart';
import 'package:database_adapter_sqlite/database_adapter_sqlite.dart';
import 'package:flutter/material.dart';

enum SortDirection { ASC, DESC }

class DbHelper {
  static DbHelper _instance;
  static DbHelper get instance => _instance;
  final String _path;
  static SqlClient sqlClient;
  static bool _initialized = false;

  DbHelper.initialize(this._path) {
    if (_initialized) return;
    if (_instance == null) _instance = this;
    _initialized = true;
    _setupDB();
  }

  Future _setupDB() async {
    final config = SQLite(
      path: this._path,
    );
    sqlClient = config.database().sqlClient;
  }

  String buildPageable({String query, PageRequest pageRequest}) {
    String pageableQuery = query +
        (pageRequest.orders.isEmpty
            ? ""
            : " order by " +
                pageRequest.orders
                    .map((e) => " .${e.column} ${e.direction}")
                    .join(" , ")) +
        " limit ${pageRequest.offset},${pageRequest.limit}";
    return pageableQuery;
  }

  Future<List<Map<String, dynamic>>> getContent({
    @required String table,
    PageRequest pageRequest,
  }) async {
    final query = queryTable(table,
        pageRequest: pageRequest ??
            PageRequest(
              offset: 0,
            ));
    final rows = await query.toMaps();
    return rows;
  }

  Future<PageData> buildPage(String tableName, PageRequest pageRequest) async {
    final contentStats =
        "select *, count(*) as totalElements, (select count(*) from (select * from $tableName limit ${pageRequest.offset},${pageRequest.offset})) as numberOfElements";
    final queryStats = sqlClient.query(contentStats);
    final resultStats = await queryStats.toMaps();
    Map<String, dynamic> stats = resultStats.first;
    final totalElements = stats["totalElements"];
    final numberOfElements = stats["numberOfElements"];
    final totalPages = (totalElements / pageRequest.limit);
    final pageNumber = pageRequest.page;

    return PageData(
        numberOfElements: numberOfElements,
        size: numberOfElements,
        empty: numberOfElements == 0,
        totalPages: totalPages,
        pageable: Pageable(
          offset: pageRequest.offset,
          pageNumber: pageNumber,
          pageSize: pageRequest.size,
          paged: true,
          sort: Sort(
            empty: pageRequest.orders.isNotEmpty,
            sorted: pageRequest.orders.isNotEmpty,
            unsorted: pageRequest.orders.isEmpty,
          ),
          unpaged: false,
        ),
        first: pageRequest.page == 0,
        last: pageNumber >= totalPages,
        number: pageNumber,
        sort: Sort(
          empty: pageRequest.orders.isNotEmpty,
          sorted: pageRequest.orders.isNotEmpty,
          unsorted: pageRequest.orders.isEmpty,
        ),
        totalElements: totalElements,
        content: await getContent(table: tableName, pageRequest: pageRequest));
  }

  SqlClientTableQueryHelper queryTable(String table,
      {PageRequest pageRequest}) {
    final query = sqlClient.query(
      buildPageable(
        query: "select * from $table",
        pageRequest: pageRequest,
      ),
    );
    return query;
  }
}

class OrderBy {
  final String column;
  final String direction;

  OrderBy({
    @required this.column,
    SortDirection direction,
  }) : this.direction = direction == SortDirection.ASC ? "asc" : "desc";
}

class PageRequest {
  final int limit;
  final int offset;
  final List<OrderBy> orders;
  final int page;
  final int size;
  PageRequest({
    this.offset = 0,
    this.limit = 25,
    this.orders = const [],
  })  : this.page = offset ~/ limit,
        this.size = limit;
  PageRequest.page({
    this.page = 0,
    this.size = 25,
    this.orders = const [],
  })  : this.offset = page * size,
        this.limit = size;
}

class PageData {
  List<Map<String, dynamic>> content;
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

  PageData(
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

  PageData.fromJson(Map<String, dynamic> json) {
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
    if (this.content != null) data["content"] = this.content;
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
