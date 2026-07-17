WITH ads_data AS (
    SELECT
        ad_date,
        'Facebook Ads' AS media_source,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT
	ad_date,
	'Google Ads' AS media_source,
	spend,
	impressions,
	0 AS reach,
	clicks,
	0 AS leads,
	value
FROM
	google_ads_basic_daily
)

SELECT
    ad_date,
    media_source,
    SUM(spend) AS total_cost,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS total_conversion_value
FROM ads_data
GROUP BY ad_date, media_source
ORDER BY ad_date, media_source;