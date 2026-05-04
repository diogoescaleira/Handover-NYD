set -ex
#!/bin/bash

############## Executa o invalidate metadata da tabela 
IMPALADATABASEURL="impalatotta.totta.gs.corp:21000"
impala-shell -k -i $IMPALADATABASEURL -q 'INVALIDATE METADATA bu_captools_work.bail_in_srb_py;'


############## Executa a exportacao da tabela para ficheiro .csv
if [ -z "$1" ]
then
  echo "Não foi indicada a data de referência!"
  exit 1
fi


refdate=$1
ano=$(echo $refdate | cut -c1-4)
mes=$(echo $refdate | cut -c6-7)
dia=$(echo $refdate | cut -c9-10)

echo $refdate

ficheiro=/home/e858309/bail_in_srb_${ano}${mes}${dia}.csv
echo $ficheiro
rm -f $ficheiro

beeline -u "jdbc:hive2://hive2totta.totta.gs.corp:10000/default;principal=hive/hive2totta.totta.gs.corp@CENTRAL.RINTERNA.LOCAL" --outputformat=dsv --delimiterForDSV=';' --showHeader=true --incremental=true --var=refdate="$refdate" -e "
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.resultset.use.unique.column.names=false;
select * from bu_captools_work.bail_in_srb_py where ref_date='${refdate}'
limit 999000000;" > $ficheiro


############## Executa o zip do ficheiro .csv
zip bail_in_srb_${ano}${mes}${dia}  bail_in_srb_${ano}${mes}${dia}.csv


