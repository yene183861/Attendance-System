from rest_framework import status
from rest_framework.views import exception_handler
import logging

from apps.common.error_code import ErrorCode
from apps.common.exception import CustomException

def custom_exception_handler(exc, context):
    print('exception handler')
    response = exception_handler(exc, context)
    logger = logging.getLogger(str(context['view']))
    exception_class = exc.__class__.__name__
    status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    print('exception_class:  {}'.format(exception_class))
    try:
        print(response)
    
        if response:
            if exception_class == 'ParseError':
                error = CustomException(ErrorCode.error_json_parser)
            elif exception_class == 'ValidationError':
                try:
                    list_errors = list(exc.detail.items())
                    data_error = ''
                    for error in list_errors:
                        error_code = error[1][0].code
                        print(error_code)
                        if error_code == 'invalid':
                            data_error = error[1][0]
                            break
                        elif error_code == 'null':
                            data_error = '{} must be not null'.format(error[0])
                            break
                        elif error_code == 'required':
                            data_error = '{} is required'.format(error[0])
                            break
                        elif error_code == 'blank':
                            data_error = '{} must be not blank.'.format(error[0])
                            break
                        elif error_code == 'does_not_exist':
                            data_error = '{} does not exist'.format(error[0])
                            error = CustomException(ErrorCode.not_found_record, custom_message=data_error)
                            return error.make_response(status_code)
                        elif error_code == 'invalid_choice':
                            data_error = '{} is invalid choice'.format(error[0])
                            error = CustomException(ErrorCode.not_found_record, custom_message=data_error)
                            return error.make_response(status_code)
                        else:
                            data_error = ''.format(error[1][0].message)
                            break
                    custom_message = data_error
                except:
                    # Set a generic error message
                    custom_message = '{}'.format(list(exc.detail.items())[0][1][0])
                error = CustomException(ErrorCode.error_json_parser, custom_message=custom_message)
            elif exception_class == "CustomException":
                print('go herrre')
                print(exc.detail)
                error = exc
            elif exception_class == "AuthenticationFailed":
                error = CustomException(ErrorCode.invalid_auth)
            elif exception_class == "NotAuthenticated":
                error = CustomException(ErrorCode.error_not_auth)
            elif exception_class == "Http404":
                error = CustomException(ErrorCode.not_found_record)
            else:
                error = CustomException(ErrorCode.error_json_parser, custom_message=exc.detail)
            try:
                status_code = exc.status_code
            except Exception:
                status_code = status.HTTP_400_BAD_REQUEST
            logger.error(exc)
        else:
            logger.critical(exc)
            print(exc.args)
            if len(exc.args) > 1:
                custom_message = exc.args[1]
                print('Exception 1: {}'.format(exc.args))
                print('Exception 1: {}'.format(custom_message))
            elif len(exc.args) > 0:
                custom_message = exc.args[0]
                print('Exception 2: {}'.format(custom_message))
            else:
                custom_message = None
                print('ffffffff')
            error = CustomException(ErrorCode.unknown_error, custom_message=custom_message)
    except:
        error = CustomException(ErrorCode.unknown_error)
    return error.make_response(status_code)

