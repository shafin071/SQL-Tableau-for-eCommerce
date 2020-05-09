
-- Show monthly session to order conversion rate and revenue per visitor

SELECT 
    ws.created_at,
    ws.website_session_id,
    o.order_id,
    o.price_usd AS 'Revenue',
    o.cogs_usd AS 'COGS',
    oir.price_usd AS 'Refund',
    CASE WHEN ws.http_referer is null and ws.utm_source is null then 'direct_type_in'
            WHEN ws.http_referer IN ('https://www.gsearch.com', 'https://www.bsearch.com') and ws.utm_source is null then 'organic_search'
            WHEN ws.utm_campaign = 'nonbrand' then 'paid_nonbrand'
            WHEN ws.utm_campaign = 'brand' then 'paid_brand'
            WHEN ws.utm_source = 'socialbook' then 'paid_social'
	   END AS channel_group
FROM
    website_sessions ws
	LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
    LEFT JOIN
    order_item_refunds oir
    ON o.order_id = oir.order_id
WHERE
    YEAR(ws.created_at) >= 2014 AND YEAR(ws.created_at) < 2015
;

