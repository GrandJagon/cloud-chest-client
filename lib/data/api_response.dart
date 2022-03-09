enum ResponseStatus { LOADING, DONE, ERROR, NO_RESULT }

class ApiResponse {
  ResponseStatus? status;
  String? message;

  ApiResponse(this.status, this.message);

  ApiResponse.loading() : status = ResponseStatus.LOADING;

  ApiResponse.done() : status = ResponseStatus.DONE;

  ApiResponse.error(this.message) : status = ResponseStatus.ERROR;

  ApiResponse.noResult(this.message) : status = ResponseStatus.NO_RESULT;

  @override
  String toString() {
    return "Status : $status \n Message : $message";
  }
}
