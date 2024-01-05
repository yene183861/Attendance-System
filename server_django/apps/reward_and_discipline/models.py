from django.db import models
from apps.user.models import User
from apps.common.models import CommonModel, TrimmedCharFieldModel
from django.core.validators import MinValueValidator


# Create your models here.
class RewardOrDiscipline(CommonModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    title = TrimmedCharFieldModel(max_length=255)
    content = TrimmedCharFieldModel(max_length=255)
    amount = models.FloatField(validators=[MinValueValidator(0)])
    month = models.DateField()
    is_reward = models.BooleanField()

    class Meta:
        db_table = 'reward_and_discipline'




