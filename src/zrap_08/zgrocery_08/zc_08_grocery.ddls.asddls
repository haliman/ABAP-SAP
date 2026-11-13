@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search: { searchable: true }
@EndUserText: {
  label: 'Projection view for ZR_08_GROCERY'
}
define root view entity ZC_08_GROCERY
  provider contract transactional_query
  as projection on ZR_08_GROCERY
{
  key ID,
  @Search.defaultSearchElement: true
  Product,
  @Search.defaultSearchElement: true
  Category,
  @Search.defaultSearchElement: true
  Brand,
  Price,
  Currency,
  Quantity,
  Purchasedate,
  @Search.defaultSearchElement: true
  Expirationdate,
  @Search.defaultSearchElement: true
  Expired,
  @Search.defaultSearchElement: true
  Rating,
  Note,
  Createdby,
  Createdat,
  Lastchangedby,
  Lastchangedat,
  Locallastchanged
}
