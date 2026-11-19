@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZVEHICLE_BOOK_08'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_VEHICLE_BOOK_08
  as select from zvehicle_book_08
{
  key booking_id as BookingID,
  custormer_name as CustormerName,
  vehicle as Vehicle,
  start_date as StartDate,
  end_date as EndDate,
  status as Status,
  cast(
    case status
        when 'OPEN'     then 3
        when 'CANCELED' then 1
        else 0
    end as abap.int1
  ) as StatusCriticality,
  totaldays as Totaldays,
  @Semantics.amount.currencyCode: 'Currency'
  total_price as TotalPrice,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
  @Semantics.user.createdBy: true
  createdby as Createdby,
  createdat as Createdat,
  @Semantics.user.lastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchangedat as Lastchangedat,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchanged as Locallastchanged
}
