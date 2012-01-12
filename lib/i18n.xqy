xquery version "1.0-ml" ;

(:~
 :
 : This module facilitates having translated strings for your MarkLogic xQuery app.
 : Each of the public functions have an optional $directory parameter at the beginning
 : if your application would want to restrict queries and bundle inserts by directory. 
 :
 : @author Ryan Dew (ryan.j.dew@gmail.com)
 : @version 0.1
 :
 :)

 module namespace i18n = "/xFire/i18n";

declare namespace map = "http://marklogic.com/xdmp/map";

declare variable $key-map as map:map := map:map();

declare function i18n-bundle-entry($locale as xs:string, $bundle as xs:string, $key as xs:string) as item()* {
	i18n-bundle-entry("/", $locale, $bundle, $key)
};

(: get the translated bundle entry :)
declare function i18n-bundle-entry($directory as xs:string, $locale as xs:string, $bundle as xs:string, $key as xs:string) as item()* {
	map:get(load-i18n-bundle($directory, $locale, $bundle), $key)
};

declare function add-entry-to-i18n-bundle($locale as xs:string, $bundle as xs:string, $key as xs:string, $value as item()*) as empty-sequence() {
	add-entry-to-i18n-bundle("/", $locale, $bundle, $key, $value)
};
(:
This function adds an entry to a bundle. It also will handle creating the bundle if it doesn't exist.
:)
declare function add-entry-to-i18n-bundle($directory as xs:string, $locale as xs:string, $bundle as xs:string, $key as xs:string, $value as item()*) as empty-sequence() {
	(: Add entries inside an eval statement so we can add entries even if we just
		created the bundle :)
	xdmp:eval("xquery version '1.0-ml';
		import module namespace i18n = '/xFire/i18n' at '/lib/i18n.xqy';
		declare variable $directory as xs:string external;
		declare variable $locale as xs:string external;
		declare variable $bundle as xs:string external;
		(: This transaction ensures the bundle is inserted in the database :)
		let $bundle := i18n:i18n-bundle($directory, $locale, $bundle)
		return ()
		;
		xquery version '1.0-ml';
		import module namespace i18n = '/xFire/i18n' at '/lib/i18n.xqy';
		declare variable $directory as xs:string external;
		declare variable $locale as xs:string external;
		declare variable $bundle as xs:string external;
		declare variable $key as xs:string external;
		declare variable $value as item()* external;
		(: This transaction adds the entry :)
		let $i18n-bundle as element(i18n)? := i18n:i18n-bundle($directory, $locale, $bundle)
		let $map as map:map? := map:map($i18n-bundle/map:map)
		let $insert as empty-sequence() := map:put($map, $key, $value)
		return xdmp:node-replace($i18n-bundle/map:map, element e{$map}/map:map)",
		(xs:QName('directory'),$directory,xs:QName('locale'), $locale, xs:QName('bundle'), $bundle, xs:QName('key'), $key, xs:QName('value'), $value),
		<options xmlns="xdmp:eval">
      <isolation>different-transaction</isolation>
	  <prevent-deadlocks>true</prevent-deadlocks>
    </options>)
};

declare function i18n-bundle($locale as xs:string, $bundle as xs:string) as element(i18n)? {
	i18n-bundle("/", $locale, $bundle)
};

(:
This finds an i18n bundle and creates one if it doesn't exist. It always returns an i18n element with a map:map
so we don't keep trying to load a bundle that doesn't exist in load-i18n-bundle
:)
declare function i18n-bundle($directory as xs:string, $locale as xs:string, $bundle as xs:string) as element(i18n)? {
	let $i18n-bundle as element(i18n)? := 
								cts:search(/i18n[@locale eq $locale and @id eq $bundle],
								cts:directory-query($directory,'infinity'),
								'unfiltered'
							)
	return 	if (fn:exists($i18n-bundle)) 
			then $i18n-bundle
			else
				let $new-bundle := 
					element i18n {
						attribute id {$bundle},
						attribute locale {$locale},
						map:map()
					}
				return (
					xdmp:document-insert(fn:concat($directory,'i18n/',$locale,'/',$bundle,'.xml'),
						$new-bundle,
						xdmp:default-permissions()
					),
					$new-bundle
				)
};

declare function load-i18n-bundle($locale as xs:string, $bundle as xs:string) as map:map {
	load-i18n-bundle('/', $locale, $bundle)
};
(: This loads a bundle into memory. :)
declare function load-i18n-bundle($directory as xs:string, $locale as xs:string, $bundle as xs:string) as map:map {
	(: Calculate the key for the bundle which changes with every update to the bundle :)
	let $base-key := fn:concat('/resources',$directory,$locale,'/',$bundle,'/')
	let $cur-key := bundle-key($directory,$locale,$bundle,$base-key)
	(: Try to retrieve bundle from memory. :)
	let $bundle-map as map:map? := xdmp:get-server-field($cur-key)
	return
	(: If it exists in memory return it. :)
	if (fn:exists($bundle-map)) 
	then $bundle-map
	(: Otherwise load it. :)
    else (
		(: get the prevoius key for this bundle. :)
		let $prev-key :=  xdmp:get-server-field(fn:concat($base-key,'prev'))
		(: if a previous key exists, clear out the old value to avoid memory build up. :)
		let $clear-prev := if (fn:exists($prev-key)) then xdmp:set-server-field($prev-key, ()) else ()
		(: Store this key as the previous key for next time. :)
		let $set-prev-key :=  xdmp:set-server-field(fn:concat($base-key,'prev'), $cur-key)
		return xdmp:set-server-field($cur-key,map:map(i18n-bundle($directory, $locale, $bundle)/map:map))
     )
};

(: get the key for a bundle :)
declare private function bundle-key($directory as xs:string,$locale,$bundle as xs:string,$base-key as xs:string) as xs:string {
	(: see if key already generated and stored in $key-map :)
	let $cached-key := map:get($key-map,$base-key)
	return 
		if (fn:exists($cached-key))
		then $cached-key
		else
			(: if not get the last-modified property of the bundle for the key :)
			let $bundle-uri := cts:uris($directory,('limit=1'), 
								cts:and-query((
									cts:element-query(
										xs:QName('i18n'),
										cts:and-query((
											cts:element-attribute-value-query(xs:QName('i18n'),xs:QName('locale'), $locale, 'exact'),
											cts:element-attribute-value-query(xs:QName('i18n'),xs:QName('id'), $bundle, 'exact')
										))
									),
									cts:directory-query($directory,'infinity')
								))
						)
			let $key := fn:concat($base-key,xdmp:document-get-properties($bundle-uri, xs:QName("prop:last-modified")))
			(: store the result in $key-map since getting the last-modified is a little expensive and the
				last-modified should never change mid-transaction. last-modified should be found only once
				per bundle, per transaction. :)
			return (map:put($key-map,$base-key, $key),$key)
};