codeunit 50118 "Journal Approval Entry Subscr."
{
    Subtype = Normal;
    Access = Internal;
    Permissions = tabledata "Approval Entry" = RIMD;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyApprovalEntry(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        JournalApproval: Codeunit "Journal Parallel Approval";
    begin
        if Rec.IsTemporary then
            exit;

        if Rec."Table ID" <> Database::"Gen. Journal Line" then
            exit;

        if Rec."Sequence No." <> 2 then
            exit;

        if Rec.Status <> Rec.Status::Approved then
            exit;

        if xRec.Status = Rec.Status::Approved then
            exit; // already handled, avoid re-trigger loop

        JournalApproval.HandleParallelApproverApproved(Rec."Entry No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.",
                    'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        JournalApproval: Codeunit "Journal Parallel Approval";
    begin
        // if ApprovalEntry."Table ID" <> Database::"Gen. Journal Line" then
        //     exit;

        JournalApproval.HandleParallelApproverApproved(ApprovalEntry."Entry No.");
    end;
}