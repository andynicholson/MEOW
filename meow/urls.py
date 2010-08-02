from django.conf.urls.defaults import *
from jsonrpc import jsonrpc_site

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

import meow.middleware.views

urlpatterns = patterns('',
    # Example:
    # (r'^meow/', include('meow.foo.urls')),

    url(r'^json/$', jsonrpc_site.dispatch, name='jsonrpc_mountpoint'),
	(r'^json/(?P<method>[a-zA-Z0-9.-_]+)$', jsonrpc_site.dispatch),


    (r'^messages/', include('django_messages.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^admin/', include(admin.site.urls)),
)
