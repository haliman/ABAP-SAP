@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Departamento (consulta)'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z08_C_DEPARMENTQUERY
  with parameters
    p_target_curr : /dmo/currency_code,
    @EndUserText.label: 'Fecha de evaluacion'
    @Environment.systemField: #SYSTEM_DATE
    p_date        : abap.dats
    as select from Z08_C_EmployeeQueryP( 
                                        p_target_curr:$parameters.p_target_curr, 
                                        p_date: $parameters.p_date  
                                       ) as e
              right outer join Z08_R_DEPARTMENT as d
              on e.DepartmentId = d.Id
{
    d.Id,
    d.Description,
    avg( e.CompanyAffiliation as abap.dec(11,1) ) as AverageAffiliation,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    sum( e.AnnualSalaryConverted ) as TotalSalary,
    e.CurrencyCode

}
group by
    d.Id,
    d.Description,
    e.CurrencyCode

