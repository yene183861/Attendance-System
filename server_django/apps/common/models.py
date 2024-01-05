from django.db import models


class CommonModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    deleted_at = models.DateTimeField(default=None, blank=True, null=True)

    class Meta:
        abstract = True


class TrimmedCharFieldModel(models.CharField):
    def to_internal_value(self, data):
        # Trim whitespace from the value
        if isinstance(data, str):
            data = data.strip()

        return super().to_internal_value(data)
