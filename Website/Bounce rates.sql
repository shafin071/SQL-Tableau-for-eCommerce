

-- find the first website_pageview_id for all 2014 sessions

drop temporary table if exists first_pageviews_demo;
 
create temporary table first_pageviews_demo
SELECT
	wp.website_session_id,
    MIN(wp.website_pageview_id) as min_pageview_id
FROM 
	website_pageviews wp
    inner join
    website_sessions ws
    ON wp.website_session_id = ws.website_session_id
WHERE ws.created_at between '2014-01-01' AND '2015-01-01'
GROUP BY wp.website_session_id
;

SELECT * from first_pageviews_demo;

# ---------------------------------------------------------------------------------------------------------------------------

-- indentify the landing page of each session

drop temporary table if exists sessions_w_landing_page_demo;


create temporary table sessions_w_landing_page_demo
SELECT
	fpd.website_session_id,
	wp.pageview_url
from
	first_pageviews_demo fpd
    JOIN
    website_pageviews wp
    ON
    fpd.min_pageview_id = wp.website_pageview_id
;
    
SELECT * from sessions_w_landing_page_demo;

# --------------------------------------------------------------------------------------------------------------------

-- counting pageviews for each session, to identify "bounces"

drop temporary table if exists bounced_sessions_only;

create temporary table bounced_sessions_only
SELECT
	wp.website_session_id,
    wp.pageview_url as landing_page,
    count(distinct wp.website_pageview_id) as count_of_pages_viewed
FROM
	sessions_w_landing_page_demo slpd
    JOIN
    website_pageviews wp
    ON 
    slpd.website_session_id = wp.website_session_id
group by wp.website_session_id
having count_of_pages_viewed = 1
    ;

SELECT * from bounced_sessions_only;


# -----------------------------------------------------------------------------------------------------------------------

-- summarizing session ids from sessions_w_landing_page_demo and bounced_sessions_only

SELECT
	slpd.pageview_url as landing_page,
    slpd.website_session_id,
    bs.website_session_id AS bounced_website_session_id
FROM
	sessions_w_landing_page_demo slpd
    LEFT JOIN
    bounced_sessions_only bs
    ON slpd.website_session_id = bs.website_session_id
group by slpd.website_session_id
;


-- summarizing total sessions and bounced sessions by landing page

SELECT
	slpd.pageview_url as landing_page,
    COUNT(distinct slpd.website_session_id) AS total_website_session,
    COUNT(distinct bs.website_session_id) AS bounced_website_session,
    COUNT(distinct bs.website_session_id) / COUNT(distinct slpd.website_session_id) * 100 AS bounce_rate
FROM
	sessions_w_landing_page_demo slpd
    LEFT JOIN
    bounced_sessions_only bs
    ON slpd.website_session_id = bs.website_session_id
group by slpd.pageview_url
;
	








