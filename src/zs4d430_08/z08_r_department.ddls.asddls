@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Departamento (entidad)'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z08_R_DEPARTMENT
    as select from z08depment
    association[0..*] to Z08_R_EMPLOYEE as _Employee
        on $projection.Id = _Employee.DepartmentId
    association[0..1] to Z08_R_EMPLOYEE as _Head
        on $projection.HeadId = _Head.EmployeeId
    association[1..1] to Z08_R_EMPLOYEE as _Assistant
        on $projection.HeadId = _Assistant.EmployeeId
{
    key id as Id,
    description as Description,
    head_id as HeadId,
    assistant_id as AssistantId,
    created_by as CreatedBy,
    created_at as CreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt,
    _Employee,
    _Head,
    _Assistant
}
