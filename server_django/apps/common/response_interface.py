from apps.common.error_code import Error, ErrorCode

class Response:
    def __init__(self,data, error_code=ErrorCode.not_error, custom_message=None):
        self.error_code = error_code
        self.data = data
        self.custom_message = custom_message

    def generate_response(self):
        response = dict()
        response['error_code'] = self.error_code[Error.code]
        if self.custom_message:
            response['message'] = self.custom_message
        else:
            response['message'] = self.error_code[Error.message]
        response["data"] = self.data
        return response