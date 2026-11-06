@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Empleado (consumo)'
@Metadata.ignorePropagatedAnnotations: true
   @ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory:   #M,
    dataClass:      #MASTER
                       }
define view entity Z08_C_EMPLOYEE as select from Z08_R_EMPLOYEE
{
    key EmployeeId,
    FirstName,
    LastName,
    BirthDate,
    EntryDate,
    DepartmentId,
    @Semantics.amount.currencyCode: 'currCode'
    AnnualSalary,
    CurrencyCode as currCode,
    CreatedBy,
    CreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt
}
