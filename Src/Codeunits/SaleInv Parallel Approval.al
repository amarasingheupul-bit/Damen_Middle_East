codeunit 50115 "Sales Inv Parallel Approval"
{
    Subtype = Normal;
    Access = Internal;
    Permissions = tabledata "Approval Entry" = RIMD;

    procedure HandleParallelApproverApproved(ApprovalEntryNo: Integer)
    var
        ApprovalEntry: Record "Approval Entry";
        OtherApprovalEntry: Record "Approval Entry";
        SalesHeader: Record "Sales Header";
    begin
        if not ApprovalEntry.Get(ApprovalEntryNo) then
            exit;

        if ApprovalEntry."Table ID" <> Database::"Sales Header" then
            exit;

        // No Document Type filter - handle all Sales Header document types

        if ApprovalEntry."Sequence No." <> 2 then
            exit;

        if ApprovalEntry.Status <> ApprovalEntry.Status::Approved then
            exit;

        // Delete other parallel approver's entry at Sequence 2
        OtherApprovalEntry.Reset();
        OtherApprovalEntry.SetRange("Table ID", Database::"Sales Header");
        OtherApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type");
        OtherApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        OtherApprovalEntry.SetRange("Sequence No.", 2);
        OtherApprovalEntry.SetRange(Status, OtherApprovalEntry.Status::Open);
        OtherApprovalEntry.SetFilter("Entry No.", '<>%1', ApprovalEntry."Entry No.");
        if OtherApprovalEntry.FindSet(true) then
            repeat
                OtherApprovalEntry.Delete(true);
            until OtherApprovalEntry.Next() = 0;

        // Release Sales Document
        if not SalesHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.") then
            exit;

        SalesHeader.Status := SalesHeader.Status::Released;
        SalesHeader.Modify(true);
    end;
}