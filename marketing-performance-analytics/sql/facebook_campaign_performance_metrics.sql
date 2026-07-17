SELECT
	ad_date,
	campaign_id,
	SUM(spend) AS sum_spend,
	SUM(impressions) AS sum_impressions,
	SUM(clicks) AS sum_clicks,
	SUM(value) AS sum_value,

    ROUND(
        CAST(SUM(spend) AS numeric) / NULLIF(SUM(clicks), 0),
        2
    ) AS cpc,

    ROUND(
        CAST(SUM(spend) AS numeric) / NULLIF(SUM(impressions), 0) * 1000,
        2
    ) AS cpm,

    ROUND(
        CAST(SUM(clicks) AS numeric) / NULLIF(SUM(impressions), 0) * 100,
        2
    ) AS ctr_percent,

    ROUND(
        (CAST(SUM(value) AS numeric) - CAST(SUM(spend) AS numeric))
        / NULLIF(SUM(spend), 0) * 100,
        2
    ) AS romi_percent

FROM facebook_ads_basic_daily
GROUP BY
    ad_date,
    campaign_id;