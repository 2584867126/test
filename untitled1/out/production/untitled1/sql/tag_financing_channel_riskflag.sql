drop table if exists dp_data_db.tag_financing_channel_riskflag;
create table dp_data_db.tag_financing_channel_riskflag as
select row_number() over (order by 1) as id,
cust_no,user_no,product_code,contract_no,cust_seg,tag_risk_est_bin
,current_date() as dt
from (select cust_no,user_no,product_code,contract_no,cust_seg,tag_risk_est_bin,dt
from dp_data_db.jt_tag_financing_channel_flag --jietiao
union all
select cust_no,user_no,product_code,contract_no,cust_seg,tag_risk_est_bin,dt
from fin_ads_xxzzl.tag_financing_channel_riskflag_plus --plus
union all
select cust_no,user_no,product_code,contract_no,cust_seg,tag_risk_est_bin,dt from dp_data_db.sme_tag_financing_channel_riskflag --sme
union all
select cust_no,user_no,product_code,contract_no,cust_seg,tag_risk_est_bin,dt
from dp_data_db.tag_financing_channel_riskflag_for_360big_zxd --big
where dt= current_date()
) a;

-- dfs -touchz /home/hdp-loan/hive/warehouse/dp_data_db.db/tag_financing_channel_riskflag/_DONE;


drop table if exists dp_data_db.jt_tag_financing_channel_flag;
create table dp_data_db.jt_tag_financing_channel_flag as
select a.*
from (select t1.cust_no,t1.user_no,t1.product_code,t1.contract_no
,case when t1.product_code="360YINGJI" then t2.cust_seg
when t1.product_code="360JIETIAO" and date_diff<=90 and t6.cust_seg="apinew" then t6.cust_seg
when t1.product_code="360JIETIAO" and date_diff<=90 and t4.cust_seg="bjnew" then t4.cust_seg
when t1.product_code="360JIETIAO" and date_diff<=90 and t2.cust_seg is not null then t2.cust_seg
when t1.product_code="360JIETIAO" and date_diff<=90 and t2.cust_seg is null then ""
when t1.product_code="360JIETIAO" and date_diff>90 and t5.cust_seg="apiold" then t5.cust_seg
when t1.product_code="360JIETIAO" and date_diff>90 and t4.cust_seg="bjold" then t4.cust_seg
when t1.product_code="360JIETIAO" and date_diff>90 and t3.cust_seg is not null then t3.cust_seg
else "other" end as cust_seg
,case when t1.product_code="360YINGJI" then t2.tag_risk_est_bin
when t1.product_code="360JIETIAO" and date_diff<=90 and t6.cust_seg="apinew" then t6.tag_risk_est_bin
when t1.product_code="360JIETIAO" and date_diff<=90 and t4.cust_seg="bjnew" then t4.tag_risk_est_bin
when t1.product_code="360JIETIAO" and date_diff<=90 and t2.tag_risk_est_bin is not null then t2.tag_risk_est_bin
when t1.product_code="360JIETIAO" and date_diff<=90 and t2.tag_risk_est_bin is null then "R100"
when t1.product_code="360JIETIAO" and date_diff>90 and t5.cust_seg="apiold" then t5.tag_risk_est_bin
when t1.product_code="360JIETIAO" and date_diff>90 and t4.cust_seg="bjold" then t4.tag_risk_est_bin
when t1.product_code="360JIETIAO" and date_diff>90 and t3.cust_seg is not null then t3.tag_risk_est_bin
else "R100" end as tag_risk_est_bin
,current_date as dt
from (select *
    ,case when date_finished is null or date_finished in ("NULL","null") then 0 else datediff(current_date,to_date(date_finished)) end as date_diff
    from dp_data_db.gfy_tot_cust_product_code
    where product_code in ("360JIETIAO","360YINGJI")) t1
left join dp_data_db.sh_newuser_tag_financing_channel_flag t2 --xinhu
on t1.cust_no = t2.cust_no and t1.product_code = t2.product_code
left join dp_data_db.sh_olduser_tag_financing_channel_flag t3-- laohu
on t1.cust_no = t3.cust_no and t1.product_code = t3.product_code
left join dp_data_db.bj_olduser_tag_financing_channel_flag t4 --bjlaohu
on t1.cust_no = t4.cust_no and t1.product_code = t4.product_code
left join dp_data_db.api_olduser_tag_financing_channel_flag t5 --apilaohu
on t1.cust_no = t5.cust_no and t1.product_code = t5.product_code
left join dp_data_db.api_newuser_tag_financing_channel_flag t6 --apinew
on t1.cust_no = t6.cust_no and t1.product_code = t6.product_code) a
where tag_risk_est_bin is not null;
;


