# MEOW
# Copyright 2010, Andy Nicholson
# Infinite Recursion Pty Ltd.
# AGPLv3

from jsonrpc import jsonrpc_method
from django.contrib.auth.models import User, Group
from django_messages.models import Message

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
@jsonrpc_method('meow.registerUser')
def register_user(request, username, password, email):
  u = User.objects.create_user(username, email , password)
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

#
# Messages
#
@jsonrpc_method('meow.login',authenticated=True)
def login_and_list_inbox_messages(request):
   message_list = Message.objects.inbox_for(request.user)
   return_list=[]
   for m in message_list:
	return_list.append([m.subject,m.body,m.sender.id])
   return return_list

@jsonrpc_method('meow.inbox',authenticated=True)
def list_inbox_messages(request):
   message_list = Message.objects.inbox_for(request.user)
   return_list=[]
   for m in message_list:
	return_list.append([m.subject,m.body,m.sender.id])
   return return_list


@jsonrpc_method('meow.outbox',authenticated=True)
def list_outbox_messages(request):
   message_list = Message.objects.outbox_for(request.user)
   return_list=[]
   for m in message_list:
	return_list.append([m.subject,m.body,m.sender.id])
   return return_list

@jsonrpc_method('meow.trash',authenticated=True)
def list_trash_messages(request):
   message_list = Message.objects.trash_for(request.user)
   return_list=[]
   for m in message_list:
	return_list.append([m.subject,m.body,m.sender.id])
   return return_list

@jsonrpc_method('meow.sendMsg',authenticated=True)
def list_send_message(request,msg_body,msg_subject,msg_receiver):
   try:
	   msg_receiver_user = User.objects.all().filter(username=msg_receiver)
	   if len(msg_receiver_user) != 1:
		return False
	   msg_receiver_user = msg_receiver_user[0]
	   msg = Message(
				sender = request.user,
				recipient = msg_receiver_user,
				subject = msg_subject,
				body = msg_body,
			    )
	   msg.save()
	   return True
   except:
	   return False

