part of '../rest_api_package.dart';

enum FileMediaType {
  image('image'),
  application('application');

  final String value;
  const FileMediaType(this.value);
}

class IFileUploadObject {
  String fileFieldName = 'file';
  File? file;
  Uint8List? fileBytes;
  String? fileName;
  FileMediaType fileMediaType;

  IFileUploadObject.create({
    required this.fileFieldName,
    required this.fileMediaType,
    this.file,
    this.fileBytes,
    this.fileName,
  });
}

class IRestApiFileRequest extends IRestApiRequest {
  List<IFileUploadObject> fileUploadObjects = [];
  Function(int, int)? onSendProgress;
}
