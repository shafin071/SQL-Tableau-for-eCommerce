
-- Find all webpages present in mobile app

select distinct wp.pageview_url
from website_sessions ws
     JOIN
     website_pageviews wp
     ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at between '2014-01-01' AND '2015-01-01'
      AND ws.device_type = 'mobile'
;


-- Get page visit count for all app pages
drop temporary table if exists app_pages_visited;

create temporary table app_pages_visited
select 
	ws.website_session_id,
    ws.created_at,
    wp.pageview_url,
    CASE WHEN wp.pageview_url IN ('/home', '/lander-3') THEN 'lander/home page' 
         WHEN wp.pageview_url = '/products' THEN 'products list' 
	     WHEN wp.pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') THEN 'product_item'
	     WHEN wp.pageview_url = '/cart' THEN 'cart' 
         WHEN wp.pageview_url = '/shipping' THEN 'shipping' 
	     WHEN wp.pageview_url = '/billing-2' THEN 'billing'
	     WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 'order complete' 
	END AS page_visited,
    COUNT(distinct ws.website_session_id) as visit_count
from website_sessions ws
	 JOIN
     website_pageviews wp
     ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at between '2014-01-01' AND '2015-01-01'
      AND ws.device_type = 'mobile'
group by page_visited
order by visit_count desc
;


select * from app_pages_visited;


-- Calculate CTR for App
select pv2.pageview_url as next_url, pv2.page_visited as next_page, pv2.visit_count as next_visit_count,
       Max(CASE WHEN pv1.page_visited = 'lander/home page' AND pv2.page_visited = 'lander/home page' then pv2.visit_count / pv1.visit_count * 100
			WHEN pv2.page_visited = 'products list' AND pv1.page_visited = 'lander/home page' then pv2.visit_count / pv1.visit_count * 100 
            WHEN pv2.page_visited = 'product_item' AND pv1.page_visited = 'products list' then pv2.visit_count / pv1.visit_count * 100
            WHEN pv2.page_visited = 'cart' AND pv1.page_visited = 'product_item' then pv2.visit_count / pv1.visit_count * 100
            WHEN pv2.page_visited = 'shipping' AND pv1.page_visited = 'cart' then pv2.visit_count / pv1.visit_count * 100
            WHEN pv2.page_visited = 'billing' AND pv1.page_visited = 'shipping' then pv2.visit_count / pv1.visit_count * 100
            WHEN pv2.page_visited = 'order complete' AND pv1.page_visited = 'billing' then pv2.visit_count / pv1.visit_count * 100
	   END) as conv_rate
from app_pages_visited pv1
     JOIN
     (
		select 
			ws.website_session_id,
			ws.created_at,
			wp.pageview_url,
			CASE WHEN wp.pageview_url IN ('/home', '/lander-3') THEN 'lander/home page' 
				 WHEN wp.pageview_url = '/products' THEN 'products list' 
				 WHEN wp.pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') THEN 'product_item'
				 WHEN wp.pageview_url = '/cart' THEN 'cart' 
				 WHEN wp.pageview_url = '/shipping' THEN 'shipping' 
				 WHEN wp.pageview_url = '/billing-2' THEN 'billing'
				 WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 'order complete' 
			END AS page_visited,
			COUNT(distinct ws.website_session_id) as visit_count
		from website_sessions ws
			 JOIN
			 website_pageviews wp
			 ON ws.website_session_id = wp.website_session_id
		WHERE ws.created_at between '2014-01-01' AND '2015-01-01'
			  AND ws.device_type = 'mobile'
		group by page_visited
		order by visit_count desc
     ) pv2
group by pv2.page_visited
;

