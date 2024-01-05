from django.db import models
from apps.user.models import User
from apps.common.constants import TicketStatus
from apps.common.models import CommonModel, TrimmedCharFieldModel
from django.core.validators import MaxValueValidator, MinValueValidator
from apps.common.models import  TrimmedCharFieldModel


# model đánh giá nhân sự
class PersonnelEvaluation(CommonModel):
    appraisee = models.ForeignKey(User, on_delete=models.CASCADE, related_name='appraisee')
    # người đánh giá
    appraiser = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='appraiser')
    reviewer = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='evaluation_reviewer')
    cycle_name = TrimmedCharFieldModel(max_length=255)
    duration = models.IntegerField(default=0)
    start_date = models.DateField()
    end_date = models.DateField()
    job_result = models.FloatField(default=0)
    attitude = models.FloatField(default=0)
    # attitude_criteria = models.ForeignKey(AttitudeCriteria, blank=True, many = True)
    total_score = models.FloatField(default=0)
    class Meta:
        db_table = 'personnel_evaluation'
        abstract = True

# class AttitudeCriteria(CommonModel):
#     appraisee = models.ForeignKey(PersonnelEvaluation, on_delete=models.CASCADE)
#     # người đánh giá
#     appraiser = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='appraiser')
#     reviewer = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, related_name='reviewer')
#     cycle_name = models.TrimmedCharFieldModel(max_length=255)
#     duration = models.IntegerField(default=0)
#     start_date = models.DateField()
#     end_date = models.DateField()
#     job_result = models.FloatField()
#     attitude = models.FloatField()
#     total_score = models.FloatField()
#     class Meta:
#         db_table = 'attitude_criteria'
#
