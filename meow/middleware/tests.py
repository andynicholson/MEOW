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


class MeowTestCase(WebTest):
   def test_echo_service(self):
	self.proxy = ServiceProxy('http://erko.infiniterecursion.com.au/json/')
	res = self.proxy.meow.echoService('WHAT')
	reply_ = {u'error': None, u'id': u'jsonrpc', u'result': u'ECHO WHAT'}
	assert res['result'] == reply_['result']

   def test_list_users(self):
	self.proxy = ServiceProxy('http://erko.infiniterecursion.com.au/json/')
	res = self.proxy.meow.listUsers()
	reply_ =  {u'result': [[u'andy', u'andy@infiniterecursion.com.au', 1]], u'jsonrpc': u'1.0', u'id': u'046f03f2-9d77-11df-bc0d-40618697e051', u'error': None}
	print res
	assert res['result'] == reply_['result']

   def test_add_user(self):
	self.proxy = ServiceProxy('http://erko.infiniterecursion.com.au/json/')
	res = self.proxy.meow.register('andy','plaintextpassword')
	reply_ = {u'error': {u'code': 500, u'data': None, u'message': u'OtherError: column username is not unique'} }
	print res
	assert res['error']['message'] == reply_['error']['message']

	res = self.proxy.meow.register('randomuser','plaintextpassword')
	reply_ = {u'error': None, u'result': [u'randomuser', u'randomuser@meow.infinitecursion.com.au', 6]}
	print res
	assert res['error'] == None


   def test_delete_user(self):
	self.proxy = ServiceProxy('http://erko.infiniterecursion.com.au/json/')
	try:
		res = self.proxy.meow.deactivate('andy','wrongpassword')
		## We SHOULD get the IOError
		assert True == False
	except IOError, e:
		print e

	res = self.proxy.meow.deactivate('randomuser','plaintextpassword')
	reply_ =  {u'error': None, u'result': [u'randomuser', u'randomuser@meow.infinitecursion.com.au', 6]}
	print res
	assert res['error'] == None




