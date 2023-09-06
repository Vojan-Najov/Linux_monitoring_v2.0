
source "$(dirname $0)""/generator_aux.sh"

for i in {1..5}; do
	DATE=$( gen_random_date )
	(( ENTRY_COUNT = 100 + ($RANDOM % 900) ))
	LOGFILE="nginx_combined_format_""$( date "+%Y%m%d%H%M%S" )"".log"
	gen_logfile $ENTRY_COUNT $DATE $LOGFILE
	sleep 1
done

# 200 OK
#   Standard response for successful HTTP requests. The actual response will
# depend on the request method used. In a GET request, the response will contain
# an entity corresponding to the requested resource. In a POST request, the response
# will contain an entity describing or containing the result of the action.

# 201 Created
#   The request has been fulfilled, resulting in the creation of a new resource.

# 400 Bad Request
#   The server cannot or will not process the request due to an apparent client
# error (e.g., malformed request syntax, size too large, invalid request message
# framing, or deceptive request routing).

# 401 Unauthorized
#   Similar to 403 Forbidden, but specifically for use when authentication is
# required and has failed or has not yet been provided. The response must include a
# WWW-Authenticate header field containing a challenge applicable to the requested
# resource.

# 403 Forbidden
#   The request contained valid data and was understood by the server, but the server
# is refusing action. This may be due to the user not having the necessary
# permissions for a resource or needing an account of some sort, or attempting a
# prohibited action (e.g. creating a duplicate record where only one is allowed).
# This code is also typically used if the request provided authentication by
# answering the WWW-Authenticate header field challenge, but the server did not
# accept that authentication. The request should not be repeated.

# 404 Not Found
#   The requested resource could not be found but may be available in the future.
# Subsequent requests by the client are permissible.

# 500 Internal Server Error
#   A generic error message, given when an unexpected condition was encountered and
# no more specific message is suitable.

# 501 Not Implemented
#   The server either does not recognize the request method, or it lacks the ability
# to fulfil the request. Usually this implies future availability (e.g., a new
# feature of a web-service API).

# 502 Bad Gateway
#   The server was acting as a gateway or proxy and received an invalid response
# from the upstream server.

# 503 Service Unavailable
#   The server cannot handle the request (because it is overloaded or down for
# maintenance). Generally, this is a temporary state

