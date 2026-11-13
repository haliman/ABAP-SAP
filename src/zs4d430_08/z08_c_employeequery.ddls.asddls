@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Empleado (consulta)'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z08_C_EmployeeQuery
  as select from Z08_R_EMPLOYEE
{
  key EmployeeId,
      FirstName,
      LastName,
      DepartmentId,
      _Department.Description as DepartmentDescription,
//      _Department._Assistant.LastName as AssistantName,
    concat_with_space(
                        _Department._Assistant.FirstName,
                        _Department._Assistant.LastName,
                        1
                     ) as AssistanName,    
      
      @EndUserText.label: 'Employee Role'
      case EmployeeId
        when _Department.HeadId         then 'H'
        when _Department.AssistantId    then 'A'
        else ''
      end as EmployeeRole, 
      
        @EndUserText.label: 'Annual Salary'
        @Semantics.amount.currencyCode: 'CurrencyCodeUSD'
        currency_conversion( amount=> AnnualSalary,
                             source_currency => CurrencyCode,
                             target_currency => $projection.CurrencyCodeUSD,
                             exchange_rate_date => $session.system_date,
                             error_handling     => 'SET_TO_NULL'
                           )                as AnnualSalaryConverted,
//
//      
      @EndUserText.label: 'Monthly Salary'
      @Semantics.amount.currencyCode: 'CurrencyCodeUSD'
      cast( $projection.AnnualSalaryConverted as abap.fltp ) / 12.0 as MonthlySalaryConverted,
      
//      CurrencyCode,
      cast( 'USD' as /dmo/currency_code ) as CurrencyCodeUSD,
      
      division(
                dats_days_between( 
                                   EntryDate,
                                   $session.system_date
                                 ),
                365,
                1
               ) as CompanyAffiliation,

      /* Associations */
      _Department

}
