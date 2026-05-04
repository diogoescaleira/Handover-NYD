		drop table if exists bu_esg_work.idcombs_cargabal_masterizado; 
		create table bu_esg_work.idcombs_cargabal_masterizado 
		(
		amount string,
		idcomb01 string,
		idcomb02 string,
		idcomb03 string,
		idcomb04 string,
		idcomb05 string,
		idcomb06 string,
		idcomb07 string,
		idcomb08 string,
		idcomb09 string,
		idcomb10 string,
		idcomb11 string,
		idcomb12 string
		
		
		)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ';' STORED AS TEXTFILE;
DESCRIBE EXTENDED bu_esg_work.idcombs_cargabal_masterizado;
INVALIDATE METADATA bu_esg_work.idcombs_cargabal_masterizado;
select * from bu_esg_work.idcombs_cargabal_masterizado;

drop table if exists bu_esg_work.idcombs_cargabal_masterizado2;
		create table bu_esg_work.idcombs_cargabal_masterizado2 as
select 
amount,
case when idcomb01 is null then '' else idcomb01 end as idcomb01,
case when idcomb02 is null then '' else idcomb02 end as idcomb02,
case when idcomb03 is null then '' else idcomb03 end as idcomb03,
case when idcomb04 is null then '' else idcomb04 end as idcomb04,
case when idcomb05 is null then '' else idcomb05 end as idcomb05,
case when idcomb06 is null then '' else idcomb06 end as idcomb06,
case when idcomb07 is null then '' else idcomb07 end as idcomb07,
case when idcomb08 is null then '' else idcomb08 end as idcomb08,
case when idcomb09 is null then '' else idcomb09 end as idcomb09,
case when idcomb10 is null then '' else idcomb10 end as idcomb10,
case when idcomb11 is null then '' else idcomb11 end as idcomb11,
case when idcomb12 is null then '' else idcomb12 end as idcomb12
from bu_esg_work.idcombs_cargabal_masterizado ;

drop table if exists bu_esg_work.idcombs_cargabal_masterizado3;
		create table bu_esg_work.idcombs_cargabal_masterizado3 as
select
amount,
concat_ws(';',idcomb01,idcomb02,idcomb03,idcomb04,idcomb05,idcomb06,idcomb07,idcomb08,idcomb09,idcomb10,idcomb11,idcomb12) idcomb
from  bu_esg_work.idcombs_cargabal_masterizado2;


drop table if exists bu_esg_work.idcombs_cargabal_masterizado_separ; 
		create table bu_esg_work.idcombs_cargabal_masterizado_separ as
