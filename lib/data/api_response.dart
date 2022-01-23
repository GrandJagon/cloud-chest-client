enum ResponseStatus { LOADING, DONE, ERROR }

class ApiResponse<T> {
  ResponseStatus? status;
  T? data;
  String? message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading() : status = ResponseStatus.LOADING;

  ApiResponse.done(this.data) : status = ResponseStatus.DONE;

  ApiResponse.error(this.message) : status = ResponseStatus.DONE;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
