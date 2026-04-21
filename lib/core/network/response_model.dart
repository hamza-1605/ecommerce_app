class ApiResponse<T> {
  final String message;
  final bool success;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.message,
    required this.success,
    this.data,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success(T data, {String? message}){
    return ApiResponse<T>(
      success: true,
      message: message ?? "Successful", 
      data: data,
      statusCode: 200,
    );
  }

  factory ApiResponse.failure({String? message, int? statusCode, Map<String, dynamic>? errors}){
    return ApiResponse<T>(
      success: false,
      message: message ?? "Failed", 
      statusCode: statusCode,
      errors: errors,
    );
  }
}