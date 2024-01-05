from enum import Enum


class EnumMeta(Enum):
    def __new__(cls, value, label):
        obj = object.__new__(cls)
        obj._value_ = value
        obj.label = label
        return obj

    @classmethod
    def choices(cls):
        return [(key.value, key.label) for key in cls]


class UserType(EnumMeta):
    ADMIN = (0, 'admin')
    CEO = (1, 'ceo')
    DIRECTOR = (2, 'director')
    MANAGER = (3, 'manager')
    LEADER = (4, 'leader')
    STAFF = (5, 'staff')


class GenderType(EnumMeta):
    MALE = (0, 'Male')
    FEMALE = (1, 'Female')


class MaritalStatus(EnumMeta):
    SINGLE = (0, 'Single')
    MARRIED = (1, 'Married')
    DIVORCED = (2, 'Divorced')


class EducationLevel(EnumMeta):
    HIGH_SCHOOL = (0, 'High School')
    COLLEGE = (1, 'College')
    UNIVERSITY = (2, 'University')


class MilitaryServiceStatus(EnumMeta):
    NOT_GO = (0, 'No go')
    NOT_PARTICIPATE = (1, 'Not participate')
    PARTICIPATING = (2, 'Participating')
    JOINDED = (3, 'Joined')


class WorkStatus(EnumMeta):
    POSTPONING_WORK = (0, 'Postponing work')
    WORKING = (1, 'Working')
    LEAVED = (2, 'Leaved')


class TicketStatus(EnumMeta):
    PENDING = (0, 'Pending')
    APPROVED = (1, 'Approved')
    REFUSED = (2, 'Refused')


class TicketType(EnumMeta):
    APPLICATION_FOR_THOUGHT = (0, 'Application for thought')
    ABSENCE_APPLICATION = (1, 'Absence application')
    APPLICATION_FOR_OVERTIME = (2, 'Application for overtime')
    CHECK_IN_OUT_FORM = (3, 'Check-in/out form')


class AvatarDefault:
    avatar_default = [
        'avatars/avatar_default/default_avatar_1.jpg',
        'avatars/avatar_default/default_avatar_2.jpg',
        'avatars/avatar_default/default_avatar_3.jpg',
        'avatars/avatar_default/default_avatar_4.jpg',
        'avatars/avatar_default/default_avatar_5.jpg',
    ]


class ByTime(EnumMeta):
    MINUTE = (0, 'Minute')
    HOUR = (1, 'Hour')
    DAY = (2, 'Day')
    WEEK = (3, 'Week')
    MONTH = (4, 'Month')
    YEAR = (5, 'Year')
    ONE_TIME = (6, 'One time')


class WorkStatus(EnumMeta):
    POSTPONING_WORK = (0, 'Postponing work')
    WORKING = (1, 'Working')
    LEAVED = (2, 'Leaved')


class ContractStatus(EnumMeta):
    INVALID_CONTRACT = (0, 'Invalid contract')  # hop dong chưa co hieu luc
    VALID_CONTRACT = (1, 'Valid contract')  # hop dong dang co hieu luc
    EXPIRED_CONTRACT = (2, 'Expired contract')  # hop dong het han
    LIQUIDATION_CONTRACT = (3, 'Liquidation contract')  # hop dong da thanh ly


class ContractType(EnumMeta):
    SEASONAL_CONTRACT = (0, 'Seasonal contract')  # Hợp đồng thời vụ
    FIXED_TERM_LABOR_CONTRACT = (1, 'Fixed-term labor contract')  # hop dong lao động có kỳ hạn
    INDEFINITE_TERM_LABOR_CONTRACT = (2, 'Labor contract with indefinite term')  # Hợp đồng lao động không có kỳ hạn


class NotificationStatus(EnumMeta):
    UNREAD = (0, 'Unread')  # chưa đọc
    READ = (1, 'Read')  # đã đọc
    MAKE_AS_UNREAD = (2, 'Make as unread')  # đánh dấu là chưa đọc


class WorkType(EnumMeta):
    DAILY_WORK = (0, 1.0)  # công ngày thường
    OVERTIME_DAILY_WORK = (1, 1.5)  # công tăng ca ngày thường (ngày công ty cho nghỉ nhưng vẫn được duyệt tăng ca)
    WORK_DAY_OFF = (2, 2.0)  # công làm việc ngày cuối tuần
    OVERTIME_DAY_OFF = (3, 2.5)  # tăng ca ngày nghi
    WORK_HOLIDAY = (4, 3)  # lễ
    OVERTIME_HOLIDAY = (5, 3.5)  # tăng ca ngày lễ
