# Create a repository for the project
# Clone the project
git clone https://github.com/bbmorten/microservices-example.git
cd microservices-example
mkdir admin
cd admin
# Create a python virtual environment
pipenv install django
pipenv install djangorestframework

pipenv shell
django-admin startproject admin
cd admin
python manage.py runserver

# requirements.txt için tembellik yapmak için
pipenv install django-cors-headers
pipenv install pika
# Burada arıza çıktı
# MySQL yüklü ama yüklenmemiş yapmak için
# https://pypi.org/project/mysqlclient/
# brew install mysql-client
# echo 'export PATH="/usr/local/opt/mysql-client/bin:$PATH"' >> ~/.zshrc
# source ~/.zshrc
pipenv install mysqlclient
pipenv run pip freeze > admin/requirements.txt

cd /Users/bulent/Documents/SoftwareProjects/microservices-example/admin/admin
# Docker çalışıyor olmalı
docker-compose up

# docker compose file'i mysql için güncelliyoruz.
# Step MYSQL

# Backend containerine bağlanıyoruz
docker-compose exec backend sh

python manage.py startapp products

# admin/admin/admin/settings.py 

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
    'products'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]


CORS_ORIGIN_ALLOW_ALL = True



#BASE_DIR = Path(__file__).resolve().parent.parent
BASE_DIR = "admin"


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': BASE_DIR,
        'USER': 'dbadmin',
        'PASSWORD': 'Qazwsx123_',
        'HOST': 'db',
        'PORT': '3306',
    }
}


# Models.py dosyasını products altında düzenledik.
from django.db import models

# Create your models here.

class Product(models.Model):
    title = models.CharField(max_length=200)
    image = models.CharField(max_length=200)
    likes = models.PositiveIntegerField(default=0)

"""     description = models.TextField(blank=True, null=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='images/', blank=True, null=True)

    def __str__(self):
        return self.name """
class User(models.Model):
    pass

# Tekrar containere gidiyoruz ve migrate ediyoruz.

docker-compose exec backend sh
python manage.py makemigrations
python manage.py migrate

# serializers.py dosyasını products altında düzenledik.
# admin/admin/products/serializers.py

from rest_framework import serializers
from .models import Product

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        # fields = ('id', 'name', 'price', 'description', 'created_at', 'updated_at')
        fields = '__all__'


# admin/admin/products/views.py

from rest_framework.response import Response
from rest_framework import viewsets
from rest_framework import status

from .models import Product
from .serializers import ProductSerializer

class ProductViewSet(viewsets.ViewSet):
    def list(self, request): # /api/products/
        products = Product.objects.all()   
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data) 

    def create(self, request): # /api/products/
        serializer = ProductSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

        
    def retrieve(self, request, pk=None): # /api/products/<str:id>
        product = Product.objects.get(id=pk)
        serializer = ProductSerializer(product)
        return Response(serializer.data)

    def update(self, request, pk=None): # /api/products/<str:id>
        product = Product.objects.get(id=pk)
        serializer = ProductSerializer(instance=product, data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_202_ACCEPTED)

        
    def destroy(self, request, pk=None): # /api/products/<str:id>
        product = Product.objects.get(id=pk)
        product.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

        



# admin/admin/products/urls.py
from django.contrib import admin
from django.urls import path
from .views import ProductViewSet

urlpatterns = [
    path('products', ProductViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('products/<str:pk>', ProductViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),
]


# admin/admin/urls.py

from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('products.urls')),

]


# Tested with postman Microservice collection on bbmorten


