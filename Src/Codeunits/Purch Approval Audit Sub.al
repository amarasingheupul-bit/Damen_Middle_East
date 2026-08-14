codeunit 50105 "Purch Approval Audit Sub"
{
    // -------------------------------------------------
    // INSERT: When approval request is created
    // -------------------------------------------------
    [EventSubscriber(
        ObjectType::Table,
        Database::"Approval Entry",
        'OnAfterInsertEvent',
        '',
        false,
        false)]
    local procedure ApprovalEntryOnAfterInsert(
        var Rec: Record "Approval Entry";
        RunTrigger: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        Audit: Record "Purch. Approval Audit";
        ApprovalSet: Record "Approval Entry";
        ApproverLevel: Integer;
    begin
        // Only Purchase Header approvals
        if Rec."Table ID" <> Database::"Purchase Header" then
            exit;

        // Only Purchase Invoices
        if not PurchHeader.Get(
            PurchHeader."Document Type"::Invoice,
            Rec."Document No.")
        then
            exit;

        // Check if an audit record already exists for this document
        Audit.SetRange("Document No.", Rec."Document No.");
        if Audit.FindFirst() then begin
            // -----------------------------------------------
            // Audit row exists — this is Approver 2 being added
            // Stamp Approver 2 Sent DateTime and calc duration
            // -----------------------------------------------
            Audit."Approver Level 2" := Rec."Approver ID";
            Audit."Approver 2 Sent DateTime" := CurrentDateTime;

            // Duration from Approver 1 sent to Approver 2 sent
            if Audit."Approver 1 Sent DateTime" <> 0DT then
                Audit."Approver1 to Approver2 Duration" :=
                    Audit."Approver 2 Sent DateTime" - Audit."Approver 1 Sent DateTime";

            Audit.Modify();
        end else begin
            // -----------------------------------------------
            // No audit row yet — this is the first (Approver 1) insert
            // -----------------------------------------------
            Audit.Init();
            Audit."Document Type" := PurchHeader."Document Type";
            Audit."Document No." := PurchHeader."No.";
            Audit."Vendor No." := PurchHeader."Buy-from Vendor No.";
            Audit."Vendor Name" := PurchHeader."Buy-from Vendor Name";
            Audit."Purchase Officer" := PurchHeader."Purchaser Code";
            Audit."Sender ID" := Rec."Sender ID";
            Audit."Sent To User" := Rec."Approver ID";
            Audit."Sent DateTime" := CurrentDateTime;
            Audit."Email Approval Status" := PurchHeader."Email Approval Status";
            Audit."Invoice Status" := PurchHeader.Status;
            Audit."Sales Secretary" := PurchHeader."Sales Secretary Name";
            Audit."Area Director" := PurchHeader."Sales/ Area Director Name";
            PurchHeader.CalcFields(Amount);
            Audit.Amount := PurchHeader.Amount;
            Audit."Currency Code" := PurchHeader."Currency Code";

            // Approver 1
            Audit."Approver Level 1" := Rec."Approver ID";
            Audit."Approver 1 Sent DateTime" := CurrentDateTime;

            // Try to pre-fill Approver 2 if already queued (edge case)
            ApprovalSet.SetRange("Document No.", Rec."Document No.");
            ApprovalSet.SetRange("Table ID", Database::"Purchase Header");
            if ApprovalSet.FindSet() then begin
                if ApprovalSet.Next() <> 0 then
                    Audit."Approver Level 2" := ApprovalSet."Approver ID";
            end;

            Audit.Insert();
        end;
    end;

    // -------------------------------------------------
    // UPDATE: Whenever Purchase Header is modified
    // -------------------------------------------------
    [EventSubscriber(
        ObjectType::Table,
        Database::"Purchase Header",
        'OnAfterModifyEvent',
        '',
        false,
        false)]
    local procedure PurchaseHeaderOnAfterModify(
        var Rec: Record "Purchase Header";
        xRec: Record "Purchase Header";
        RunTrigger: Boolean)
    var
        Audit: Record "Purch. Approval Audit";
    begin
        Audit.SetRange("Document No.", Rec."No.");
        if Audit.FindSet() then
            repeat
                Audit."Email Approval Status" := Rec."Email Approval Status";
                Audit."Status Updated At" := CurrentDateTime;
                Audit."Invoice Status" := Rec.Status;
                Audit.Modify();
            until Audit.Next() = 0;
    end;

    // -------------------------------------------------
    // OPTIONAL: Map Approval Entry Status to custom enum
    // -------------------------------------------------
    local procedure MapApprovalStatus(
        SourceStatus: Enum System.Automation."Approval Status"
    ): Enum "4HC PAutoApprovalStatus"
    var
        TargetStatus: Enum "4HC PAutoApprovalStatus";
    begin
        case SourceStatus of
            SourceStatus::Open:
                TargetStatus := TargetStatus::Open;
            SourceStatus::Approved:
                TargetStatus := TargetStatus::Approved;
            SourceStatus::Rejected:
                TargetStatus := TargetStatus::Reject;
            SourceStatus::Canceled:
                TargetStatus := TargetStatus::Pending;
            else
                TargetStatus := TargetStatus::Wait;
        end;

        exit(TargetStatus);
    end;
}