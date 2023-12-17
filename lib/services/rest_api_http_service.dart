part of '../rest_api_package.dart';

class RestApiHttpService {
  Map<String, String> publicHeaders = <String, String>{};
  Dio dio;
  dynamic cookieJar;

  ///! Make sure base url ends with /
  ///So you can call your API like in the examples.
  final String baseUrl;

  ///! Make sure base url ends with /
  ///So you can call your API like in the examples.
  RestApiHttpService(
    this.dio,
    this.baseUrl,
  ) {
    //log('Cookie interceptor adding');
    //log('Cookie interceptor added');
  }

  RestApiHttpService.withCookie(
    this.dio,
    this.baseUrl,
    this.cookieJar,
  ) {
    if (!kIsWeb) dio.interceptors.add(CookieManager(cookieJar));
  }

  void setPublicHeader(String key, String value) {
    publicHeaders[key] = value;
  }

  void removePublicHeader(String key) {
    publicHeaders.remove(key);
  }

  Future<Options> prepareOptions(IRestApiRequest request) async {
    final Map<String, String> headers = <String, String>{};
    headers.addAll(publicHeaders);
    headers.putIfAbsent(
        HttpHeaders.contentTypeHeader, () => 'application/json');
    //headers.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/json');

    if (request.bearerToken != null) {
      headers.putIfAbsent(HttpHeaders.authorizationHeader,
          () => 'Bearer ${request.bearerToken}');
    }
    return Options(
        headers: headers,
        followRedirects: false,
        method: request.requestMethod.name,
        validateStatus: (status) {
          return (status ?? 501) <= 500;
        });
  }

  Future<T> requestAndHandle<T>(
    IRestApiRequest apiRequest, {
    bool removeBaseUrl = false,
    required T Function(Map<String, dynamic> json) parseModel,
    bool isRawJson = false,
  }) async {
    Response response = await request(apiRequest, removeBaseUrl: removeBaseUrl);
    return handleResponse<T>(response,
        parseModel: parseModel, isRawJson: isRawJson);
  }

  Future<List<T>> requestAndHandleList<T>(
    IRestApiRequest apiRequest, {
    bool removeBaseUrl = false,
    required T Function(Map<String, dynamic> json) parseModel,
    bool isRawJson = false,
  }) async {
    Response response = await request(apiRequest, removeBaseUrl: removeBaseUrl);
    return handleResponseList<T>(
      response,
      parseModel: parseModel,
      isRawJson: isRawJson,
    );
  }

  Future<Response> _baseRequest(IRestApiRequest apiRequest,
      {bool removeBaseUrl = false, dynamic data}) async {
    final dio = apiRequest.useNewDioInstance ? Dio() : this.dio;
    Response resp;

    String url = baseUrl + apiRequest.endPoint;

    if (apiRequest.baseUrl.isNotEmpty) {
      url = apiRequest.baseUrl + apiRequest.endPoint;
    }

    Options options = await prepareOptions(apiRequest);

    try {
      resp = await dio.request(
        url,
        options: options,
        data: data ?? (apiRequest.body.isEmpty ? null : apiRequest.body),
        queryParameters: apiRequest.queryParameters,
        onSendProgress: (apiRequest is IRestApiFileRequest)
            ? apiRequest.onSendProgress
            : null,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
    return resp;
  }

  Future<Response> request(IRestApiRequest apiRequest,
      {bool removeBaseUrl = false}) async {
    return _baseRequest(apiRequest, removeBaseUrl: removeBaseUrl);
  }

  Future<T> requestFormAndHandle<T>(
    IRestApiRequest apiRequest, {
    required dynamic parseModel,
    bool isRawJson = false,
  }) async {
    Response response = await requestForm(apiRequest);
    return handleResponse<T>(response,
        parseModel: parseModel, isRawJson: isRawJson);
  }

  Future<List<T>> requestFormAndHandleList<T>(
    IRestApiRequest apiRequest, {
    required dynamic parseModel,
    bool isRawJson = false,
  }) async {
    Response response = await requestForm(apiRequest);
    return handleResponseList<T>(response,
        parseModel: parseModel, isRawJson: isRawJson);
  }

  Future<Response> requestForm(
    IRestApiRequest apiRequest,
  ) async {
    var formData = FormData();

    apiRequest.body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    return _baseRequest(apiRequest, data: formData);
  }

  Future<Response> requestFile(
    IRestApiFileRequest apiRequest,
  ) async {
    assert(apiRequest.fileUploadObjects.isNotEmpty,
        'File upload objects can not be empty');

    var formData = FormData();

    for (var fileUploadObject in apiRequest.fileUploadObjects) {
      var mfile = MultipartFile.fromBytes(
        fileUploadObject.file != null
            ? fileUploadObject.file!.readAsBytesSync()
            : fileUploadObject.fileBytes!,
        filename: fileUploadObject.fileName,
        contentType: MediaType(
          fileUploadObject.fileMediaType.value,
          fileUploadObject.file!.path.split('.').last,
        ),
      );
      formData.files.add(MapEntry(fileUploadObject.fileFieldName, mfile));
    }

    apiRequest.body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    return _baseRequest(apiRequest, data: formData);
  }

  T handleResponse<T>(Response response,
      {required T Function(Map<String, dynamic> json) parseModel,
      required bool isRawJson}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = response.data;
        T result;
        if (isRawJson) {
          result = parseModel(json.decode(data));
        } else {
          result = parseModel(data);
        }
        return result;
      } catch (e) {
        rethrow;
      }
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: response.statusCode,
      );
    }
  }

  List<T> handleResponseList<T>(Response response,
      {required T Function(Map<String, dynamic> json) parseModel,
      required bool isRawJson}) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final data = response.data;
        //log('Response data: $data');
        if (isRawJson) {
          final list = json.decode(data) as List;
          return List<T>.from(list.map((x) => parseModel(x)));
        }
        return List<T>.from(data.map((x) => parseModel(x)));
      } catch (e) {
        rethrow;
      }
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: response.statusCode,
      );
    }
  }
}
