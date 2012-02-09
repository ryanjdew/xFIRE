xquery version "1.0-ml";
module namespace test = "http://github.com/robwhitby/xray/test";
import module namespace assert = "http://github.com/robwhitby/xray/assertions" at "/xray/src/assertions.xqy";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

declare function content-for-area()
{
  let $article-page := layout:render-page('/test/views/articles/article/index',
							<article>
							<title>My Sweet Title</title>
							<body/>
							</article>
						)
  return assert:equal(xs:string($article-page/html/head/title), "My Sweet Title")
};

declare function content-for-body()
{
  let $article-page := layout:render-page('/test/views/articles/article/index',
							<article>
							<title/>
							<body>My Body Text</body>
							</article>
						)
  return assert:equal(xs:string($article-page/html/body/div), "My Body Text")
};

declare function no-layout()
{
  let $article-page := layout:render-page('/test/views/articles/article/index-no-layout',
							<article>
							<title/>
							<body>My Body Text</body>
							</article>
						)
  return assert:equal(xs:string($article-page/div), "My Body Text")
};

declare function determine-format-parses-accept-header()
{
  let $format := layout:determine-format('application/json,application/javascript;q=0.9,*/*;q=0.8')
  return assert:equal($format, "json")
};

declare function determine-format-defaults-to-html()
{
  let $format := layout:determine-format('')
  return assert:equal($format, "html")
};