codeunit 50116 "Sales Approval Entry Subscr."
{
    Subtype = Normal;
    Access = Internal;
    Permissions = tabledata "Approval Entry" = RIMD,
    tabledata "Sales Header" = RIMD;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyApprovalEntry(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        SalesApproval: Codeunit "Sales Inv Parallel Approval";
    begin
        if Rec.IsTemporary then
            exit;

        if Rec."Table ID" <> Database::"Sales Header" then
            exit;

        if Rec."Sequence No." <> 2 then
            exit;

        if Rec.Status <> Rec.Status::Approved then
            exit;

        if xRec.Status = Rec.Status::Approved then
            exit; // already handled, avoid re-trigger loop

        SalesApproval.HandleParallelApproverApproved(Rec."Entry No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.",
                    'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        ParallelApprovalMgt: Codeunit "Sales Inv Parallel Approval";
    begin
        ParallelApprovalMgt.HandleParallelApproverApproved(ApprovalEntry."Entry No.");
    end;
}