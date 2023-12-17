import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rest_api_package/rest_api_package.dart';

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
}
