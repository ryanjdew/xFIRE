xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";
import module namespace app-controller = "/xFire/controllers/application" at "/resource/controllers/application.xqy";

let $path := xdmp:get-request-field('xview-url'),
	$path-parts := tokenize($path,'#')
return (
	app-controller:before-filter(layout:params-map()),
	xdmp:apply(
		xdmp:function(
			QName(concat('/xFire/controllers/',$path-parts[1]),$path-parts[2]),
			concat('/resource/controllers/',$path-parts[1],'.xqy')
		),
		layout:params-map()
	),
	layout:render-page(concat('/resource/views/',replace(xdmp:get-request-field('xview-url'),'#','/')))
	)