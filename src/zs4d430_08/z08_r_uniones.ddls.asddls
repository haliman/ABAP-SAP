@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'uniones y uniones en definiciones'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z08_R_UNIONES
  as select from /dmo/customer as c
    inner join   /dmo/travel   as t on c.customer_id = t.customer_id
{

  key c.customer_id                 as id,
  key 'C'                           as type,

      //      concat_with_space( c.last_name, c.first_name, 1) as name,
      @EndUserText.label: 'Number of booking'
      count( distinct t.travel_id ) as TravelsCount

}
group by
  c.customer_id,
  c.last_name,
  c.first_name

union all

select from  /dmo/agency as a
  inner join /dmo/travel as t on a.agency_id = t.agency_id
{
  key a.agency_id                   as id,
  key 'a'                           as type,
      //      @EndUserText.label: 'Number of booking'
      count( distinct t.travel_id ) as TravelsCount
}
group by
  a.agency_id
