/// DTO representing the result of a file upload.
class FileUploadResult {
  final String url;
  final String fileName;

  const FileUploadResult({
    required this.url,
    required this.fileName,
  });

  factory FileUploadResult.fromMap(Map<String, String> map) {
    return FileUploadResult(
      url: map['url']!,
      fileName: map['fileName']!,
    );
  }

  Map<String, String> toMap() {
    return {
      'url': url,
      'fileName': fileName,
    };
  }
}
