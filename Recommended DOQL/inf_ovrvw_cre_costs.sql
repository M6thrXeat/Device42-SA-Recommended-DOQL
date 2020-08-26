/* CRE Report for release 16.16 */
/* Inline view of Target CTE (inline views) to streamline the process  - 
 
*/
With 
    target_mountpoint_data  as (
    Select Distinct        
        dev.device_pk,
        (Select count(*) From view_device_v1) "Total Devices",
        round(((select sum(m.capacity-m.free_capacity)/1024 from view_mountpoint_v1 m where m.device_fk = dev.device_pk and m.fstype_name <> 'nfs' and m.fstype_name <> 'nfs4' and m.filesystem not like '\\\\%')) , 2)"Used Space"
    From view_device_v1 dev
     Group by dev.device_pk
    ),
    target_cre_data  as (
    SELECT
        cre.device_fk,
        cre.vendor "Vendor",
        round(sum(cre.monthly_ondemand_cost) over(partition by cre.vendor), 2) "Monthly On-Demand Cost",
        round(sum(cre.monthly_1yr_resvd_noupfront_cost ) over(partition by cre.vendor), 2)  "Monthly 1-Year Reserved No Upfront Cost",
        round(sum(cre.monthly_1yr_resvd_partupfront_cost )over(partition by cre.vendor), 2)  "Monthly 1-Year Reserved Partial Upfront Cost",
        round(sum(cre.monthly_1yr_resvd_allupfront_cost )over(partition by cre.vendor), 2)  "Monthly 1-Year Reserved All Upfront Cost",
        round(sum(cre.monthly_prorated_3yr_resvd_noupfront_cost )over(partition by cre.vendor), 2)  "Monthly (prorated) 3-Year Reserved No Upfront Cost",
        round(sum(cre.monthly_prorated_3yr_resvd_partupfront_cost )over(partition by cre.vendor), 2)  "Monthly (prorated) 3-Year Reserved Partial Upfront Cost",
        round(sum(cre.monthly_prorated_3yr_resvd_allupfront_cost )over(partition by cre.vendor), 2)  "Monthly (prorated) 3-Year Reserved All Upfront Cost",
        round(sum(cre.yearly_ondemand_cost )over(partition by cre.vendor), 2)  "Yearly On-Demand Cost",
        round(sum(cre.yearly_1yr_resvd_noupfront_cost )over(partition by cre.vendor), 2)  "Yearly 1-Year Reserved No Upfront Cost",
        round(sum(cre.yearly_1yr_resvd_partupfront_cost )over(partition by cre.vendor), 2)  "Yearly 1-Year Reserved Partial Upfront Cost",
        round(sum(cre.yearly_1yr_resvd_allupfront_cost )over(partition by cre.vendor), 2)  "Yearly 1-Year Reserved All Upfront Cost",
        round(sum(cre.yearly_prorated_3yr_resvd_noupfront_cost )over(partition by cre.vendor), 2)  "Yearly (prorated) 3-Year Reserved No Upfront Cost",
        round(sum(cre.yearly_prorated_3yr_resvd_partupfront_cost )over(partition by cre.vendor), 2)  "Yearly (prorated) 3-Year Reserved Partial Upfront Cost",
        round(sum(cre.yearly_prorated_3yr_resvd_allupfront_cost )over(partition by cre.vendor), 2)  "Yearly (prorated) 3-Year Reserved All Upfront Cost",
        round(sum(cre.monthly_networking_cost )over(partition by cre.vendor), 2)  "Monthly Networking Cost",
        round(sum(cre.yearly_networking_cost )over(partition by cre.vendor), 2)  "Yearly Networking Cost",
        round(sum(cre.monthly_storage_cost )over(partition by cre.vendor), 2)  "Monthly Storage Cost",
        round(sum(cre.yearly_storage_cost )over(partition by cre.vendor), 2)  "Yearly Storage Cost"
            /*  on tmd.device_pk = cre.device_fk */
            From view_credata_v2 cre 
    )
/* Put the data back together  */   
    Select 
            tmd."Total Devices"
            ,tmd."Used Space"
            ,tcd."Vendor"
            ,tcd."Monthly On-Demand Cost"
            ,tcd."Monthly 1-Year Reserved No Upfront Cost"
            ,tcd."Monthly 1-Year Reserved Partial Upfront Cost"
            ,tcd."Monthly 1-Year Reserved All Upfront Cost"
            ,tcd."Monthly (prorated) 3-Year Reserved No Upfront Cost"
            ,tcd."Monthly (prorated) 3-Year Reserved Partial Upfront Cost"
            ,tcd."Monthly (prorated) 3-Year Reserved All Upfront Cost"
            ,tcd."Yearly On-Demand Cost"
            ,tcd."Yearly 1-Year Reserved No Upfront Cost"
            ,tcd."Yearly 1-Year Reserved Partial Upfront Cost"
            ,tcd."Yearly 1-Year Reserved All Upfront Cost"
            ,tcd."Yearly (prorated) 3-Year Reserved No Upfront Cost"
            ,tcd."Yearly (prorated) 3-Year Reserved Partial Upfront Cost"
            ,tcd."Yearly (prorated) 3-Year Reserved All Upfront Cost"
            ,tcd."Monthly Networking Cost"
            ,tcd."Yearly Networking Cost"
            ,tcd."Monthly Storage Cost"
            ,tcd."Yearly Storage Cost"
        From target_mountpoint_data tmd
        Join target_cre_data tcd on tcd.device_fk = tmd.device_pk 