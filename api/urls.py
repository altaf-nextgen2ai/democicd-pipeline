from django.urls import path
from .views import HealthCheckView, ItemListView, ItemDetailView

urlpatterns = [
    path('health/', HealthCheckView.as_view(), name='health-check'),
    path('items/', ItemListView.as_view(), name='item-list'),
    path('items/<int:pk>/', ItemDetailView.as_view(), name='item-detail'),
]
