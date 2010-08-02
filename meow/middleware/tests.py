"""
This file demonstrates two different styles of tests (one doctest and one
unittest). These will both pass when you run "manage.py test".

Replace these with more appropriate tests for your application.
"""

from django.test import TestCase
from django_webtest import WebTest
from jsonrpc.proxy import ServiceProxy

class SimpleTest(TestCase):
    def test_basic_addition(self):
        """
        Tests that 1 + 1 always equals 2.
        """
        self.failUnlessEqual(1 + 1, 2)

__test__ = {"doctest": """
Another way to test that 1 + 1 is equal to 2.

>>> 1 + 1 == 2
True
"""}

# JSON RPC MEOW middle-ware tests
#
# parameters to existing MEOW install under test
#
SERVICE_PROXY_URL = 'http://erko.infiniterecursion.com.au/json/'
EXISTING_USERNAME = 'andy'
EXISTING_GROUPNAME = 'junta'

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
	res = self.proxy.meow.register(EXISTING_USERNAME,'plaintextpassword')
	reply_ = {u'error': {u'code': 500, u'data': None, u'message': u'OtherError: column username is not unique'} }
	assert res['error']['message'] == reply_['error']['message']
	#make a new user
	res = self.proxy.meow.register('randomuser','plaintextpassword')
	reply_ = {u'error': None, u'result': [u'randomuser', u'randomuser@meow.infinitecursion.com.au', 6]}
	assert res['error'] == None


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
	self.proxy.meow.register('randomuser','plaintextpassword')

	res = self.proxy.meow.listUsers('randomuser','plaintextpassword')
	# This test is assuming that ONE user has been created already (and ONLY one).
	# plus this test user. ASSUME ONLY TWO USERS SO FAR!
	#reply_ =  {u'result': [[u'andy', u'andy@infiniterecursion.com.au', 1]], u'jsonrpc': u'1.0', u'id': u'046f03f2-9d77-11df-bc0d-40618697e051', u'error': None}
	assert len(res['result']) == 2

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
	self.proxy.meow.register('randomuser','plaintextpassword')


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
	self.proxy.meow.register('randomuser','plaintextpassword')

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
	self.proxy.meow.register('randomuser','plaintextpassword')

	res = self.proxy.meow.listGroups('randomuser','plaintextpassword')
	# This test is assuming that ONE group has been created already (and ONLY one).
	#reply_ =  {u'result': [[u'andy', u'andy@infiniterecursion.com.au', 1]], u'jsonrpc': u'1.0', u'id': u'046f03f2-9d77-11df-bc0d-40618697e051', u'error': None}
	assert len(res['result']) == 1

	#delete test user
	self.proxy.meow.deactivate('randomuser','plaintextpassword')

