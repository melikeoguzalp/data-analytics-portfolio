WITH facebook_enriched AS (
    SELECT
        fabd.ad_date,
        fc.campaign_name,
        fa.adset_name,
        fabd.spend,
        fabd.impressions,
        fabd.reach,
        fabd.clicks,
        fabd.leads,
        fabd.value
    FROM facebook_ads_basic_daily fabd
    LEFT JOIN facebook_campaign fc
        ON fabd.campaign_id = fc.campaign_id
    LEFT JOIN facebook_adset fa
        ON fabd.adset_id = fa.adset_id
),

all_ads AS (
    SELECT
        ad_date,
        'Facebook Ads' AS media_source,
        campaign_name,
        adset_name,
        spend,
        impressions,
        clicks,
        value
    FROM facebook_enriched

    UNION ALL

    SELECT
        ad_date,
        'Google Ads' AS media_source,
        NULL AS campaign_name,
        NULL AS adset_name,
        spend,
        impressions,
        clicks,
        value
    FROM google_ads_basic_daily
)

SELECT
    ad_date,
    media_source,
    campaign_name,
    adset_name,
    SUM(spend) AS total_cost,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(value) AS total_conversion_value
FROM all_ads
GROUP BY
    ad_date,
    media_source,
    campaign_name,
    adset_name
ORDER BY
    ad_date,
    media_source,
    campaign_name,
    adset_name;