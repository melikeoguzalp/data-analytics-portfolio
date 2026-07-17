WITH combined_ads AS (
    SELECT
        fabd.ad_date,
        fabd.url_parameters,
        COALESCE(fabd.spend, 0)       AS spend,
        COALESCE(fabd.impressions, 0) AS impressions,
        COALESCE(fabd.reach, 0)       AS reach,
        COALESCE(fabd.clicks, 0)      AS clicks,
        COALESCE(fabd.leads, 0)       AS leads,
        COALESCE(fabd.value, 0)       AS value
    FROM facebook_ads_basic_daily fabd
    LEFT JOIN facebook_adset      fas ON fabd.adset_id    = fas.adset_id
    LEFT JOIN facebook_campaign   fc  ON fabd.campaign_id = fc.campaign_id
    UNION ALL
    SELECT
        gabd.ad_date,
        gabd.url_parameters,
        COALESCE(gabd.spend, 0),
        COALESCE(gabd.impressions, 0),
        COALESCE(gabd.reach, 0),
        COALESCE(gabd.clicks, 0),
        COALESCE(gabd.leads, 0),
        COALESCE(gabd.value, 0)
    FROM google_ads_basic_daily gabd
),
parsed AS (
    SELECT
        ad_date,
        CASE
            WHEN LOWER(SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)')) = 'nan'
            THEN NULL
            ELSE LOWER(SUBSTRING(url_parameters FROM 'utm_campaign=([^&]+)'))
        END AS utm_campaign,
        spend,
        impressions,
        reach,
        clicks,
        leads,
        value
    FROM combined_ads
)
SELECT
    ad_date,
    utm_campaign,
    SUM(spend)        AS total_spend,
    SUM(impressions)  AS total_impressions,
    SUM(clicks)       AS total_clicks,
    SUM(value)        AS total_value,
    CASE
        WHEN SUM(impressions) = 0 THEN 0
        ELSE ROUND(SUM(clicks)::NUMERIC / SUM(impressions), 4)
    END AS ctr,
    CASE
        WHEN SUM(clicks) = 0 THEN 0
        ELSE ROUND(SUM(spend)::NUMERIC / SUM(clicks), 2)
    END AS cpc,
    CASE
        WHEN SUM(impressions) = 0 THEN 0
        ELSE ROUND(SUM(spend)::NUMERIC / SUM(impressions) * 1000, 2)
    END AS cpm,
    CASE
        WHEN SUM(spend) = 0 THEN 0
        ELSE ROUND((SUM(value) - SUM(spend))::NUMERIC / SUM(spend), 4)
    END AS romi
FROM parsed
GROUP BY ad_date, utm_campaign
ORDER BY ad_date, utm_campaign;