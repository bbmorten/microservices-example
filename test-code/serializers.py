# Deneme için dokümantasyondan kopyalayıp kullandım. Çalışmıyor. Django
# ortamında çalışıyor.
# https://www.django-rest-framework.org/api-guide/serializers/

from datetime import datetime

class Comment:
    def __init__(self, email, content, created=None):
        self.email = email
        self.content = content
        self.created = created or datetime.now()

comment = Comment(email='leila@example.com', content='foo bar')

print(comment.email, comment.content, comment.created)

# Declaring a serializer

from rest_framework import serializers

class CommentSerializer(serializers.Serializer):
    email = serializers.EmailField()
    content = serializers.CharField(max_length=200)
    created = serializers.DateTimeField()


serializer = CommentSerializer(comment)
print(serializer.data)

