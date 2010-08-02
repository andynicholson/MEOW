# Create your views here.

from jsonrpc import jsonrpc_method
from django.contrib.auth.models import User, Group
#
#
# Users/ Groups - Built in Django 
# Messaging - Django messages 
# Locations - ? GeoDjango?

@jsonrpc_method('meow.echoService(msg=String) -> String',safe=True)
def ohce(request, msg):
  return "ECHO %s" % msg

#
# Users
#
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

#
# Groups
#
@jsonrpc_method('meow.joinGroup',authenticated=True)
def join_group(request, group_name):
  g=Group.objects.all().filter(name=group_name)
  if len(g) > 0:
	request.user.groups.add(g[0])
  	request.user.save() 
	return True
  return False

@jsonrpc_method('meow.listGroups',authenticated=True)
def list_groups(request):
  grps = Group.objects.all()
  result = []
  for  g in grps:
	result.append([g.name])
  return result

@jsonrpc_method('meow.leaveGroup',authenticated=True)
def leave_group(request,group_name):
  g=Group.objects.all().filter(name=group_name)
  if len(g) > 0:
	  request.user.groups.remove(g[0])
	  request.user.save() 
	  return True
  return False



