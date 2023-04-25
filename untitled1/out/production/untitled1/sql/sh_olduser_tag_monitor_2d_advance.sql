drop table if exists dp_data_db.sh_olduser_tag_monitor_2d_advance;
create table dp_data_db.sh_olduser_tag_monitor_2d_advance USING orc as
select
substr(current_date(),1,10) as dt,
t1.Tag_Risk_Est_Bin,
t1.advance_cust_cnt,  --提前预估总户数
t2.cust_cnt,
t1.advance_cust_percent,
t2.cust_percent
from
(select
t1.Tag_Risk_Est_Bin,
count(distinct t1.cust_no) as advance_cust_cnt,
count(distinct t1.cust_no)/(select count(distinct cust_no) from dp_data_db.sh_olduser_tag_financing_channel_flag_monitor) as advance_cust_percent
from
dp_data_db.sh_olduser_tag_financing_channel_flag_monitor t1
group by 1) t1
left join
(select
t2.Tag_Risk_Est_Bin,
count(distinct t2.cust_no) as cust_cnt,
count(distinct t2.cust_no)/(select count(distinct cust_no) from dp_data_db.sh_olduser_tag_financing_channel_flag) as cust_percent
from
dp_data_db.sh_olduser_tag_financing_channel_flag t2
group by 1) t2
on t1.Tag_Risk_Est_Bin =t2.Tag_Risk_Est_Bin
order by 1;
