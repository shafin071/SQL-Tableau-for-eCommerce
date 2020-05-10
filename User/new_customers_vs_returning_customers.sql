
-- Show monthly new users and returning users 
-- Revenue from new and repeat users shown on Tableau

SELECT ws.website_session_id, DATE(ws.created_at) AS 'date', ws.user_id, o.order_id, ws.is_repeat_session,
       o.price_usd,
       CASE WHEN ws.is_repeat_session = 0 then 1
          ELSE 0
	   END AS new_visitor,
       CASE WHEN ws.is_repeat_session = 1 then 1
          ELSE 0
	   END AS returning_visitor,
       CASE WHEN ws.http_referer is null and ws.utm_source is null then 'direct_type_in'
            WHEN ws.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') and ws.utm_source is null then 'organic_search'
            WHEN ws.utm_campaign = 'nonbrand' then 'paid_nonbrand'
            WHEN ws.utm_campaign = 'brand' then 'paid_brand'
            WHEN ws.utm_source = 'socialbook' then 'paid_social'
	   END AS channel_group
from website_sessions ws
     LEFT JOIN
     orders o
     ON ws.website_session_id = o.website_session_id
WHERE
    YEAR(ws.created_at) >= 2014 AND YEAR(ws.created_at) < 2015
;


