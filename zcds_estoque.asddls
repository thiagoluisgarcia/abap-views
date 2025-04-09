@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estoque'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zcds_estoque 
      as select from nsdm_e_mard as a
                join Mbv_Mbew    as b on b.matnr = a.matnr and
                                         b.bwkey = a.werks
                join mara        as c on c.matnr = a.matnr
                join makt        as h on h.matnr = a.matnr and
                                         h.spras = $session.system_language
                join t001k       as i on i.bwkey = a.werks
                join t001        as l on l.bukrs = i.bukrs
{
      'Comum' as fonte
     ,i.bukrs      as cd_empresa
     ,a.matnr      as cd_material
     ,h.maktx      as ds_material
     ,a.werks      as cd_centro
     ,a.lgort      as cd_deposito
     ,cast( '' as abap.char( 10 ) ) as nr_lote
     ,cast( '' as abap.char( 10 ) ) as nr_ordem_venda
     ,'000000'     as nr_item_ordem_venda   
     ,cast( '' as abap.char( 1 ) )  as id_cancelado
     ,cast( '' as abap.char( 1 ) )  as id_fornecimento
     ,cast( '' as abap.char( 10 ) ) as cd_cliente
     ,cast( '' as abap.char( 35 ) ) as nm_cliente
     ,@Semantics.quantity.unitOfMeasure: 'cd_uom'
      a.labst      as qt_estoque
     ,c.meins      as cd_uom
     ,@Semantics.amount.currencyCode: 'cd_moeda'
      ( cast( b.stprs as abap.dec( 11, 2 ) ) / b.peinh ) as vl_preco_unitario
     ,l.waers      as cd_moeda
     ,cast( '' as abap.char( 2 ) ) as cd_canal_distribuicao
     ,'' as id_faturado 
} where c.xchpf <> 'X'

union all
         select from nsdm_e_mska as a
                join mara        as c on c.matnr   = a.matnr
                join makt        as h on h.matnr   = a.matnr and
                                         h.spras   = $session.system_language
                join t001k       as i on i.bwkey   = a.werks
                join vbak        as j on j.vbeln   = a.vbeln
                join vbap        as k on k.vbeln   = j.vbeln and
                                         k.posnr   = a.posnr
                join t001        as l on l.bukrs   = i.bukrs
                join Mbv_Mbew    as b on b.matnr   = a.matnr and
                                         b.bwkey   = a.werks
                join kna1        as m on m.kunnr   = j.kunnr
     left outer join vbfa        as n on n.vbelv   = j.vbeln and
                                         n.posnv   = k.posnr and
                                         n.vbtyp_n = 'M'
{
     'MTO' as fonte
     ,i.bukrs as cd_empresa
     ,a.matnr as cd_material
     ,h.maktx as ds_material
     ,a.werks as cd_centro
     ,a.lgort as cd_deposito
     ,cast( '' as abap.char( 10 ) ) as nr_lote
     ,a.vbeln as nr_ordem_venda
     ,a.posnr as nr_item_ordem_venda 
     ,cast( ( case when k.abgru is initial then '' else 'X' end ) as abap.char( 1 ) ) as id_cancelado
     ,k.lfsta as id_fornecimento
     ,j.kunnr as cd_cliente
     ,m.name1 as nm_cliente
     ,a.kalab as qt_estoque
     ,c.meins as cd_uom
     ,( cast( b.stprs as abap.dec( 11, 2 ) ) / b.peinh ) as vl_preco_unitario
     ,l.waers      as cd_moeda
     ,j.vtweg as cd_canal_distribuicao
     ,cast( ( case when n.vbeln is null or n.vbeln is initial then '' else 'X' end ) as abap.char( 1 ) ) as id_faturado
}

union all 
         select from nsdm_e_mchb as a
                join mara        as c on c.matnr = a.matnr
                join makt        as h on h.matnr = a.matnr and
                                         h.spras = $session.system_language
                join t001k       as i on i.bwkey = a.werks
                join t001        as l on l.bukrs = i.bukrs
                join Mbv_Mbew    as b on b.matnr = a.matnr and
                                         b.bwkey = a.werks
{
     'Lote' as fonte
     ,i.bukrs      as cd_empresa
     ,a.matnr      as cd_material
     ,h.maktx      as ds_material
     ,a.werks      as cd_centro
     ,a.lgort      as cd_deposito
     ,a.charg      as nr_lote
     ,cast( '' as abap.char( 10 ) ) as nr_ordem_venda
     ,'000000'     as nr_item_ordem_venda 
     ,cast( '' as abap.char( 1 ) )  as id_cancelado
     ,cast( '' as abap.char( 1 ) )  as id_fornecimento
     ,cast( '' as abap.char( 10 ) ) as cd_cliente
     ,cast( '' as abap.char( 35 ) ) as nm_cliente
     ,a.clabs      as qt_estoque
     ,c.meins      as cd_uom
     ,( cast( b.stprs as abap.dec( 11, 2 ) ) / b.peinh ) as vl_preco_unitario
     ,l.waers      as cd_moeda
     ,cast( '' as abap.char( 2 ) ) as cd_canal_distribuicao
     ,'' as id_faturado
}

