""" MEOW
 Copyright 2010, Andy Nicholson
 Infinite Recursion Pty Ltd.
 Covered by the AGPLv3
 see http://www.gnu.org/licenses/agpl-3.0.html
 
 This file contains the MEOW tests, running JSON-RPC tests via proxy object into the configured Django web service endpoint.

 Run "manage.py test" from the top-level Django directory to run these tests

"""

from django.test import TestCase
from django_webtest import WebTest
from jsonrpc.proxy import ServiceProxy

# JSON RPC MEOW middle-ware tests
#
# parameters to existing MEOW install under test
#
SERVICE_PROXY_URL = 'http://meow.infiniterecursion.com.au/json/'
EXISTING_USERNAME = 'andy'
EXISTING_GROUPNAME = 'junta'
TEST_MSG_CONTENT = 'THIS IS THE MESSAGE'

#
# main test case for MEOW
# Webtest testframework - http://pypi.python.org/pypi/django-webtest/
#
# Every service should be tested at least once, both succeding and failing
#
class MeowTestCase(WebTest):
   def test_echo_service(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	res = self.proxy.meow.echoService('WHAT')
	reply_ = {u'error': None, u'result': u'ECHO WHAT'}
	assert res['result'] == reply_['result']

#
# Users
#
   def test_add_user(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	# This test is assuming that ONE user has been created already (and ONLY one).
        #Change it to the first django user you created
	# This test is designed to FAIL at making a new user - ie testing uniqueness constraint
	res = self.proxy.meow.registerUser(EXISTING_USERNAME,'plaintextpassword','a@b.c')
	reply_ = {u'error': {u'code': 500, u'data': None, u'message': u'OtherError: column username is not unique'} }
	assert res['error']['message'] == reply_['error']['message']
	#make a new user
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')
	reply_ = {u'error': None, u'result': [u'randomuser', u'randomuser@meow.infinitecursion.com.au', 6]}
	print res
	assert res['error'] == None
	assert res['result'][1] == 'intothemist@gmail.com'


   def test_delete_user(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	try:
		res = self.proxy.meow.deactivate(EXISTING_USERNAME,'wrongpassword')
		## We SHOULD get the IOError
		assert True == False
	except IOError, e:
		pass

	res = self.proxy.meow.deactivate('randomuser','plaintextpassword')
	reply_ =  {u'error': None, u'result': [u'randomuser', u'randomuser@meow.infinitecursion.com.au', 6]}
	assert res['error'] == None


   def test_list_users(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)

	try:
		res = self.proxy.meow.listUsers('randomuser','doesntexistpassword')
	        ## We SHOULD get the IOError
                assert True == False
        except IOError, e:
                pass

	#create a test user
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')

	res = self.proxy.meow.listUsers('randomuser','plaintextpassword')
	# This test is assuming that ONE user has been created already (and ONLY one).
	# plus this test user. ASSUME ONLY TWO USERS SO FAR!
	#reply_ =  {u'result': [[u'andy', u'andy@infiniterecursion.com.au', 1]], u'jsonrpc': u'1.0', u'id': u'046f03f2-9d77-11df-bc0d-40618697e051', u'error': None}
	assert len(res['result']) != 0

	# Make this a super-user function only 
	# XXX make this a test of functions just registered users cant do


	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')

#
# Groups
#
   def test_join_group(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	# This test is assuming that ONE group has been created already (and ONLY one).
        #Change it to a django group you created
	# This test is designed to FAIL at joining a group - ie testing security constraint
	try:
		res = self.proxy.meow.joinGroup('randomuser','wrongpassword',EXISTING_GROUPNAME)
		## We SHOULD get the IOError
		assert True == False
	except IOError, e:
		pass

	#create a test user
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')


	#join a group
	res = self.proxy.meow.joinGroup('randomuser','plaintextpassword',EXISTING_GROUPNAME)
	reply_ = {u'error': None, u'result': [u'randomuser', u'randomuser@meow.infinitecursion.com.au', 6]}
	assert res['error'] == None
	assert res['result'] == True

	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')


   def test_leave_group(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	# This test is assuming that ONE group has been created already (and ONLY one).
        #Change it to a django group you created
	# This test is designed to FAIL at leaving a group - ie testing security constraint
	try:
		res = self.proxy.meow.leaveGroup('randomuser','wrongpassword',EXISTING_GROUPNAME)
		## We SHOULD get the IOError
		assert True == False
	except IOError, e:
		pass

	#create a test user
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')

	#leave a group
	res = self.proxy.meow.leaveGroup('randomuser','plaintextpassword',EXISTING_GROUPNAME)
	reply_ = {u'error': None, u'result': [u'randomuser', u'randomuser@meow.infinitecursion.com.au', 6]}
	assert res['error'] == None
	assert res['result'] == True

	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')


   def test_list_groups(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)

	try:
		res = self.proxy.meow.listGroups('randomuser','doesntexistpassword')
	        ## We SHOULD get the IOError
                assert True == False
        except IOError, e:
                pass

	#create a test user
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')

	res = self.proxy.meow.listGroups('randomuser','plaintextpassword')
	# This test is assuming that ONE group has been created already (and ONLY one).
	#reply_ =  {u'result': [[u'andy', u'andy@infiniterecursion.com.au', 1]], u'jsonrpc': u'1.0', u'id': u'046f03f2-9d77-11df-bc0d-40618697e051', u'error': None}
	assert len(res['result']) == 1

	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')

#
# Messaging
#
   def test_login_to_messaging(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	# This test is designed to FAIL at logining into the system - ie testing security constraint
	try:
		res = self.proxy.meow.login('randomuser','wrongpassword')
		## We SHOULD get the IOError
		assert True == False
	except IOError, e:
		pass

	#create a test user
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')


	#Login
	res = self.proxy.meow.login('randomuser','plaintextpassword')
	assert res['error'] == None
	assert (len(res['result']) >= 0) == True

	##
	# Add more tests to inbox messages
	# XXX

	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')

   def test_sendingreceiving_within_messaging_u2u(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	# This test is designed to FAIL at loging into into the system - ie testing security constraint
	try:
		res = self.proxy.meow.login('randomuser','wrongpassword')
		## We SHOULD get the IOError
		assert True == False
	except IOError, e:
		pass

	#create a test user to send messages
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')
	#create a test user to receive messages
	res = self.proxy.meow.registerUser('randomuser2','plaintextpassword__','hacker.riot@gmail.com')

	#Login
	res = self.proxy.meow.login('randomuser','plaintextpassword')
	assert res['error'] == None
	assert (len(res['result']) >= 0) == True

	res = self.proxy.meow.login('randomuser2','plaintextpassword__')
	assert res['error'] == None
	assert (len(res['result']) >= 0) == True


	# test sending to non-existent user, and see it fail
	res_send = self.proxy.meow.sendMsg('randomuser','plaintextpassword',TEST_MSG_CONTENT,'subject','123_randomuser_dontexist')
        assert res_send['error'] == None
	assert res_send['result'] == False
	

	#
	# Test sending message and checking outbox size incr by one
        #

	# Get inbox
	# (for send test below)
	res_inbox_before_2 = self.proxy.meow.inbox('randomuser2','plaintextpassword__')
	assert res_inbox_before_2['error'] == None
	assert (len(res_inbox_before_2['result']) >= 0) == True


	# Get outbox
	res_outbox_before_1 = self.proxy.meow.outbox('randomuser','plaintextpassword')
	assert res_outbox_before_1['error'] == None
	assert (len(res_outbox_before_1['result']) >= 0) == True


	# Send message
	res_send = self.proxy.meow.sendMsg('randomuser','plaintextpassword',TEST_MSG_CONTENT,'subject','randomuser2')
	assert res_send['error'] == None
	assert res_send['result'] == True


	# get outbox again
	res_outbox_after_1 = self.proxy.meow.outbox('randomuser','plaintextpassword')
	assert res_outbox_after_1['error'] == None
	assert (len(res_outbox_after_1['result']) >= 0) == True


	# assert outbox is incr 1
	assert ( len(res_outbox_before_1['result']) == ( len(res_outbox_after_1['result']) - 1) )

	#
	# Test receiving message and checking inbox size incr by one
	#
	
	# Recieve message
	# get inbox again
	res_inbox_after_2 = self.proxy.meow.inbox('randomuser2','plaintextpassword__')
	assert res_inbox_after_2['error'] == None
	assert (len(res_inbox_after_2['result']) >= 0) == True

	#XXX
	# check message content is == TEST_MESSAGE_CONTENT

	# assert inbox is incr 1
	assert ( len(res_inbox_before_2['result']) == ( len(res_inbox_after_2['result']) - 1) )



	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')
	self.proxy.meow.deactivate('randomuser2','plaintextpassword__')

   def test_sendingreceiving_within_messaging_u2g(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)
	# This test is designed to FAIL at loging into into the system - ie testing security constraint
	try:
		res = self.proxy.meow.login('randomuser','wrongpassword')
		## We SHOULD get the IOError
		assert True == False
	except IOError, e:
		pass

	#create a test user to send messages
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')
	#create a test user to receive messages
	res = self.proxy.meow.registerUser('randomuser2','plaintextpassword__','hacker.riot@gmail.com')
	#create a test user to receive messages
	res = self.proxy.meow.registerUser('randomuser3','plaintextpassword___','hacker.riot@gmail.com')

	#Login
	res = self.proxy.meow.login('randomuser','plaintextpassword')
	assert res['error'] == None
	assert (len(res['result']) >= 0) == True

	res = self.proxy.meow.login('randomuser2','plaintextpassword__')
	assert res['error'] == None
	assert (len(res['result']) >= 0) == True

	res = self.proxy.meow.login('randomuser3','plaintextpassword___')
	assert res['error'] == None
	assert (len(res['result']) >= 0) == True


	# test sending to non-existent group, and see it fail
	res_send = self.proxy.meow.sendMsgToGroup('randomuser','plaintextpassword',TEST_MSG_CONTENT,'subject','randomgrp4_dontexist')
	#print res_send
        assert res_send['error'] == None
	assert res_send['result'] == False
	

	#
	# Test sending message and checking outbox size incr by one
        #

	# Get inbox
	# (for send test below)
	res_inbox_before_2 = self.proxy.meow.inbox('randomuser2','plaintextpassword__')
	assert res_inbox_before_2['error'] == None
	assert (len(res_inbox_before_2['result']) >= 0) == True

	# Get inbox
	# (for send test below)
	res_inbox_before_3 = self.proxy.meow.inbox('randomuser3','plaintextpassword___')
	assert res_inbox_before_3['error'] == None
	assert (len(res_inbox_before_3['result']) >= 0) == True


	# Get outbox
	res_outbox_before_1 = self.proxy.meow.outbox('randomuser','plaintextpassword')
	assert res_outbox_before_1['error'] == None
	assert (len(res_outbox_before_1['result']) >= 0) == True
	#print "RandomUser outbox %d " % ( len(res_outbox_before_1['result']) )

	# make sure both first  two users are in group
	res = self.proxy.meow.joinGroup('randomuser','plaintextpassword',EXISTING_GROUPNAME)
	res = self.proxy.meow.joinGroup('randomuser2','plaintextpassword__',EXISTING_GROUPNAME)

	# Send message
	res_send = self.proxy.meow.sendMsgToGroup('randomuser','plaintextpassword',TEST_MSG_CONTENT,'subject group',EXISTING_GROUPNAME)
	print res_send
	assert res_send['error'] == None
	assert res_send['result'] != False
	group_size = res_send['result']


	# get outbox again
	res_outbox_after_1 = self.proxy.meow.outbox('randomuser','plaintextpassword')
	assert res_outbox_after_1['error'] == None
	assert (len(res_outbox_after_1['result']) >= 0) == True
	#print "RandomUser outbox %d " % ( len(res_outbox_after_1['result']) )


	# assert outbox is incr number of people in group!
	assert ( len(res_outbox_before_1['result']) == ( len(res_outbox_after_1['result']) - group_size) )

	#
	# Test receiving message and checking inbox size incr by one
	# Third random user should NOT have inbox size incr by one - user wasnt in group
	
	# Recieve message
	# get inbox again
	res_inbox_after_2 = self.proxy.meow.inbox('randomuser2','plaintextpassword__')
	assert res_inbox_after_2['error'] == None
	assert (len(res_inbox_after_2['result']) >= 0) == True

	#XXX
	# check message content is == TEST_MESSAGE_CONTENT

	# assert inbox is incr 1
	assert ( len(res_inbox_before_2['result']) == ( len(res_inbox_after_2['result']) - 1) )

	# get inbox again for third user
	res_inbox_after_3 = self.proxy.meow.inbox('randomuser3','plaintextpassword___')
	assert res_inbox_after_3['error'] == None
	assert (len(res_inbox_after_3['result']) >= 0) == True

	#XXX
	# check message content is == TEST_MESSAGE_CONTENT

	# assert inbox is NOT incr 1
	# Third user ws NOT in group!
	assert ( len(res_inbox_before_3['result']) == ( len(res_inbox_after_3['result']) ) )



	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')
	self.proxy.meow.deactivate('randomuser2','plaintextpassword__')
	self.proxy.meow.deactivate('randomuser3','plaintextpassword___')

#
# Threads
#

   def test_get_thread(self):
	self.proxy = ServiceProxy(SERVICE_PROXY_URL)

	try:
		res = self.proxy.meow.listUsers('randomuser','doesntexistpassword')
	        ## We SHOULD get the IOError
                assert True == False
        except IOError, e:
                pass

	#create a test user
	res = self.proxy.meow.registerUser('randomuser','plaintextpassword','intothemist@gmail.com')

	res = self.proxy.meow.getThread('randomuser','plaintextpassword', '32')
	# This test is assuming that ONE user has been created already (and ONLY one).
	# plus this test user. ASSUME ONLY TWO USERS SO FAR!
	#reply_ =  {u'result': [[u'andy', u'andy@infiniterecursion.com.au', 1]], u'jsonrpc': u'1.0', u'id': u'046f03f2-9d77-11df-bc0d-40618697e051', u'error': None}
	assert len(res['result']) != 0
	print " result from getThread"
	print res

	# Make this a super-user function only 
	# XXX make this a test of functions just registered users cant do


	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')


