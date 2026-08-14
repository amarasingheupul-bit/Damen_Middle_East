codeunit 50119 "Purch Order Parallel Approval"
{
    Subtype = Normal;
    Access = Internal;
    Permissions = tabledata "Approval Entry" = RIMD;

    procedure HandleParallelApproverApproved(ApprovalEntryNo: Integer)
    var
        ApprovalEntry: Record "Approval Entry";
        OtherApprovalEntry: Record "Approval Entry";
        PurchaseHeader: Record "Purchase Header";
    begin
        if not ApprovalEntry.Get(ApprovalEntryNo) then
            exit;

        if ApprovalEntry."Table ID" <> Database::"Purchase Header" then
            exit;

        if ApprovalEntry."Document Type" <> ApprovalEntry."Document Type"::Order then
            exit;

        if (ApprovalEntry."Sequence No." <> 1)
         //and (ApprovalEntry."Sequence No." <> 2)
         then
            exit;

        if ApprovalEntry.Status <> ApprovalEntry.Status::Approved then
            exit;

        // Cancel other parallel approver at the same Sequence No.
        OtherApprovalEntry.Reset();
        OtherApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
        OtherApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type"::Order);
        OtherApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        OtherApprovalEntry.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
        OtherApprovalEntry.SetRange(Status, OtherApprovalEntry.Status::Open);
        OtherApprovalEntry.SetFilter("Entry No.", '<>%1', ApprovalEntry."Entry No.");
        if OtherApprovalEntry.FindSet(true) then
            repeat
                OtherApprovalEntry.Status := OtherApprovalEntry.Status::Canceled;
                OtherApprovalEntry.Modify(true);
            until OtherApprovalEntry.Next() = 0;

        // Only release the Purchase Invoice once Sequence 2 is resolved
        if ApprovalEntry."Sequence No." <> 2 then
            exit;

        // Release Purchase Invoice
        if not PurchaseHeader.Get(ApprovalEntry."Document Type"::Order, ApprovalEntry."Document No.") then
            exit;

        PurchaseHeader.Status := PurchaseHeader.Status::Released;
        PurchaseHeader.Modify(true);
    end;
}