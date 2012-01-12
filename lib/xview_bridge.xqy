xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";

declare variable $request-fields := map:map();

let $xview-url := xdmp:get-request-field('xview-url')
let $type := layout:type()
let $set-response-type := xdmp:set-response-content-type(if ($type eq 'html') then 'text/html' else fn:concat('application/',$type))
let $_ := fn:tokenize(fn:substring-after($xview-url,'?'),'&amp;')[map:put($request-fields, fn:substring-before(., '='),fn:substring-after(., '='))]
let $set-request-fields := layout:request-fields($request-fields)
let $target := if (fn:contains($xview-url,'?')) then fn:substring-before($xview-url,'?') else $xview-url
return layout:render-page($target)