import os
import datetime
from decouple import Config, RepositoryEnv
from django.urls import reverse_lazy

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
env = os.environ.get('ENVIRONMENT')
project_environment = env if env else 'development'
ENV_FILE = os.path.join(BASE_DIR, '.env/.{}'.format(project_environment))
env_config = Config(RepositoryEnv(ENV_FILE))

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = env_config.get('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = env_config.get('DEBUG') == "True"

ALLOWED_HOSTS = ["*"]
APPEND_SLASH = False

# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    'rest_framework',
    'drf_yasg',
    'django_crontab',
    'django_celery_results',
    # 'django_filters',

    'apps.allowance',
    'apps.attendance',
    'apps.authentication',
    'apps.branch_office',
    'apps.common',
    'apps.contract',
    'apps.department',
    'apps.notification',
    'apps.organization',
    'apps.personnel_evaluation',
    'apps.register_face',
    'apps.reward_and_discipline',
    'apps.salary',
    'apps.team',
    'apps.ticket',
    'apps.ticket_type',
    'apps.user',
    'apps.user_work',
    'apps.search',
    'apps.working_time_setting'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'firefly_server.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'firefly_server.wsgi.application'

AUTH_USER_MODEL = 'user.User'


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases
if env_config.get('DATABASES_NAME', 'None').lower() == 'postgres':
    DATABASES = {
        "default": {
            "ENGINE": env_config("POSTGRES_ENGINE", "django.db.backends.sqlite3"),
            "NAME": env_config("POSTGRES_DB", os.path.join(BASE_DIR, "db.sqlite3")),
            "USER": env_config("POSTGRES_USER", "admin"),
            "PASSWORD": env_config("POSTGRES_PASSWORD", "admin"),
            "HOST": env_config("POSTGRES_HOST", "localhost"),
            "PORT": env_config("POSTGRES_PORT", "5432"),
        }
    }
elif env_config('DATABASES_NAME', 'None').lower() == 'mysql':
    DATABASES = {
        'default': {
            'ENGINE': env_config("MY_SQL_ENGINE", "django.db.backends.sqlite3"),
            'NAME': env_config("MYSQL_DATABASE", "office_db"),
            'USER': env_config("MYSQL_USER", "root"),
            'PASSWORD': env_config("MYSQL_PASSWORD", ""),
            'HOST': env_config("MY_SQL_HOST", "127.0.0.1"),
            'PORT': env_config("MYSQL_PORT", "3306"),
        }
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': 'db.sqlite3',
        }
    }



# Password validation
# https://docs.djangoproject.com/en/3.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'apps.authentication.custom_auth.CustomAuthentication',
    ),
    # 'DEFAULT_FILTER_BACKENDS': ['django_filters.rest_framework.DjangoFilterBackend'],
    'EXCEPTION_HANDLER': 'apps.common.custom_exception_handler.custom_exception_handler',
    'DEFAULT_RENDERER_CLASSES': (
        'rest_framework.renderers.JSONRenderer',
        'apps.common.display_edit_forms.BrowsableAPIRendererWithoutForms',
    ),
}

# Queue config ( Redis - rabbitmq )
CELERY_BROKER_URL = env_config('CELERY_BROKER_URL')
CELERY_RESULT_BACKEND = CELERY_BROKER_URL
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'

# Internationalization
# https://docs.djangoproject.com/en/3.2/topics/i18n/

LANGUAGE_CODE = env_config('LANGUAGE_CODE')

TIME_ZONE = env_config('TIME_ZONE')

USE_I18N = True

USE_TZ = False

JWT_AUTH = {
    'JWT_EXPIRATION_DELTA': datetime.timedelta(minutes=1440),
    'JWT_ALLOW_REFRESH': True,
    'JWT_REFRESH_EXPIRATION_DELTA': datetime.timedelta(minutes=1440),
    'JWT_VERIFY_EXPIRATION': True,
    'JWT_AUTH_COOKIE': 'jwt_auth_token'
}

SWAGGER_SETTINGS = {
    'LOGIN_URL': reverse_lazy('admin:login'),
    'LOGOUT_URL': '/admin/logout',
    'PERSIST_AUTH': True,
    'REFETCH_SCHEMA_WITH_AUTH': True,
    'REFETCH_SCHEMA_ON_LOGOUT': True,
    'DEFAULT_INFO': 'office_server.urls.swagger.swagger_info',

    'SECURITY_DEFINITIONS': {
        'JWT': {
            'type': 'apiKey',
            'name': 'Authorization',
            'in': 'header'
        }
    },
    'DOC_EXPANSION': 'none',

}

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, "static")

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

EMAIL_HOST_USER = env_config('EMAIL_HOST_USER')
EMAIL_HOST = env_config('EMAIL_HOST')
EMAIL_BACKEND = env_config('EMAIL_BACKEND')
EMAIL_PORT = env_config('EMAIL_PORT')
EMAIL_HOST_PASSWORD = env_config('EMAIL_HOST_PASSWORD')
EMAIL_USE_TLS = env_config('EMAIL_USE_TLS')
# EMAIL_USE_SSL = env_config('EMAIL_USE_SSL')
DEFAULT_FROM_EMAIL = env_config('DEFAULT_FROM_EMAIL')
SERVER_EMAIL = env_config('SERVER_EMAIL')

# Default primary key field type
# https://docs.djangoproject.com/en/3.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'root': {
        'handlers': ['file', ],
    },
    'formatters': {
        'verbose': {
            'format': '%(levelname)s  %(asctime)s  %(module)s '
                      '%(process)d  %(thread)d  %(message)s'
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'verbose'
        },
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': './debug.log',
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django.db.backends': {
            'level': 'INFO',
            'handlers': ['console', 'file'],
            'propagate': False,
        },
        '': {
            'handlers': ['file'],
            'level': 'ERROR',
            'propagate': True,
        },
    },
}

# reset password
RESET_PASSWORD_CODE_LENGTH = env_config('RESET_PASSWORD_CODE_LENGTH', cast=int)
RESET_PASSWORD_CODE_EXPIRATION_TIME = env_config(
    'RESET_PASSWORD_CODE_EXPIRATION_TIME', cast=int)
RESET_PASSWORD_EXPIRATION_TIME = env_config(
    'RESET_PASSWORD_EXPIRATION_TIME', cast=int)
LINK_RESET_PASSWORD = env_config('LINK_RESET_PASSWORD')

EXPIRING_TOKEN_DURATION = datetime.timedelta(minutes=30)

DATE_FORMATS = ['%Y-%m-%d', '%d-%m-%Y']
MONTH_FORMATS = ['%m-%Y']
DATE_TIME_FORMATS = ['%Y-%m-%d %H:%M:%S']
TIME_FORMATS = ['%H:%M:%S', '%H:%M']
FILE_UPLOAD_MAX_MEMORY_SIZE = 1024 * 1024
FILE_UPLOAD_MAX_SIZE = 50 * 1024 * 1024

# Celery Configuration
CELERY_BROKER_URL = 'redis://localhost:6379/0'  # Use your broker URL here (e.g., RabbitMQ).
CELERY_RESULT_BACKEND = 'django-db'

# CRONJOBS = [
#     ('*/30 * * * *', 'apps.register_face.tasks.cronjob_train_model.capture_image')  # Adjust the schedule according to your needs
# ]

