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

(: Use the yield-map to track session fields to clear at the end of a request :)
declare variable $yield-map := map:map();
declare variable $params-map := map:map();


declare function content-for($area as xs:string, $content as item()*) {
	map:put($yield-map,$area, (map:get($yield-map,$area),$content))
};

declare function content-exists-for($area as xs:string) {
	fn:exists(map:get($yield-map,$area))
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

declare function layout($layout-path as xs:string) {
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

declare function type() as xs:string {
	let $cached-type := map:get($yield-map, 'render-type')
	return if (fn:exists($cached-type))
			then $cached-type
			else 
				let $accept-header := xdmp:get-request-header('Accept')[1]
				let $type := determine-format(xdmp:get-request-header('Accept')[1])
				return (map:put($yield-map, 'render-type', $type),$type)
};

declare function determine-format($accept-header as xs:string) as xs:string {
	if (fn:matches($accept-header, '^[^/]+/([^,;]+)(,|;|$)'))
	then fn:substring-after(fn:tokenize(fn:tokenize($accept-header, ';')[1], ',')[1],'/')
	else 'html'
};

declare function render-partial($target as xs:string) as node()? {
	render-partial($target, ())
};

declare function render-partial(
	$target as xs:string, 
	$transform-items as element()*
) as node()? {
	render-partial($target, $transform-items, params-map())
};

declare function render-partial(
	$target as xs:string, 
	$transform-items as element()*,
	$params as map:map?
) as node()? {
	xdmp:xslt-invoke(
		fn:concat($target,'.',type(),'.xsl'), 
		document {$transform-items},
		$params[
			fn:distinct-values((map:keys(.),map:keys(params-map())))[
				if (fn:empty(map:get($params,.))) then map:put($params,.,map:get(params-map(),.)) else ()
			],
			fn:true()
		]
	)
};

declare function render-page($target as xs:string) as node()? {
	render-page($target, ())
};

declare function render-page(
	$target as xs:string, 
	$items as node()*
) as node()? {
	render-page(
		$target, 
		$items, 
		type(),
		fn:concat($target,'.query.xsl'),
		fn:concat($target,'.',type(),'.xsl')
	) 
};

declare function render-page(
	$target as xs:string, 
	$items as node()*, 
	$type as xs:string,
	$query-xsl as xs:string,
	$view-xsl as xs:string
) as node()? {

	xdmp:set-response-content-type(
		if ($type eq 'html') then 'text/html' else fn:concat('application/',$type)
	),
	if (xdmp:uri-is-file($view-xsl))
	then 
		let $body := render-partial(
						$target, 
						(if (xdmp:uri-is-file($query-xsl)) 
						then 
							let $query := xdmp:xslt-invoke($query-xsl, $empty-doc, params-map())/*
							return 
								typeswitch($query)
								case element(*,cts:query) 
									return fn:doc(cts:uris('/', (), cts:query($query)))/*
								case element(xfire-search:search) 
									return 
										search:search( 
											xs:string($query/xfire-search:query), 
											$query/ml-search:options, 
											xs:unsignedLong($query/xfire-search:start), 
											xs:unsignedLong( 	
												$query/xfire-search:page-length
											)
										)
								default return ()
						else (),
						$items)),
			$layout := layout()
		return
			if ($layout eq 'none')
			then $body
			else
			(
				layout:content-body($body),
				xdmp:xslt-invoke($layout, $empty-doc, params-map())
			)
	else if ($target ne '/resource/views/error') 
	then 
		render-page('/resource/views/error', element response {
			element code {"404"},
			element message {"Not Found"}
		})
	else ()
};

declare function params-map() as map:map? {
	$params-map[map:put(.,'yield-map',$yield-map),fn:true()]
};