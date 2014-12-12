#!/usr/bin/env python
# changes target user password (does not work for admin's own one)
# run as python change_password.py <box_address> <admin_username> <admin_password> <user_to_change> <new_password>

from xml.etree import ElementTree
from xml.sax.saxutils import escape
import httplib, sys

class BaseRequest(object):
    inner = None # inner XML
    def wrapped(self, sessionId=None):
        attrs = ' sessionID="%s"' % sessionId if sessionId != None else ''
        return '<request%s>%s</request>' % (attrs, self.inner)

class RequestError(Exception):
    pass

class Login(BaseRequest):
    def __init__(self, username, password):
        self.inner = (
            '<session action="login"><credentials><username>%s</username>' \
            + '<password>%s</password></credentials></session>'
        ) % (escape(username), escape(password))

class Logout(BaseRequest):
    inner = '<session action="logout"/>'

class ChangePassword(BaseRequest):
    def __init__(self, target_username, target_password):
        self.inner = (
            '<user action="set"><operation><selector><username>%s</username></selector>'
            + '<sections><password><new>%s</new></password></sections></operation></user>'
        ) % (escape(target_username), escape(target_password))

class Box(object):
    def __init__(self, address, username, password):
        self.address = address
        self.username = username
        self.password = password

class XmlConnection(object):
    sessionId = None
    
    def __init__(self, box):
        self.box = box
        login = Login(self.box.username, self.box.password)
        response = self.send(login)
        self.sessionId = response.findtext("sessionID") 
    
    def send(self, request):
        """ Send one request to box or target if specified"""
        conn = httplib.HTTPConnection(self.box.address)
        conn.request("POST", "/xml",
            request.wrapped(self.sessionId),
            {'Accept': 'application/xml', 'Content-Type': 'application/xml; charset=utf-8'}
        )
        response = conn.getresponse()
        if response.status != 200:
            raise RequestError("HTTP error: %s" % response.reason)
        
        xmlResponse = ElementTree.fromstring(response.read())
        error = xmlResponse.find('error')
        if int(error.attrib['code']) != 0:
            message_set = ' | '.join([e.findtext('message') for e in xmlResponse.findall(".//error")])
            raise RequestError(message_set)
        return xmlResponse
    
    def close(self):
        self.send(Logout())

if __name__ == '__main__':
    if len(sys.argv) != 6:
        raise Exception('we need 5 arguments: IPCorder address, admin username, admin password, user name, password to set')
    
    box = Box(sys.argv[1], sys.argv[2], sys.argv[3])
    xmlConn = XmlConnection(box)
    response = xmlConn.send(ChangePassword(sys.argv[4], sys.argv[5]))
    xmlConn.close()
