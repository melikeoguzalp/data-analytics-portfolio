WITH fb_named AS (
    SELECT 
        c.campaign_name,
        a.ad_date,
        a.reach
    FROM facebook_ads_basic_daily a
    JOIN facebook_campaign c ON a.campaign_id = c.campaign_id
),
combined AS (
    SELECT campaign_name, ad_date, reach FROM fb_named

    UNION ALL

    SELECT campaign_name, ad_date, reach FROM google_ads_basic_daily
),
monthly_totals AS (
    SELECT 
        campaign_name,
        DATE_TRUNC('month', ad_date) AS month,
        SUM(reach) AS monthly_reach
    FROM combined
    GROUP BY campaign_name, DATE_TRUNC('month', ad_date)
),
with_growth AS (
    SELECT 
        campaign_name,
        month,
        monthly_reach,
        LAG(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY month) AS prev_month_reach,
        monthly_reach - LAG(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY month) AS reach_growth
    FROM monthly_totals
)
SELECT 
    campaign_name,
    month,
    monthly_reach,
    prev_month_reach,
    reach_growth
FROM with_growth
ORDER BY reach_growth DESC NULLS LAST
LIMIT 1;