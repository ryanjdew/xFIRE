xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

declare namespace error = "http://marklogic.com/xdmp/error";

declare variable $error:errors as element(error:error)* external;

declare function local:build-response($code as xs:integer, $message as xs:string) {
	element response {
		element code {
			$code
		},
		element message {
			$message
		}
	}
}

let $results := 
					try {
						if (fn:exists($error:errors))
						then local:build-response(500,"Internal Server Error")
						else local:build-response(404,"Not Found")
					} catch ($e) {
						local:build-response(404,"Not Found")
					}

return layout:render-page('/resource/views/error',$results)