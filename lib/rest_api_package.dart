library rest_api_package;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

part 'models/base_model.dart';
part 'requests/file_rest_api_request.dart';
part 'requests/rest_api_request.dart';
part 'services/rest_api_http_service.dart';
