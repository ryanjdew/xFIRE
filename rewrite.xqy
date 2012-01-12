xquery version "1.0-ml" ;

import module namespace r = "routes.xqy" at "/lib/routes.xqy";

let $cached-path := xdmp:get-server-field('routeCfgPath')
let $route-path := if ($cached-path) then ($cached-path) else (xdmp:set-server-field('routeCfgPath',fn:concat(fn:replace(xdmp:modules-root(),'/$',''),'/config/routes.xml')))
let $routes-cfg := xdmp:document-get($route-path)/*
let $selected-route := r:selectedRoute($routes-cfg)
let $orig-url := xdmp:get-original-url()
return if (fn:matches($selected-route, '\.xview')) 
	   then fn:concat('/lib/xview_bridge.xqy?xview-url=',
						xdmp:url-encode(
							fn:concat(
								fn:replace($selected-route,'\.xview', ''), 
								if (fn:contains($selected-route, '?')) then '&amp;' else '?', 
								'orig-path=',if (fn:contains($orig-url, '?')) then fn:substring-before($orig-url, '?') else $orig-url 
							)
						)
					)
	   else $selected-route