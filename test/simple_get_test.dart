import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rest_api_package/rest_api_package.dart';

import '../example/models/cat_fact_model.dart';

void main() {
  test('Getting cat fact', () async {
    final restApiHttpService = RestApiHttpService(
      Dio(),
      'https://cat-fact.herokuapp.com/',
    );

    final catFactsRequest = RestApiRequest(
      endPoint: 'facts',
      requestMethod: RequestMethod.GET,
      useNewDioInstance: true,
    );

    final request = await restApiHttpService.request(catFactsRequest);

    expect(request.statusCode, 200);
  });

  test('Getting cat fact and handle', () async {
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

    expect(List<CatFact>, catFactList.runtimeType);
    expect(true, catFactList.isNotEmpty);
  });
}