select  *,
        case when  split_part(idcomb,';',01) like 'PR%' then '' 
         when  split_part(idcomb,';',01) like 'HEDG%' then '' 
         when  split_part(idcomb,';',01) like 'HEDI%' then '' 
         when  split_part(idcomb,';',01) like 'TAPU%' then ''
         when  split_part(idcomb,';',01) like 'ORIG%' then '' 
         when  split_part(idcomb,';',01) like 'EQGE%' then '' 
         when  split_part(idcomb,';',01) like 'CONS%' then '' 
         when  split_part(idcomb,';',01) like 'PPDE%' then '' 
         when  split_part(idcomb,';',01) like 'PENC%' then '' 
         when  split_part(idcomb,';',01) like 'INEX%' then '' 
         when  split_part(idcomb,';',01) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',01) like 'SUBO%' then '' 
         when  split_part(idcomb,';',01) like 'WOFF%' then '' 
         when  split_part(idcomb,';',01) like 'OPRI%' then '' 
         when  split_part(idcomb,';',01) like 'FORB%' then '' 
        else split_part(idcomb,';',01) end as idcomb01,
        
        case when  split_part(idcomb,';',02) like 'PR%' then '' 
         when  split_part(idcomb,';',02) like 'HEDG%' then ''
         when  split_part(idcomb,';',02) like 'HEDI%' then ''
         when  split_part(idcomb,';',02) like 'TAPU%' then '' 
         when  split_part(idcomb,';',02) like 'ORIG%' then '' 
         when  split_part(idcomb,';',02) like 'EQGE%' then '' 
         when  split_part(idcomb,';',02) like 'CONS%' then '' 
         when  split_part(idcomb,';',02) like 'PPDE%' then '' 
         when  split_part(idcomb,';',02) like 'PENC%' then '' 
         when  split_part(idcomb,';',02) like 'INEX%' then '' 
         when  split_part(idcomb,';',02) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',02) like 'SUBO%' then '' 
         when  split_part(idcomb,';',02) like 'WOFF%' then '' 
         when  split_part(idcomb,';',02) like 'OPRI%' then '' 
         when  split_part(idcomb,';',02) like 'FORB%' then '' 
         when split_part(idcomb,';',02) = '' then '' else split_part(idcomb,';',02) end as idcomb02,
         
        case  when  split_part(idcomb,';',03) like 'PR%' then '' 
         when  split_part(idcomb,';',03) like 'HEDG%' then '' 
         when  split_part(idcomb,';',03) like 'HEDI%' then '' 
         when  split_part(idcomb,';',03) like 'TAPU%' then '' 
        when  split_part(idcomb,';',03) like 'ORIG%' then '' 
         when  split_part(idcomb,';',03) like 'EQGE%' then '' 
         when  split_part(idcomb,';',03) like 'CONS%' then '' 
        when  split_part(idcomb,';',03) like 'PPDE%' then '' 
         when  split_part(idcomb,';',03) like 'PENC%' then '' 
         when  split_part(idcomb,';',03) like 'INEX%' then '' 
         when  split_part(idcomb,';',03) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',03) like 'SUBO%' then '' 
         when  split_part(idcomb,';',03) like 'WOFF%' then '' 
         when  split_part(idcomb,';',03) like 'OPRI%' then '' 
         when  split_part(idcomb,';',03) like 'FORB%' then ''
         when split_part(idcomb,';',03) = '' then '' else split_part(idcomb,';',03) end as idcomb03,
         
        		case when  split_part(idcomb,';',04) like 'PR%' then '' 
         when  split_part(idcomb,';',04) like 'HEDG%' then '' 
         when  split_part(idcomb,';',04) like 'HEDI%' then '' 
         when  split_part(idcomb,';',04) like 'TAPU%' then '' 
         when  split_part(idcomb,';',04) like 'ORIG%' then '' 
         when  split_part(idcomb,';',04) like 'EQGE%' then '' 
         when  split_part(idcomb,';',04) like 'CONS%' then '' 
         when  split_part(idcomb,';',04) like 'PPDE%' then '' 
         when  split_part(idcomb,';',04) like 'PENC%' then '' 
         when  split_part(idcomb,';',04) like 'INEX%' then '' 
         when  split_part(idcomb,';',04) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',04) like 'SUBO%' then '' 
         when  split_part(idcomb,';',04) like 'WOFF%' then '' 
         when  split_part(idcomb,';',04) like 'OPRI%' then '' 
         when  split_part(idcomb,';',04) like 'FORB%' then '' 
         when split_part(idcomb,';',04) = '' then '' else split_part(idcomb,';',04) end as idcomb04,
         
        		case when  split_part(idcomb,';',05) like 'PR%' then '' 
         when  split_part(idcomb,';',05) like 'HEDG%' then '' 
         when  split_part(idcomb,';',05) like 'HEDI%' then '' 
         when  split_part(idcomb,';',05) like 'TAPU%' then '' 
         when  split_part(idcomb,';',05) like 'ORIG%' then '' 
         when  split_part(idcomb,';',05) like 'EQGE%' then '' 
         when  split_part(idcomb,';',05) like 'CONS%' then '' 
         when  split_part(idcomb,';',05) like 'PPDE%' then '' 
         when  split_part(idcomb,';',05) like 'PENC%' then '' 
         when  split_part(idcomb,';',05) like 'INEX%' then '' 
         when  split_part(idcomb,';',05) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',05) like 'SUBO%' then '' 
         when  split_part(idcomb,';',05) like 'WOFF%' then '' 
         when  split_part(idcomb,';',05) like 'OPRI%' then '' 
         when  split_part(idcomb,';',05) like 'FORB%' then '' 
         when split_part(idcomb,';',05) = '' then '' else split_part(idcomb,';',05) end as idcomb05,
         
        		case when  split_part(idcomb,';',06) like 'PR%' then '' 
        when  split_part(idcomb,';',06) like 'HEDG%' then '' 
         when  split_part(idcomb,';',06) like 'HEDI%' then '' 
         when  split_part(idcomb,';',06) like 'TAPU%' then '' 
         when  split_part(idcomb,';',06) like 'ORIG%' then '' 
         when  split_part(idcomb,';',06) like 'EQGE%' then '' 
         when  split_part(idcomb,';',06) like 'CONS%' then '' 
         when  split_part(idcomb,';',06) like 'PPDE%' then '' 
         when  split_part(idcomb,';',06) like 'PENC%' then '' 
         when  split_part(idcomb,';',06) like 'INEX%' then '' 
         when  split_part(idcomb,';',06) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',06) like 'SUBO%' then '' 
         when  split_part(idcomb,';',06) like 'WOFF%' then '' 
         when  split_part(idcomb,';',06) like 'OPRI%' then '' 
         when  split_part(idcomb,';',06) like 'FORB%' then '' 
        when split_part(idcomb,';',06) = '' then '' else split_part(idcomb,';',06) end as idcomb06,
        
        	case when  split_part(idcomb,';',07) like 'PR%' then '' 
         when  split_part(idcomb,';',07) like 'HEDG%' then '' 
         when  split_part(idcomb,';',07) like 'HEDI%' then '' 
        when  split_part(idcomb,';',07) like 'TAPU%' then '' 
         when  split_part(idcomb,';',07) like 'ORIG%' then '' 
         when  split_part(idcomb,';',07) like 'EQGE%' then '' 
         when  split_part(idcomb,';',07) like 'CONS%' then '' 
         when  split_part(idcomb,';',07) like 'PPDE%' then '' 
         when  split_part(idcomb,';',07) like 'PENC%' then '' 
         when  split_part(idcomb,';',07) like 'INEX%' then '' 
         when  split_part(idcomb,';',07) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',07) like 'SUBO%' then '' 
         when  split_part(idcomb,';',07) like 'WOFF%' then '' 
         when  split_part(idcomb,';',07) like 'OPRI%' then '' 
         when  split_part(idcomb,';',07) like 'FORB%' then '' 

        when split_part(idcomb,';',07) = '' then '' else split_part(idcomb,';',07) end as idcomb07,
        
        	case when  split_part(idcomb,';',08) like 'PR%' then '' 
         when  split_part(idcomb,';',08) like 'HEDG%' then '' 
         when  split_part(idcomb,';',08) like 'HEDI%' then '' 
         when  split_part(idcomb,';',08) like 'TAPU%' then '' 
         when  split_part(idcomb,';',08) like 'ORIG%' then '' 
         when  split_part(idcomb,';',08) like 'EQGE%' then '' 
         when  split_part(idcomb,';',08) like 'CONS%' then '' 
         when  split_part(idcomb,';',08) like 'PPDE%' then '' 
         when  split_part(idcomb,';',08) like 'PENC%' then '' 
         when  split_part(idcomb,';',08) like 'INEX%' then '' 
         when  split_part(idcomb,';',08) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',08) like 'SUBO%' then '' 
         when  split_part(idcomb,';',08) like 'WOFF%' then '' 
         when  split_part(idcomb,';',08) like 'OPRI%' then '' 
         when  split_part(idcomb,';',08) like 'FORB%' then '' 

         when split_part(idcomb,';',08) = '' then '' else split_part(idcomb,';',08) end as idcomb08,
        
        	case when  split_part(idcomb,';',09) like 'PR%' then '' 
         when  split_part(idcomb,';',09) like 'HEDG%' then '' 
         when  split_part(idcomb,';',09) like 'HEDI%' then '' 
         when  split_part(idcomb,';',09) like 'TAPU%' then '' 
         when  split_part(idcomb,';',09) like 'ORIG%' then '' 
         when  split_part(idcomb,';',09) like 'EQGE%' then '' 
         when  split_part(idcomb,';',09) like 'CONS%' then '' 
         when  split_part(idcomb,';',09) like 'PPDE%' then '' 
         when  split_part(idcomb,';',09) like 'PENC%' then '' 
         when  split_part(idcomb,';',09) like 'INEX%' then '' 
         when  split_part(idcomb,';',09) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',09) like 'SUBO%' then '' 
         when  split_part(idcomb,';',09) like 'WOFF%' then '' 
         when  split_part(idcomb,';',09) like 'OPRI%' then '' 
         when  split_part(idcomb,';',09) like 'FORB%' then '' 
         when split_part(idcomb,';',09) = '' then '' else split_part(idcomb,';',09) end as idcomb09,
         
         case when  split_part(idcomb,';',10) like 'PR%' then '' 
         when  split_part(idcomb,';',10) like 'HEDG%' then '' 
         when  split_part(idcomb,';',10) like 'HEDI%' then '' 
         when  split_part(idcomb,';',10) like 'TAPU%' then '' 
         when  split_part(idcomb,';',10) like 'ORIG%' then '' 
         when  split_part(idcomb,';',10) like 'EQGE%' then '' 
         when  split_part(idcomb,';',10) like 'CONS%' then '' 
         when  split_part(idcomb,';',10) like 'PPDE%' then '' 
         when  split_part(idcomb,';',10) like 'PENC%' then '' 
         when  split_part(idcomb,';',10) like 'INEX%' then '' 
         when  split_part(idcomb,';',10) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',10) like 'SUBO%' then '' 
         when  split_part(idcomb,';',10) like 'WOFF%' then '' 
         when  split_part(idcomb,';',10) like 'OPRI%' then '' 
         when  split_part(idcomb,';',10) like 'FORB%' then '' 
         when split_part(idcomb,';',10) = '' then '' else split_part(idcomb,';',10) end as idcomb10,
         
        case when  split_part(idcomb,';',11) like 'PR%' then '' 
        when  split_part(idcomb,';',11) like 'HEDG%' then '' 
         when  split_part(idcomb,';',11) like 'HEDI%' then '' 
         when  split_part(idcomb,';',11) like 'TAPU%' then '' 
         when  split_part(idcomb,';',11) like 'ORIG%' then '' 
         when  split_part(idcomb,';',11) like 'EQGE%' then '' 
         when  split_part(idcomb,';',11) like 'CONS%' then '' 
         when  split_part(idcomb,';',11) like 'PPDE%' then '' 
         when  split_part(idcomb,';',11) like 'PENC%' then '' 
         when  split_part(idcomb,';',11) like 'INEX%' then '' 
         when  split_part(idcomb,';',11) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',11) like 'SUBO%' then '' 
         when  split_part(idcomb,';',11) like 'WOFF%' then '' 
         when  split_part(idcomb,';',11) like 'OPRI%' then '' 
         when  split_part(idcomb,';',11) like 'FORB%' then '' 
         when split_part(idcomb,';',11) = '' then '' else split_part(idcomb,';',11) end as idcomb11,
         
        		case when  split_part(idcomb,';',12) like 'PR%' then '' 
         when  split_part(idcomb,';',12) like 'HEDG%' then '' 
         when  split_part(idcomb,';',12) like 'HEDI%' then '' 
         when  split_part(idcomb,';',12) like 'TAPU%' then '' 
         when  split_part(idcomb,';',12) like 'ORIG%' then '' 
         when  split_part(idcomb,';',12) like 'EQGE%' then '' 
         when  split_part(idcomb,';',12) like 'CONS%' then '' 
         when  split_part(idcomb,';',12) like 'PPDE%' then '' 
         when  split_part(idcomb,';',12) like 'PENC%' then '' 
         when  split_part(idcomb,';',12) like 'INEX%' then '' 
         when  split_part(idcomb,';',12) like 'PLGEN%' then '' 
         when  split_part(idcomb,';',12) like 'SUBO%' then '' 
         when  split_part(idcomb,';',12) like 'WOFF%' then '' 
         when  split_part(idcomb,';',12) like 'OPRI%' then '' 
         when  split_part(idcomb,';',12) like 'FORB%' then '' 
         when split_part(idcomb,';',12) = '' then '' else split_part(idcomb,';',12) end as idcomb12
