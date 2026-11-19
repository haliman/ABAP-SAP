@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZVEHICLE_BOOK_08'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_VEHICLE_BOOK_08
  provider contract transactional_query
  as projection on ZR_VEHICLE_BOOK_08
  association [1..1] to ZR_VEHICLE_BOOK_08 as _BaseEntity on $projection.BookingID = _BaseEntity.BookingID
{
  key BookingID,
  CustormerName,
  Vehicle,
  StartDate,
  EndDate,
  Status,
  StatusCriticality,
  Totaldays,
  @Semantics: {
    amount.currencyCode: 'Currency'
  }
  TotalPrice,
  @Consumption: {
    valueHelpDefinition: [ {
      entity.element: 'Currency', 
      entity.name: 'I_CurrencyStdVH', 
      useForValidation: true
    } ]
  }
  Currency,
  @Semantics: {
    user.createdBy: true
  }
  Createdby,
  Createdat,
  @Semantics: {
    user.lastChangedBy: true
  }
  Lastchangedby,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  Lastchangedat,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  Locallastchanged,
  _BaseEntity
}
