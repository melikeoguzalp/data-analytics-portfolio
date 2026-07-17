WITH combined AS (
    SELECT ad_date, spend, value AS revenue
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT ad_date, spend, value AS revenue
    FROM google_ads_basic_daily
),
daily_totals AS (
    SELECT 
        ad_date,
        SUM(spend) AS total_spend,
        SUM(revenue) AS total_revenue
    FROM combined
    GROUP BY ad_date
)
SELECT 
    ad_date,
    total_spend,
    total_revenue,
    (total_revenue - total_spend) / NULLIF(total_spend::numeric, 0) AS romi
FROM daily_totals
ORDER BY romi DESC NULLS LAST, ad_date DESC
LIMIT 5;