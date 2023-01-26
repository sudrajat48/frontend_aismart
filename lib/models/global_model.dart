class GlobalModel {
  final String? status;
  final String? timestamp;
  final dynamic errorMessage;
  final dynamic result;

  GlobalModel({this.status, this.timestamp, this.errorMessage, this.result});

  factory GlobalModel.fromJson(Map<String, dynamic> json) {
    return GlobalModel(
      status: json['status'],
      timestamp: json['timestamp'],
      errorMessage: json['error_message'],
      result: json['result'],
    );
  }
}
