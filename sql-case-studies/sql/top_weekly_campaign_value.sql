WITH fb_named AS (
    SELECT 
        c.campaign_name,
        a.ad_date,
        a.value
    FROM facebook_ads_basic_daily a
    JOIN facebook_campaign c ON a.campaign_id = c.campaign_id
),
combined AS (
    SELECT campaign_name, ad_date, value FROM fb_named

    UNION ALL

    SELECT campaign_name, ad_date, value FROM google_ads_basic_daily
),
weekly_campaign_totals AS (
    SELECT 
        campaign_name,
        DATE_TRUNC('week', ad_date) AS week_start,
        SUM(value) AS weekly_value
    FROM combined
    GROUP BY campaign_name, DATE_TRUNC('week', ad_date)
)
SELECT 
    campaign_name,
    week_start,
    weekly_value
FROM weekly_campaign_totals
ORDER BY weekly_value DESC
LIMIT 1;