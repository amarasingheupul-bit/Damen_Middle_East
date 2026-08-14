codeunit 50117 "Journal Parallel Approval"
{
    Subtype = Normal;
    Access = Internal;
    Permissions = tabledata "Approval Entry" = RIMD,
                  tabledata "Restricted Record" = RIMD; // Required to manipulate record locks

    procedure HandleParallelApproverApproved(ApprovalEntryNo: Integer)
    var
        ApprovalEntry: Record "Approval Entry";
        OtherApprovalEntry: Record "Approval Entry";
        GenJournalLine: Record "Gen. Journal Line";
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        RecRef: RecordRef;
    begin
        if not ApprovalEntry.Get(ApprovalEntryNo) then
            exit;

        if ApprovalEntry."Table ID" <> Database::"Gen. Journal Line" then
            exit;

        if ApprovalEntry."Sequence No." <> 2 then
            exit;

        if ApprovalEntry.Status <> ApprovalEntry.Status::Approved then
            exit;

        // 1. Clean up other parallel approver entries at Sequence 2
        OtherApprovalEntry.Reset();
        OtherApprovalEntry.SetRange("Table ID", Database::"Gen. Journal Line");
        OtherApprovalEntry.SetRange("Document Type", ApprovalEntry."Document Type");
        OtherApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        OtherApprovalEntry.SetRange("Sequence No.", 2);
        OtherApprovalEntry.SetRange(Status, OtherApprovalEntry.Status::Open);
        OtherApprovalEntry.SetFilter("Entry No.", '<>%1', ApprovalEntry."Entry No.");

        if OtherApprovalEntry.FindSet() then begin
            repeat
                OtherApprovalEntry.Delete(true);
            until OtherApprovalEntry.Next() = 0;
        end;

        // 2. Locate the specific Journal Line record using RecordID from the approval entry
        if not GenJournalLine.Get(
            ApprovalEntry."Document Type",
            ApprovalEntry."Document No.",
            ApprovalEntry."Record ID To Approve".GetRecord().Field(2).Value
        ) then
            exit;

        // 3. Fix for AL0132: Instead of a field assignment, lift the workflow lock programmatically
        RecRef.GetTable(GenJournalLine);
        RecordRestrictionMgt.AllowRecordUsage(RecRef.RecordId());
    end;
}
