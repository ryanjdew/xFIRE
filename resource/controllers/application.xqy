xquery version "1.0-ml" ;

module namespace app-controller = "/xFire/controllers/application";

declare function app-controller:before-filter($params as map:map) as empty-sequence() {
	if (fn:empty(xdmp:request-timestamp()) and xdmp:get-request-method() eq 'GET')
	then fn:error(fn:QName('/xFire/error','XFIREERR:UPDATE_WITH_GET'), 'Updates should not be made with the GET request method')
	else ()
};