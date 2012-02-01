xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";

declare variable $request-fields := map:map();

let $xview-url := xdmp:get-request-field('xview-url')
let $_ := xdmp:get-request-field-names()[map:put($request-fields, .,xdmp:get-request-field(.))]
let $set-request-fields := layout:request-fields($request-fields)
return layout:render-page($xview-url)