WITH facebook_data AS (
    SELECT
        a.ad_date,
        'facebook' AS media_source,
        a.spend
    FROM facebook_ads_basic_daily a
    JOIN facebook_adset s ON a.adset_id = s.adset_id
    JOIN facebook_campaign c ON a.campaign_id = c.campaign_id
),
google_data AS (
    SELECT
        ad_date,
        'google' AS media_source,
        spend
    FROM google_ads_basic_daily
),
combined AS (
    SELECT * FROM facebook_data
    UNION ALL
    SELECT * FROM google_data
)
SELECT
    ad_date,
    media_source,
    AVG(spend) AS avg_spend,
    MAX(spend) AS max_spend,
    MIN(spend) AS min_spend
FROM combined
GROUP BY ad_date, media_source
ORDER BY ad_date, media_source;