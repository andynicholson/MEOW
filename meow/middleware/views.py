# Create your views here.

from jsonrpc import jsonrpc_method
from django.contrib.auth.models import User

@jsonrpc_method('meow.echoService(msg=String) -> String',safe=True)
def ohce(request, msg):
  return "ECHO %s" % msg

@jsonrpc_method('meow.register')
def register_user(request, username, password):
  u = User.objects.create_user(username, '%s@meow.infinitecursion.com.au'%username, password)
  u.save()
  return [u.username, u.email, u.id]

@jsonrpc_method('meow.listUsers',authenticated=True)
def list_users(request):
  users = User.objects.all()
  result = []
  for  user in users:
	result.append([user.username, user.email, user.id])
  return result

@jsonrpc_method('meow.deactivate',authenticated=True)
def delete_user(request):
  request.user.delete()
  return True


