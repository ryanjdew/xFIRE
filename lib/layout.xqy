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

(: default layout for the application :)
declare variable $default-layout := '/resource/views/layouts/application';
declare variable $empty-doc := document {()};
declare variable $request-id := xdmp:request();

declare variable $yield-file-location := fn:concat('/request/',$request-id,'.xml');
(: Use the yield-map to track session fields to clear at the end of a request :)
declare variable $yield-map := map:map();


declare function content-for($area as xs:string, $content as item()*) {
	map:put($yield-map,$area, (map:get($yield-map,$area),$content))
};

declare function yield-map($ym as map:map) {
	xdmp:set($yield-map,$ym)
};

declare function yield-map() {
	$yield-map
};

declare function yield($area as xs:string) {
	map:get($yield-map,$area)
};

declare function content-body($content as item()*) {
	map:put($yield-map,'page-content-body', $content)
};

declare function yield() {
	map:get($yield-map,'page-content-body')
};

declare function layout($layout-path as xs:string?) {
	map:put($yield-map, 'layout', $layout-path)
};

declare function layout() {
	let $val := map:get($yield-map, 'layout') 
	return
	if ($val eq 'none')
	then $val
	else
		fn:concat(
			($val,$default-layout)[1],
			'.',
			type(),
			'.xsl'
		)
};

declare function clear-session-fields() as empty-sequence() {
	xdmp:spawn('/lib/delete-request.xqy', (xs:QName('request-id'),$request-id))
};

declare function type() as xs:string {
	let $cached-type := map:get($yield-map, 'render-type')
	return if (fn:exists($cached-type))
			then $cached-type
			else (map:put($yield-map, 'render-type', 'html'),'html')
};

declare function render-partial($target as xs:string) as node()? {
	render-partial($target, ())
};

declare function render-partial($target as xs:string, $transform-items as element()*) as node()? {
	xdmp:eval('xquery version "1.0-ml";
	declare variable $request-id as xs:unsignedLong external;
	declare variable $yield-map as map:map external;
	declare variable $yield-file-location := fn:concat("/request/",$request-id,".xml");

	xdmp:document-insert($yield-file-location,element e {$yield-map}/*,xdmp:default-permissions(), 
	         xdmp:default-collections())',(xs:QName('yield-map'),$yield-map,xs:QName('request-id'),$request-id)),
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
	map:get($yield-map,'request-fields')
};

declare function request-fields($request-fields as map:map?) as map:map? {
	map:put($yield-map, 'request-fields', $request-fields)
};