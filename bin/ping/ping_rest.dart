import 'dart:convert';

import '../dart_rest/dart_rest_service.dart';

class PingRest extends DartRestService<Map<String, dynamic>>{
  PingRest() : super('ping', customService: true) {
    enablePagination = true;
  
    

    // get all
    beforeGetAll = (ctx) async {};
    afterGetAll = (ctx) async {
      ctx.result ={
        "status" :202,
        "pesan": " get all"
      };
      return ctx.result;
    };

    // get by id
    beforeGetOne = (ctx) async {};
    afterGetOne = (ctx) async {};

    // post
    beforeCreate = (ctx) async {};
    afterCreate = (data, ctx) async {
    
      ctx.result = {
        "Status":202,
        "Massage":"hallo !!"
      };
      return ctx.result;
    };

    // patch/id or put/id
    beforeUpdate = (ctx) async {};
    afterUpdate = (data, ctx) async {
      return ctx.result;
    };

    // delete/id
    beforeDelete = (ctx) async {};
    afterDelete = (ctx) async {};
  }


  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return Map<String, dynamic>.from(json);
  }

  @override
  Map<String, dynamic> toJson(item) {
    return Map<String, dynamic>.from(item);
  }
}
