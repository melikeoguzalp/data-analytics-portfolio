WITH fb_named AS (
    SELECT 
        s.adset_name,
        a.ad_date
    FROM facebook_ads_basic_daily a
    JOIN facebook_adset s ON a.adset_id = s.adset_id
),
combined AS (
    SELECT DISTINCT adset_name, ad_date FROM fb_named

    UNION

    SELECT DISTINCT adset_name, ad_date FROM google_ads_basic_daily
),
numbered AS (
    SELECT 
        adset_name,
        ad_date,
        ROW_NUMBER() OVER (PARTITION BY adset_name ORDER BY ad_date) AS rn
    FROM combined
),
grouped AS (
    SELECT 
        adset_name,
        ad_date,
        ad_date - (rn * INTERVAL '1 day') AS island_id
    FROM numbered
),
streaks AS (
    SELECT 
        adset_name,
        island_id,
        MIN(ad_date) AS streak_start,
        MAX(ad_date) AS streak_end,
        COUNT(*) AS streak_length
    FROM grouped
    GROUP BY adset_name, island_id
)
SELECT 
    adset_name,
    streak_start,
    streak_end,
    streak_length
FROM streaks
ORDER BY streak_length DESC
LIMIT 1;