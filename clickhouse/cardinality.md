select count(*) from system.parts where table = 'downloads'; -- 223
select count(*) from system.parts where table = 'impressions'; -- 14
select count(*) from system.parts where table = 'match_rates'; -- 1

select table, count(*) from system.parts group by table order by count(*) desc;
select date, count(*) from downloads group by date order by count(*) desc;

-- column cardinalities
select formatreadablequantity(uniq(tracked_url_id)) as cardinality_tracked_url_id
formatreadablequantity(uniq(household_id)) as cardinality_household_id,
    formatreadablequantity(uniq(full_ip_address)) as cardinality_full_ip_address,
    formatreadablequantity(uniq(time_stamp)) as cardinality_time_stamp,
    formatreadablequantity(uniq(episode_id)) as cardinality_episode_id from downloads;
