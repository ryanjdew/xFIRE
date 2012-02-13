xquery version "1.0-ml" ;

import module namespace rest="http://marklogic.com/appservices/rest" at "/MarkLogic/appservices/utils/rest.xqy";

let $orig-url := xdmp:get-original-url()
let $cached-path := xdmp:get-server-field('routeCfgPath')
let $route-path := if ($cached-path) then ($cached-path) else (xdmp:set-server-field('routeCfgPath',fn:concat(fn:replace(xdmp:modules-root(),'/$',''),'/config/routes.xml')))
let $routes-cfg := xdmp:document-get($route-path)/*
let $selected-route := rest:rewrite($routes-cfg,$orig-url)
return
 	(: If the selected route is a view then pass it to our special xqy page :)
	if (fn:matches($selected-route, '^/resource/views/')) 
	then fn:concat('/lib/xview_bridge.xqy?xview-url=',
						fn:replace($selected-route, '\?', '&amp;'), 
						'&amp;orig-path=',xdmp:url-encode((fn:substring-before($orig-url, '?'),$orig-url)[1])
					)
	(: Else just pass the selected route on as normal :)
	else if (fn:empty($selected-route))
		 then $orig-url
		 else $selected-route