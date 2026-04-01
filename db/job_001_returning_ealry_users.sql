--SELECT * FROM  account_subscription_activity;


select 
region,
account_id,
new_tier,
upgrade_date,
post_upgrade_active_days,
max_upgrade_date,
(max_upgrade_date - INTERVAL '90 day')  as test
from(
SELECT region,
       account_id,
       previous_tier,
       new_tier,
      upgrade_date,
      post_upgrade_active_days,
       max(upgrade_date) over() as max_upgrade_date,
       row_number() over(partition by region, previous_tier, new_tier order by post_upgrade_active_days desc) as rn
 FROM account_subscription_activity

) as sb 
where post_upgrade_active_days >= 20
and sb.previous_tier ='STANDARD' 
and new_tier in ('PREMIUM', 'ENTERPRISE')
and upgrade_date BETWEEN (max_upgrade_date - INTERVAL '90 day') AND max_upgrade_date
AND  sb.rn <= 3