--select count(*)
from  bu_esg_work.idcombs_cargabal_masterizado3;


select * from bu_esg_work.idcombs_cargabal_masterizado_separ;

Drop table if exists bu_esg_work.idcombs_cargabal_masterizado_conci_aux;
Create table bu_esg_work.idcombs_cargabal_masterizado_conci_aux as
select 

idcomb,
amount,
concat(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12) idcomb_conci
from 
(
select 
idcomb,
amount,
case when idcomb01 = '' then '' else  concat(idcomb01,";") end as x1, 
case when idcomb02 = '' then '' else  concat(idcomb02,";") end as x2,
case when idcomb03 = '' then '' else  concat(idcomb03,";") end as x3,
case when idcomb04 = '' then '' else  concat(idcomb04,";") end as x4,
case when idcomb05 = '' then '' else  concat(idcomb05,";") end as x5,
case when idcomb06 = '' then '' else  concat(idcomb06,";") end as x6,
case when idcomb07 = '' then '' else  concat(idcomb07,";") end as x7,
case when idcomb08 = '' then '' else  concat(idcomb08,";") end as x8,
case when idcomb09 = '' then '' else  concat(idcomb09,";") end as x9, 
case when idcomb10 = '' then '' else  concat(idcomb10,";") end as x10,
case when idcomb11 = '' then '' else  concat(idcomb11,";") end as x11,
case when idcomb12 = '' then '' else  concat(idcomb12,";") end as x12
from bu_esg_work.idcombs_cargabal_masterizado_separ
) as cc
;


drop table if exists bu_esg_work.idcombs_cargabal_masterizado_conci;
create table bu_esg_work.idcombs_cargabal_masterizado_conci as 
select 
idcomb,
amount,
substr(idcomb_conci,1,length(idcomb_conci)-1) as idcomb_conci2
from bu_esg_work.idcombs_cargabal_masterizado_conci_aux; 

		