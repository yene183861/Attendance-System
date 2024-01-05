from rest_framework import serializers


class DeleteSerialize(serializers.Serializer):
    pk = serializers.ListField(child=serializers.IntegerField(default=0))


class EmptySerializer(serializers.Serializer):
    pass


class TrimmedCharField(serializers.CharField):
    def to_internal_value(self, data):
        # Trim whitespace from the value
        if isinstance(data, str):
            data = data.strip()

        return super().to_internal_value(data)
