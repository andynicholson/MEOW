''' MEOW
 Copyright 2010, Andy Nicholson
 Infinite Recursion Pty Ltd.
 Covered by the AGPLv3
 see http://www.gnu.org/licenses/agpl-3.0.html


 This file contains the MEOW JSON-RPC views.
'''

from jsonrpc import jsonrpc_method
from django.contrib.auth.models import User, Group
from django_messages.models import Message
import datetime
import logging

#
#
# Users/ Groups - Built in Django 
# Messaging - Django messages 
	# User to User messaging
	# User to Group messaging

# TODO

# binary messages, for u2u and u2g
# Locations - ? GeoDjango?


@jsonrpc_method('meow.echoService(msg=String) -> String',safe=True)
def ohce(request, msg):
  ''' Test echo service. 
      JSON-RPC view : meow.echoService

      Returns a fixed string 'ECHO ' + the message passed in
      Doesnt require authentication
  '''
  return "ECHO %s" % msg

#
# Users
#
@jsonrpc_method('meow.registerUser')
def register_user(request, username, password, email):
  '''
	JSON-RPC view : meow.registerUser

	Returns a JSON encoded array of the new username, email and ID
  '''
  u = User.objects.create_user(username, email , password)
  u.save()
  return [u.username, u.email, u.id]

@jsonrpc_method('meow.listUsers',authenticated=True)
def list_users(request):
  '''
	JSON-RPC view : meow.listUsers
	
	Returns a JSON encoded list of usernames, emails, and IDs of all users
	Requires authentication to call this function.
  '''
  users = User.objects.all()
  result = []
  for  user in users:
	result.append([user.username, user.email, user.id])
  return result

@jsonrpc_method('meow.deactivate',authenticated=True)
def delete_user(request):
  '''
        JSON-RPC view : meow.deactivate
        
        Returns True, if the currently authenticated user is successfully deleted.
	Requires authentication to call this function.
  '''
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
   logging.debug(' user %s has logged in !' % request.user)
   message_list = Message.objects.inbox_for(request.user)
   return_list=[]
   for m in message_list:
	# mark the time 'read_at' as now
	if m.read_at is None:
		now = datetime.datetime.now()
		m.read_at = now
		m.save()

	return_list.append([m.id,m.subject,m.body,m.sender.username,m.sent_at,m.read_at])
   return return_list

@jsonrpc_method('meow.inbox',authenticated=True)
def list_inbox_messages(request):
   message_list = Message.objects.inbox_for(request.user)
   return_list=[]
   logging.debug('User %s inbox' % request.user)
   for m in message_list:
	# mark the time 'read_at' as now
	if m.read_at is None:
		now = datetime.datetime.now()
		m.read_at = now
		m.save()
	return_list.append([m.id,m.subject,m.body,m.sender.username,m.sent_at,m.read_at])
	logging.debug('message %s ' % m)

   logging.debug('end inbox')
   return return_list

@jsonrpc_method('meow.outbox',authenticated=True)
def list_outbox_messages(request):
   message_list = Message.objects.outbox_for(request.user)
   return_list=[]
   for m in message_list:
	return_list.append([m.id,m.subject,m.body,m.sender.username,m.sent_at,m.read_at])
   return return_list

@jsonrpc_method('meow.trash',authenticated=True)
def list_trash_messages(request):
   message_list = Message.objects.trash_for(request.user)
   return_list=[]
   for m in message_list:
	return_list.append([m.id,m.subject,m.body,m.sender.username,m.sent_at,m.read_at])
   return return_list

@jsonrpc_method('meow.deleteMsg',authenticated=True)
def list_delete_msg(request, msgid):
  #see django-messages 'views.py' delete method
  logging.debug('deleting msg id %s' % msgid)
  message=Message.objects.all().filter(id=msgid)
  if len(message) != 1:
	return False
  deleted=False
  now = datetime.datetime.now()
  if message[0].sender == request.user:
        message[0].sender_deleted_at = now
        deleted = True
  if message[0].recipient == request.user:
        message[0].recipient_deleted_at = now
        deleted = True
  if deleted:
        message[0].save()
	return True
  return False
 

