xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

declare namespace error = "http://marklogic.com/xdmp/error";

declare variable $error:errors as element(error:error)* external;

let $results := (
					try {
						if (fn:exists($error:errors))
						then xdmp:set-response-code(500,"Internal Server Error")
						else xdmp:set-response-code(404,"Not Found")
					} catch ($e) {
						xdmp:set-response-code(404,"Not Found")
					},
					let $errorResponseCode := xdmp:get-response-code()
					return element response {
							element code {
							$errorResponseCode[1]
							},
							element message {
							$errorResponseCode[2]
							}
					}
				)
return layout:render-page('/resource/views/error',$results)