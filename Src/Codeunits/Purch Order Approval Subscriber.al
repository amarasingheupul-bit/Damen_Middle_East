codeunit 50120 "Purch OrderApproval Subscriber"
{
    Subtype = Normal;
    Access = Internal;
    Permissions = tabledata "Approval Entry" = RIMD;

    // Correct event: OnApproveApprovalRequest (NOT OnAfterApproveApprovalRequest)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.",
                     'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        ParallelApprovalMgt: Codeunit "Purch Order Parallel Approval";
    begin
        ParallelApprovalMgt.HandleParallelApproverApproved(ApprovalEntry."Entry No.");
    end;
}