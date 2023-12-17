part of '../rest_api_package.dart';

abstract class IRestApiBaseModel {
  fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

abstract class IRestApiExtendedBaseModel extends IRestApiBaseModel {
  fromRawJson(String str);

  String toRawJson();
}

abstract class IRestApiBaseWrapperModel extends IRestApiBaseModel {
  IRestApiBaseWrapperModel({
    this.data,
    this.isError,
    this.message,
  });
  dynamic data;
  bool? isError;
  String? message;
}

abstract class IRestApiFreezedBaseModel {
  fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
