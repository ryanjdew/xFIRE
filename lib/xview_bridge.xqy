xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

layout:render-page(xdmp:get-request-field('xview-url'))