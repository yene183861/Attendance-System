
from rest_framework import serializers
from apps.common.serializers import TrimmedCharField

class SearchEmailSerializer(serializers.Serializer):
    email = serializers.EmailField()