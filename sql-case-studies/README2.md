# SQL Case Studies — Advertising Data

**SQL · PostgreSQL · Window Functions · BigQuery**

Short analytical SQL exercises on daily Facebook Ads and Google Ads data (`facebook_ads_basic_daily`, `facebook_campaign`, `facebook_adset`, `google_ads_basic_daily`). Each query answers one business question.

| Query | Business question | Key technique |
| --- | --- | --- |
| [`daily_average_spend_by_media_source.sql`](sql/daily_average_spend_by_media_source.sql) | What are the daily average, maximum, and minimum spend per media source? | `UNION ALL`, aggregation |
| [`top_daily_romi.sql`](sql/top_daily_romi.sql) | Which 5 days had the highest ROMI across both platforms? | Ratio of sums, `NULLIF` |
| [`top_weekly_campaign_value.sql`](sql/top_weekly_campaign_value.sql) | Which campaign generated the highest conversion value in a single week? | `DATE_TRUNC('week')` |
| [`monthly_campaign_reach_growth.sql`](sql/monthly_campaign_reach_growth.sql) | Which campaign had the largest month-over-month increase in reach? | `LAG()` window function |
| [`longest_adset_active_streak.sql`](sql/longest_adset_active_streak.sql) | Which ad set ran for the longest unbroken streak of days? | Gaps-and-islands with `ROW_NUMBER()` |

BigQuery saved queries: see [`bigquery/links.md`](bigquery/links.md).
