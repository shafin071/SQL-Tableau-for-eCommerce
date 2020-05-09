
-- First time billing-2 page was used
select MIN(website_pageview_id) from website_pageviews where pageview_url = '/billing-2' order by created_at;
select MIN(created_at) from website_pageviews where pageview_url = '/billing-2';

-- First use of billing-2 pageview ID: 53550
-- First use of billing-2 timestamp: 2012-09-09 22:13:05


-- show total sessions and revenue per billing page session for each billing page type for 2014
select o.created_at, wp.website_session_id, wp.pageview_url,
       CASE WHEN pageview_url = '/billing' then price_usd END AS billing_price,
       CASE WHEN pageview_url = '/billing-2' then price_usd END AS billing_2_price
from 
	website_pageviews wp
    JOIN
    orders o
	ON wp.website_session_id = o.website_session_id
where wp.pageview_url in ('/billing', '/billing-2')
      AND wp.created_at between '2012-03-01' AND '2013-01-01'
group by 2
;














