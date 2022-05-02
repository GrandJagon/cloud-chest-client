enum ResponseStatus {
  LOADING_FULL,
  LOADING_PARTIAL,
  DONE,
  ERROR,
  NO_RESULT,
  UNAUTHORIZED
}

class ApiResponse {
  ResponseStatus? status;
  String? message;

  ApiResponse(this.status, this.message);

  // Two loading states in order to differentiate between full screen rebuilding or just some elements
  ApiResponse.loadingFull() : status = ResponseStatus.LOADING_FULL;

  ApiResponse.loadingPartial() : status = ResponseStatus.LOADING_PARTIAL;

  ApiResponse.done() : status = ResponseStatus.DONE;

  ApiResponse.error(this.message) : status = ResponseStatus.ERROR;

  ApiResponse.noResult(this.message) : status = ResponseStatus.NO_RESULT;

  ApiResponse.unauthorized() : status = ResponseStatus.UNAUTHORIZED;

  @override
  String toString() {
    return "Status : $status \n Message : $message";
  }
}
