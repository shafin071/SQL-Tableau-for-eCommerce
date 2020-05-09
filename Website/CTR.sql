
-- Prepare full 2014 conversion funnel for Tableau

drop temporary table if exists pages_visited;

create temporary table pages_visited
select 
	ws.website_session_id,
    ws.created_at,
    wp.pageview_url,
    CASE WHEN wp.pageview_url IN ('/home', '/lander-2', '/lander-3', '/lander-4', '/lander-5') THEN 'lander/home page' 
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
group by page_visited
order by visit_count desc
;

select * from pages_visited;











