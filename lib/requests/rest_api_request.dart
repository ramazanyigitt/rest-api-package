// ignore_for_file: constant_identifier_names

part of '../rest_api_package.dart';

enum RequestMethod {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

abstract class IRestApiRequest {
  String baseUrl = '';
  String endPoint = "/";
  bool authorize = false;
  Map<String, dynamic> queryParameters = {};
  dynamic body = {};
  RequestMethod requestMethod = RequestMethod.GET;
  String? bearerToken;
  bool useNewDioInstance = false;

  //Future<void> handleRequest(Response response) async {}
}

class RestApiRequest extends IRestApiRequest {
  RestApiRequest({
    String endPoint = "/",
    String? bearerToken,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> queryParameters = const {},
    RequestMethod requestMethod = RequestMethod.GET,
    bool useNewDioInstance = false,
  }) {
    this.endPoint = endPoint;
    this.bearerToken = bearerToken;
    this.body = body;
    this.queryParameters = queryParameters;
    this.requestMethod = requestMethod;
    this.useNewDioInstance = useNewDioInstance;
  }
}
