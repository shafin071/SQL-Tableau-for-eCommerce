

select ws.website_session_id, ws.device_type, o.order_id
from website_sessions ws
	 LEFT JOIN
     orders o
     ON ws.website_session_id = o.website_session_id
WHERE ws.created_at between '2014-01-01' AND '2015-01-01'
;


select ws.device_type,
       COUNT(distinct ws.website_session_id) as sessions,
       COUNT(o.order_id) as orders,
       COUNT(o.order_id) / COUNT(distinct ws.website_session_id) * 100 as conv_rate
from website_sessions ws
	 LEFT JOIN
     orders o
     ON ws.website_session_id = o.website_session_id
WHERE ws.created_at between '2014-01-01' AND '2015-01-01'
group by 1
;