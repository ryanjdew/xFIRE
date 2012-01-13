xquery version "1.0-ml" ;

import module namespace r = "routes.xqy" at "/lib/routes.xqy";

let $orig-url := xdmp:get-original-url()
return
if (fn:matches($orig-url, '^/xray(/|$)')) then
	$orig-url
else
	let $cached-path := xdmp:get-server-field('routeCfgPath')
	let $route-path := if ($cached-path) then ($cached-path) else (xdmp:set-server-field('routeCfgPath',fn:concat(fn:replace(xdmp:modules-root(),'/$',''),'/config/routes.xml')))
	let $routes-cfg := xdmp:document-get($route-path)/*
	let $selected-route := r:selectedRoute($routes-cfg)
	return if (fn:matches($selected-route, '^/resource/views/')) 
		then fn:concat('/lib/xview_bridge.xqy?xview-url=',
							xdmp:url-encode(
								fn:concat(
									$selected-route, 
									if (fn:contains($selected-route, '?')) then '&amp;' else '?', 
									'orig-path=',(fn:substring-before($orig-url, '?'),$orig-url)[1]
								)
							)
						)
		else $selected-route