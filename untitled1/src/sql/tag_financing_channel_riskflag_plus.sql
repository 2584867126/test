drop table if exists fin_ads_xxzzl.tag_financing_channel_riskflag_plus;
create table fin_ads_xxzzl.tag_financing_channel_riskflag_plus as
select
row_number() over (order by user_no) as id
,*
,date_add(from_unixtime(unix_timestamp('${yesterday}', 'yyyy-MM-dd'), 'yyyy-MM-dd HH:mm:ss'), 1) as dt
from (
select
credit_detail_plus.cust_no
,credit_detail_plus.user_no
,"360PLUS" as product_code
,credit_detail_plus.contract_no
,credit_detail_plus.cust_seg
,case when result_new1.DY_lr_score_v2_main >=770 and credit_detail_plus.appr_final_amt <= 100000    then "R74"
      when result_new1.DY_lr_score_v2_main >=770 and result_new2.36SplitTag = "Y"                   then "R74"
      when result_new1.DY_lr_score_v2_main >=770 and result_new3.ifTerm36Group = "N"                then "R74"
      when result_new3.ifTerm36Group = "N" and result_new4.last6mInquiryTimes > 4                   then "R70"
      when result_new1.DY_lr_score_v2_main >=827
           and  (credit_detail_plus.appr_final_amt > 100000 or result_new2.36SplitTag != "Y")       then "R71"
      when result_new1.DY_lr_score_v2_main >=798 and result_new1.DY_lr_score_v2_main <827
           and  (credit_detail_plus.appr_final_amt > 100000 or result_new2.36SplitTag != "Y")       then "R72"
      when result_new1.DY_lr_score_v2_main >=770 and result_new1.DY_lr_score_v2_main <798
           and  (credit_detail_plus.appr_final_amt > 100000 or result_new2.36SplitTag != "Y")       then "R73"
      when result_new1.DY_lr_score_v2_main >=745 and result_new1.DY_lr_score_v2_main <770           then "R74"
      when result_new1.DY_lr_score_v2_main >=734 and result_new1.DY_lr_score_v2_main <745           then "R75"
      when result_new1.DY_lr_score_v2_main >=722 and result_new1.DY_lr_score_v2_main <734           then "R76"
      when result_new1.DY_lr_score_v2_main >=690 and result_new1.DY_lr_score_v2_main <722 and credit_detail_plus.appr_final_amt > 100000  then "R77"
      when result_new1.DY_lr_score_v2_main < 690 and credit_detail_plus.appr_final_amt > 100000     then "R78"
      when result_new1.DY_lr_score_v2_main < 722 and credit_detail_plus.appr_final_amt <= 100000
           and  result_new5.isQualityCar !='Y' and result_new5.isQualitySalary !='Y'
           and result_new5.isQualityCompany !='Y' and result_new5.isQualityHouse !='Y'              then "R70"
    else "" end as tag_risk_est_bin
from
(select * from fin_dw_zp.dwt_credit_apply_info_offline_zzl_a
where state = "PS" and cust_type not in ("周转灵_小微","原地推_小微") --and to_date(submit_time)>='2022-10-29'
and thedate >= date_add(from_unixtime(unix_timestamp('${yesterday}', 'yyyy-MM-dd'), 'yyyy-MM-dd HH:mm:ss'), -60)
) credit_detail_plus
left join
(select biz_no,case when dc_item = 'DY_lr_score_v2_main' then dc_val else null end as DY_lr_score_v2_main
        ,row_number() over(partition by biz_no order by date_created desc) rn
  from hdp_credit.prd_dcs_dc_exec_result_new
  where module_no = 'APV' and biz_type = 'APPL' and rule_set_no = 'L301' and dc_item = 'DY_lr_score_v2_main'
   having rn = 1) result_new1
on credit_detail_plus.apv_apply_no = result_new1.biz_no
left join
(select biz_no,case when dc_item = '36SplitTag' then dc_val else null end as 36SplitTag
        ,row_number() over(partition by biz_no order by date_created desc) rn
  from hdp_credit.prd_dcs_dc_exec_result_new
  where module_no = 'APV' and biz_type = 'APPL' and rule_set_no = 'L301' and dc_item = '36SplitTag'
   having rn = 1) result_new2
on credit_detail_plus.apv_apply_no = result_new2.biz_no
left join
(select biz_no,case when dc_item = 'ifTerm36Group' then dc_val else null end as ifTerm36Group
        ,row_number() over(partition by biz_no order by date_created desc) rn
  from hdp_credit.prd_dcs_dc_exec_result_new
  where module_no = 'APV' and biz_type = 'APPL' and rule_set_no = 'L301' and dc_item = 'ifTerm36Group'
   having rn = 1) result_new3
on credit_detail_plus.apv_apply_no = result_new3.biz_no
left join
(select biz_no,case when dc_item = 'last6mInquiryTimes' then dc_val else null end as last6mInquiryTimes
        ,row_number() over(partition by biz_no order by date_created desc) rn
  from hdp_credit.prd_dcs_dc_exec_result_new
  where module_no = 'APV' and biz_type = 'APPL' and rule_set_no = 'L301' and dc_item = 'last6mInquiryTimes'
   having rn = 1) result_new4
on credit_detail_plus.apv_apply_no = result_new4.biz_no
left join
(select biz_no
     ,max(case when dc_item = 'isQualityCar' then dc_val else null end ) as isQualityCar
     ,max(case when dc_item = 'isQualitySalary' then dc_val else null end ) as isQualitySalary
     ,max(case when dc_item = 'isQualityCompany' then dc_val else null end ) as isQualityCompany
     ,max(case when dc_item = 'isQualityHouse' then dc_val else null end ) as isQualityHouse
  from hdp_credit.prd_dcs_dc_exec_result_new
  where module_no = 'APV' and biz_type = 'APPL' and rule_set_no in ('L301')
  and dc_item in ('isQualityCar','isQualitySalary','isQualityCompany','isQualityHouse')
  group by 1 ) result_new5
on credit_detail_plus.apv_apply_no = result_new5.biz_no


union all

select
cust_no
,user_no
,product_code
,contract_no
,cust_seg
,tag_risk_est_bin
from dp_data_db.tag_financing_channel_riskflag_testlist
)
;
