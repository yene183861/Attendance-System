from django.db.models.expressions import Subquery
from django.db import models


class SubqueryCount(Subquery):
    template = "(SELECT count(*) FROM (%(subquery)s) _count)"
    output_field = models.IntegerField()


class SubquerySum(Subquery):
    template = "(SELECT SUM(%(sum_field)s) FROM (%(subquery)s) _sum)"
    output_field = models.IntegerField()
    
    def __init__(self, queryset, output_field=None, *, sum_field, **extra):
        extra['sum_field'] = sum_field
        super(SubquerySum, self).__init__(queryset, output_field, **extra)