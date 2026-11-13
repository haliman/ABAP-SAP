extend view entity Z08_C_EmployeeQueryP with 
association [1..1] to I_Country as _ZZCountryZem
    on $projection.ZZCountryZem = _ZZCountryZem.Country
{
    Employee.ZZTitleZem,
    Employee.ZZCountryZem,
    
    @EndUserText.label: ''
    concat_with_space( Employee.FirstName, Employee.LastName, 1 )   as ZZFullNameZem,
    _ZZCountryZem.IsEuropeanUnionMember                             as ZZEUBasedZem
}
