codeunit 50109 PurchaseApprovalMgt
{
    Permissions = tabledata "Purchase Header" = RIMD;

    procedure SetStatusIn(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.Status := PurchHeader.Status::Open;
        PurchHeader."Email Approval Status" := PurchHeader."Email Approval Status"::Open;
        PurchHeader.Modify();
    end;

    procedure SetStatusOut(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.Status := PurchHeader.Status::Released;
        PurchHeader."Email Approval Status" := PurchHeader."Email Approval Status"::Approved;
        PurchHeader.Modify();
    end;
}