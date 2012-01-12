xquery version "1.0-ml";

declare namespace error = "http://marklogic.com/xdmp/error";

declare variable $error:errors as element(error:error)* external;

let $errorResponseCode := xdmp:get-response-code()
let $format := xdmp:get-request-field( "outputFormat", "xml" )[1]
let $contentType := if ($format eq "json") then ( "application/json" ) else ( "application/xml" )
let $query := xdmp:get-request-field("query", "")
let $results := (
					xdmp:set-response-content-type($contentType),
					try {
						if (fn:exists($error:errors))
						then xdmp:set-response-code(500,"Internal Server Error")
						else xdmp:set-response-code(404,"Not Found")
					} catch ($e) {
						xdmp:set-response-code(404,"Not Found")
					},
					let $errorResponseCode := xdmp:get-response-code()
					return element result {
							element code {
							$errorResponseCode[1]
							},
							element message {
							$errorResponseCode[2]
							},
							element error {
								if ($errorResponseCode[1] eq 404)
								then "Page not found."
								else "An error occurred while.  Please notify an administrator with the date and time you received this error."
							},
							element errorDetail {
								$error:errors
							}
					}
				)
return $results