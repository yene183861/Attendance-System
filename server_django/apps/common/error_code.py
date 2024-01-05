class Error:
    code = 'code'
    message = 'message'


class ErrorCode:
    not_error = {
        Error.code: 0,
        Error.message: 'Successful'
    }

    error_server = {
        Error.code: 1,
        Error.message: "An error has occurred, please try again or contact technical for troubleshooting!"
    }

    unknown_error = {
        Error.code: 2,
        Error.message: 'Unknown Error'
    }

    wrong_format_email = {
        Error.code: 3,
        Error.message: 'Wrong email format',
    }

    account_has_exist = {
        Error.code: 4,
        Error.message: 'The account already exists on the system.'
    }

    not_found_record = {
        Error.code: 5,
        Error.message: 'Not found record.'
    }

    error_not_auth = {
        Error.code: 6,
        Error.message: "Need login to using this function."
    }

    invalid_auth = {
        Error.code: 7,
        Error.message: "Invalid auth."
    }

    birthday_invalid_format = {
        Error.code: 8,
        Error.message: "Birthday invalid format.",
    }

    birthday_invalid_date = {
        Error.code: 9,
        Error.message: "Birthday error.",
    }

    email_or_password_invalid = {
        Error.code: 10,
        Error.message: 'Email or password invalid.'
    }

    error_json_parser = {
        Error.code: 11,
        Error.message: "Can't parse data please check data."
    }

    error_password_not_match = {
        Error.code: 12,
        Error.message: "Your passwords didn't match."
    }

    error_current_password_incorrect = {
        Error.code: 13,
        Error.message: "Your current password is incorrect."
    }

    error_short_password = {
        Error.code: 14,
        Error.message: "Password must be at least 8 characters."
    }

    error_empty_password = {
        Error.code: 15,
        Error.message: "Password must be not empty."
    }

    error_no_permission_to_create_user = {
        Error.code: 16,
        Error.message: "No permission to create higher level users"
    }

    error_not_permisstion = {
        Error.code: 17,
        Error.message: 'You have not permission to perform this action'
    }

    error_format_time = {
        Error.code: 18,
        Error.message: 'Time has wrong format. Use one of these formats instead: hh:mm[:ss[.uuuuuu]]'
    }
    error_unable_action = {
        Error.code: 19,
        Error.message: 'Unable to take action'
    }
    error_client = {
        Error.code: 20,
        Error.message: 'Error request'
    }

    account_not_exist = {
        Error.code: 21,
        Error.message: 'Không có tài khoản nào liên kết với email này.'
    }