----处理标签
drop table if exists dp_data_db.sh_olduser_tag_financing_channel_flag;
create table dp_data_db.sh_olduser_tag_financing_channel_flag as
select
a.cust_no,
a.user_no,
'360JIETIAO' as product_code,
a.contract_no,
case
     when a.apply_mob<=90 then 'shnew' else 'shold' end as cust_seg,
case
----mob3-客群标签适配
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=1 then 'R101'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=2 then 'R102'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=3 then 'R103'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=4 then 'R103'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=5 then 'R103'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=6 then 'R106'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=7 then 'R107'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=8 then 'R108'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=9 then 'R109'
when a.apply_mob<=90 and  right(a.Tag_Risk_Est_Bin,1)=0 then 'R100'
when a.apply_mob<=90 and  (a.Tag_Risk_Est_Bin is null or a.Tag_Risk_Est_Bin in ('','null','NULL')) then 'R103' --兜底使用，理论上MOB3-贷前客户应该取自己的标

----特殊情况处理
when a.apply_mob> 90 and  a.special_price_flag =1 and a.custlevel_bin = 'P1' then 'R41'
when a.apply_mob> 90 and  a.special_price_flag =1 and a.custlevel_bin = 'P2' then 'R42'
when a.apply_mob> 90 and  a.special_price_flag =1 and a.custlevel_bin = 'P3' then 'R43'
when a.apply_mob> 90 and  a.special_price_flag =1 and a.custlevel_bin = 'P4' then 'R44'
when a.apply_mob> 90 and  a.special_price_flag =1 and a.custlevel_bin = 'P5' then 'R45'
when a.apply_mob> 90 and  a.311_flag=1 then 'R48'
when a.contract_no in ('6293984940591689729','5841688697367453696','6015569265770446848') then 'R43'

----评分打标
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0011645661 then 'R41'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0019919085 then 'R42'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0029098657 then 'R43'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0039902688 then 'R44'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0053218715 then 'R45'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0070423428 then 'R46'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0094151022 then 'R47'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.012974984  then 'R48'
when a.apply_mob> 90 and  a.bCardV6ZbScore< 0.0199826621 then 'R49'
when a.apply_mob> 90 and  a.bCardV6ZbScore>=0.0199826621 then 'R40'
when a.apply_mob> 90 and  (a.bCardV6ZbScore is null or a.bCardV6ZbScore in ('','null','NULL')) then 'R40'  --没有B卡分的客户99+%占比是目前已管制户
end  as Tag_Risk_Est_Bin,
a.dt
from
      (select distinct
           t1.cust_no,
           t1.user_no,
           t1.contract_no,
           case when t1.product_code_new = 'JIETIAO_311' then 1 else 0 end as 311_flag,
           case when t4.cust_no is not null then 1 else 0 end as special_price_flag,
           t4.custlevel_bin,
           t2.Risk_Est_Bin as Tag_Risk_Est_Bin,
           t1.apply_mob,
           t2.bCardV6ZbScore,
           substr(current_date(),1,10) as dt
      from
           (select a.*,datediff(current_date,a.date_finished) apply_mob,
            row_number()over(partition by a.contract_no order by a.date_finished asc) rn
            from
           (select * from fin_dw_zz.dwt_appl_no_apply_info_a
            where state='PS'
            and product_code_new in ('360JIETIAO','JIETIAO_311')
            and datediff(current_date,date_finished)>=81)a   ---预留天数，防止跑批失败出现90-跨90+客户没有标
            having rn=1) t1
      left join
           (select *,
            row_number()over(partition by cust_no order by date_created desc) rn
            from dp_data_db.jt_hxpp_credit_current_611_data_zijin
            where bCardV6ZbScore is not null and bCardV6ZbScore not in ('null','NULL','')
            having rn=1) t2
      on t1.cust_no=t2.cust_no
      left join dp_data_db.hl_tiaojia20221212_pricedown_mingdan t4 on t1.cust_no = t4.cust_no

) a
;