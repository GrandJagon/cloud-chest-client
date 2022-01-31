enum ResponseStatus { LOADING, DONE, ERROR }

class ApiResponse {
  ResponseStatus? status;
  String? message;

  ApiResponse(this.status, this.message);

  ApiResponse.loading() : status = ResponseStatus.LOADING;

  ApiResponse.done() : status = ResponseStatus.DONE;

  ApiResponse.error(this.message) : status = ResponseStatus.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message";
  }
}
