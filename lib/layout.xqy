xquery version "1.0-ml" ;

(:~
 :
 : This module is used to mimic layout, yield, and content-for in Ruby on Rails
 :
 : @author Ryan Dew (ryan.j.dew@gmail.com)
 : @version 0.1
 :
 :)

module namespace layout = "/xFire/layout";

import module namespace search = "http://marklogic.com/appservices/search"
    at "/MarkLogic/appservices/search/search.xqy";

declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";
declare namespace ml-search = "http://marklogic.com/appservices/search";
declare namespace xfire-search = "/xFire/search";

(: Use the yield-map to track session fields to clear at the end of a request :)
declare variable $yield-map := map:map();
(: default layout for the application :)
declare variable $default-layout := '/resource/views/layouts/application';
declare variable $empty-doc := document {()};
declare variable $request-id := xdmp:request();


declare function content-for($area as xs:string, $content as item()*) {
	(: use the request id to avoid potential collisons:)
	let $key := fn:concat($area, '-', $request-id)
	let $_ := (map:put($yield-map, $key, ()),
			   xdmp:set-session-field($key, (xdmp:get-session-field($key),$content)))
	return ()
};

declare function yield($area as xs:string) {
	xdmp:get-session-field(fn:concat($area, '-', $request-id))
};

declare function content-body($content as item()*) {
	let $key := fn:concat('page-content-body-', $request-id)
	let $_ := (map:put($yield-map, $key, ()),
				xdmp:set-session-field($key, $content))
	return ()
};

declare function yield() {
	xdmp:get-session-field(fn:concat('page-content-body-', xdmp:request()))
};

declare function layout($layout-path as xs:string?) {
	let $key := fn:concat('layout-', $request-id)
	let $_ := (map:put($yield-map, $key, ()),
				xdmp:set-session-field($key, $layout-path))
	return ()
};

declare function layout() {
	let $val := xdmp:get-session-field(fn:concat('layout-', $request-id))
	return
	if ($val eq 'none')
	then $val
	else
		fn:concat(
			(xdmp:get-session-field(fn:concat('layout-', $request-id)),$default-layout)[1],
			'.',
			type(),
			'.xsl'
		)
};

declare function clear-session-fields() as empty-sequence() {
	for $k in map:keys($yield-map)
	return xdmp:set-session-field($k, ())
};

declare function type() as xs:string {
	let $key := fn:concat('render-type-', $request-id)
	let $cached-type := xdmp:get-session-field($key)
	return if (fn:exists($cached-type))
			then $cached-type
			else (map:put($yield-map, $key, ()),
					xdmp:set-session-field($key, 'html'))
};

declare function render-partial($target as xs:string) as node()? {
	render-partial($target, ())
};

declare function render-partial($target as xs:string, $transform-items as element()*) as node()? {
	xdmp:xslt-invoke(fn:concat($target,'.',type(),'.xsl'), document {$transform-items}, request-fields())
};

declare function render-page($target as xs:string) as node()? {
	render-page($target, ())
};

declare function render-page($target as xs:string, $items as node()*) as node()? {
	let $request-fields := request-fields()
	let $type := type()
	let $set-response-type := xdmp:set-response-content-type(if ($type eq 'html') then 'text/html' else fn:concat('application/',$type))
	let $query-xsl := fn:concat($target,'.query.xsl')
	let $doc := document {
				if (xdmp:uri-is-file($query-xsl)) 
				then 
					let $query := xdmp:xslt-invoke($query-xsl, $empty-doc, $request-fields)/*
					return 
						typeswitch($query)
						case element(*,cts:query) 
							return fn:doc(cts:uris('/', (), cts:query($query)))/*
						case element(xfire-search:search) 
							return search:search(xs:string($query/xfire-search:query), $query/ml-search:options, xs:unsignedLong($query/xfire-search:start), xs:unsignedLong($query/xfire-search:page-length))
						default return ()
				else (),
				$items
				}
	let $view-xsl := fn:concat($target,'.',$type,'.xsl')
	return 
		if (xdmp:uri-is-file($view-xsl))
		then 
			let $body := xdmp:xslt-invoke($view-xsl, $doc, $request-fields)
			let $layout := layout()
			return
			if ($layout eq 'none')
			then $body
			else
			(
				layout:content-body($body),
				xdmp:xslt-invoke($layout, $empty-doc, $request-fields),
				clear-session-fields()
			)
		else xdmp:redirect-response('/errror.xqy?reason=404')
};

declare function request-fields() as map:map? {
	xdmp:get-session-field(fn:concat('request-fields',$request-id))
};

declare function request-fields($request-fields as map:map?) as map:map? {
	let $key := fn:concat('request-fields',$request-id)
	return
	(map:put($yield-map, $key, ()),
	xdmp:set-session-field(fn:concat('request-fields',$request-id),$request-fields))
};