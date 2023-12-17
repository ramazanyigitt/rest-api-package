import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rest_api_package/rest_api_package.dart';

import 'models/cat_fact_model.dart';

void main() async {
  final restApiHttpService = RestApiHttpService(
    Dio(),
    'https://cat-fact.herokuapp.com/',
  );

  final catFactsRequest = RestApiRequest(
    endPoint: 'facts',
    requestMethod: RequestMethod.GET,
    useNewDioInstance: true,
  );

  final catFactList = await restApiHttpService.requestAndHandleList(
    catFactsRequest,
    parseModel: CatFact.fromJson,
  );

  log('Result: $catFactList');
}
