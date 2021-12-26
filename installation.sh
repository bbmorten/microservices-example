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