@jsonrpc_method('meow.sendMsg',authenticated=True)
def send_message(request,msg_body,msg_subject,msg_receiver):
   try:
	   logging.debug('start meow.sendMsg with %s %s %s ' %  (msg_body,msg_subject,msg_receiver))
	   msg_receiver_user = User.objects.all().filter(username=msg_receiver)
	   if len(msg_receiver_user) != 1:
		return False
	   msg_receiver_user = msg_receiver_user[0]
	   logging.debug(" MSG %s %s %s %s " % (request.user, msg_receiver_user, msg_subject, msg_body))
	   msg = Message(
				sender = request.user,
				recipient = msg_receiver_user,
				subject = msg_subject,
				body = msg_body,
			    )
	   msg.save()
	   return True
   except:
	logging.error('meow.sendMsg got exception')
	return False

@jsonrpc_method('meow.sendMsgReply',authenticated=True)
def send_reply(request,msg_body,msg_subject,msg_receiver,parent_id):
   try:
	   logging.debug('start meow.sendMsgReply with %s %s %s %d ' %  (msg_body,msg_subject,msg_receiver, parent_id))
	   msg_receiver_user = User.objects.all().filter(username=msg_receiver)
	   if len(msg_receiver_user) != 1:
		return False
	   msg_receiver_user = msg_receiver_user[0]
	   logging.debug(" MSG %s %s %s %s  %d" % (request.user, msg_receiver_user, msg_subject, msg_body,parent_id))
	   msg = Message(
				sender = request.user,
				recipient = msg_receiver_user,
				subject = msg_subject,
				body = msg_body,
			    )
	   parent_msg_obj = Message.objects.filter(id=parent_id)
	   if (len(parent_msg_obj)!=1):
		return False
	   msg.parent_msg=parent_msg_obj[0]
	   msg.save()
	   return True
   except:
	logging.error('meow.sendMsgReply got exception')
	return False


@jsonrpc_method('meow.sendMsgToGroup',authenticated=True)
def send_message_to_group(request,msg_body,msg_subject,grp_receiver):
	#find group - if doesnt exist , return False
	grp_receiver_obj = Group.objects.all().filter(name=grp_receiver)
	logging.debug('meow.sendMsgToGroup got grp name %s and found objs %s ' % (grp_receiver, grp_receiver_obj))
	if len(grp_receiver_obj) != 1:
		return False
	#ok - get all users
	users_in_group=User.objects.all().filter(groups__name=grp_receiver)		
	sent = 0
 	for u in users_in_group:
		logging.debug( ' user in group %s' % u )
		user_ok = send_message(request,msg_body,msg_subject,u.username)	
		if user_ok != True:
			return False
		else:
			sent = sent + 1
	return sent

#
# Threads
#

def get_parents(msgid, ancestor_list):
	parents=Message.objects.filter(recipient_deleted_at__isnull=True, id=msgid)	
	for p in parents:
		children=Message.objects.filter(recipient_deleted_at__isnull=True, parent_msg=p)
		for c in children:
			ancestor_list.append([c.id,c.subject,c.body,c.sender.username,c.sent_at,c.read_at])
		#recurse if we have a parent
		if (not p.parent_msg is None):
			ancestor_list=get_parents(p.parent_msg.id,ancestor_list)
		else:
			ancestor_list.append([p.id,p.subject,p.body,p.sender.username,p.sent_at,p.read_at])
		
	return ancestor_list

@jsonrpc_method('meow.getThread',authenticated=True)
def get_thread(request,msg_id):
   try:
	   logging.debug('start meow.getThread with %s ' %  (msg_id))
	   return get_parents(msg_id,[])

   except:
	logging.error('meow.getThread got exception')
	return  []


