from urllib import quote

def application(environ, start_response):
	url = 'https://'

	if environ.get('HTTP_HOST'):
		url += environ['HTTP_HOST']
	else:
		url += environ['SERVER_NAME']

	url += quote(environ.get('SCRIPT_NAME', ''))
	url += quote(environ.get('PATH_INFO', ''))
	if environ.get('QUERY_STRING'):
		url += '?' + environ['QUERY_STRING']

	status = "301 Moved Permanently"
	headers = [('Location',url),('Content-Length','0')]

	start_response(status, headers)
	return []
