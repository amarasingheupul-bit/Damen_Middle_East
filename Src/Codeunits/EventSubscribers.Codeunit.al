codeunit 50103 "4HC Event Subscribers"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", OnBeforeGetReport, '', false, false)]
    local procedure "Purch.-Post + Print_OnBeforeGetReport"(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader.Status <> PurchaseHeader.Status::Released then
            Error('The purchase order must be released before printing.');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        case ReportId of
            Report::Order:
                NewReportId := Report::"4HC Purchase Order";
            Report::"Purchase - Credit Memo":
                NewReportId := Report::"4HC Purchase Credit Note";
            Report::"Standard Sales - Invoice":
                NewReportId := Report::"4HC Posted Sales Tax Invoice";
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnBeforeConfirmPost, '', false, false)]
    local procedure "Purch.-Post (Yes/No)_OnBeforeConfirmPost"(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            DefaultOption := 1;
            PurchaseHeader.Receive := true;
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Selection Management", OnBeforeGetPurchaseOrderPostingSelection, '', false, false)]
    // local procedure "Posting Selection Management_OnBeforeGetPurchaseOrderPostingSelection"(var PurchaseHeader: Record "Purchase Header"; DefaultOption: Integer; var IsHandled: Boolean; var Selection: Integer)
    // begin
    //     IsHandled := true;
    //     Selection := DefaultOption;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", OnAfterConfirmPost, '', false, false)]
    local procedure "Purch.-Post + Print_OnAfterConfirmPost"(PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            if PurchaseHeader.Invoice then
                Error(this.PostingOnlyReceiveErr);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnAfterConfirmPost, '', false, false)]
    local procedure "Purch.-Post (Yes/No)_OnAfterConfirmPost"(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            if PurchaseHeader.Invoice then
                Error(this.PostingOnlyReceiveErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", OnBeforeUpdateUnitCost, '', false, false)]
    local procedure "Job Planning Line_OnBeforeUpdateUnitCost"(var JobPlanningLine: Record "Job Planning Line"; var IsHandled: Boolean; xJobPlanningLine: Record "Job Planning Line")
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number of
            database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    Message(PurchaseHeader."Approval Rejection Reason");
                    if PurchaseHeader."Email Approval Status" <> PurchaseHeader."Email Approval Status"::Approved then
                        Error('You can not approve without sales person approval.');
                end;
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeSetStatusToPendingApproval, '', false, false)]
    // local procedure "Approvals Mgmt._OnBeforeSetStatusToPendingApproval"(var Variant: Variant)
    // var
    //     PurchaseHeader: Record "Purchase Header";
    //     ApprovalEntry: Record "Approval Entry";
    //     RecRef: RecordRef;
    // begin
    //     RecRef.GetTable(Variant);
    //     case RecRef.Number of
    //         database::"Purchase Header":
    //             begin
    //                 RecRef.SetTable(PurchaseHeader);
    //                 if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
    //                     if PurchaseHeader.Status = PurchaseHeader.Status::Open then begin
    //                         ApprovalEntry.SetRange("Record ID to Approve", PurchaseHeader.RecordId);
    //                         ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
    //                         ApprovalEntry.SetRange("Sequence No.", 1);
    //                         if not ApprovalEntry.IsEmpty() then
    //                             PurchaseHeader."Email Approval Status" := PurchaseHeader."Email Approval Status"::Wait;
    //                         RecRef.GetTable(PurchaseHeader);
    //                         RecRef.SetTable(Variant);
    //                     end;
    //             end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnReopenOnBeforePurchaseHeaderModify, '', false, false)]
    local procedure "Release Purchase Document_OnReopenOnBeforePurchaseHeaderModify"(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Email Approval Status" := PurchaseHeader."Email Approval Status"::Open;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure "Approvals Mgmt._OnApproveApprovalRequest"(var ApprovalEntry: Record "Approval Entry")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if ApprovalEntry."Document Type" = ApprovalEntry."Document Type"::Invoice then
            if (ApprovalEntry."Sequence No." = 1) and (ApprovalEntry.Status = ApprovalEntry.Status::Approved) then
                if PurchaseHeader.Get(ApprovalEntry."Document Type", ApprovalEntry."Document No.") then begin
                    PurchaseHeader."Email Approval Status" := PurchaseHeader."Email Approval Status"::Wait;
                    PurchaseHeader.Modify();
                end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnBeforeUpdateUnitCost, '', false, false)]
    local procedure "Purchase Line_OnBeforeUpdateUnitCost"(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoice", OnBeforePostDocument, '', false, false)]
    local procedure "Purchase Invoice_OnBeforePostDocument"(var Sender: Page "Purchase Invoice"; var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; PostingCodeunitID: Integer; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Email Approval Status" <> PurchaseHeader."Email Approval Status"::Approved then
            Error('You can not post without sales director approval.');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", OnAfterCreateSalesLine, '', false, false)]
    local procedure "Job Create-Invoice_OnAfterCreateSalesLine"(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Job: Record Job; var JobPlanningLine: Record "Job Planning Line")
    begin
        SalesHeader.Validate("Change Reason S365", Job."Change Reason S365");
        SalesHeader.Validate("Original Quote No. S365", Job."Original Quote No. S365");
        SalesHeader.Validate("ConfirmedS365", Job."ConfirmedS365");
        SalesHeader.Validate("Quote Status S365", Job."Quote Status S365");
        SalesHeader.Validate("Job TemplateS365", Job."Job TemplateS365");
        SalesHeader.Validate("Sales Director/ Area Director", Job."Sales Director/ Area Director");
        SalesHeader.Validate("Sales/ Area Director Name", Job."Sales/ Area Director Name");
        SalesHeader.Validate("Sales Secretary No.", Job."Sales Secretary No.");
        SalesHeader.Validate("Sales Secretary Name", Job."Sales Secretary Name");
        SalesHeader.Validate("Sales Contract No.", Job."Sales Contract No.");
        SalesHeader.Validate("Sales Contract Desc", Job."Sales Contract Desc");
        SalesHeader.Validate("Yard No.", Job."Yard No.");
        SalesHeader.Validate("Milestones Dates and Amounts", Job."Milestones Dates and Amounts");
        SalesHeader.Validate("End User/ Main Customer", Job."End User/ Main Customer");
        SalesHeader.Validate("Supplier to Services", Job."Supplier to Services");
        SalesHeader.Validate("Sales Area", Job."Sales Area");
        SalesHeader.Validate("Cost Center", Job."Cost Center");
        SalesHeader.Validate(Budget, Job.Budget);
        SalesHeader.Validate("Service Provider No.", Job."Service Provider No.");
        SalesHeader.Validate("Sales Manager", Job."Sales Manager");
        SalesHeader.Validate("Bank Details", Job."Bank Details");
        SalesHeader.Validate("4HC Type", Job."4HC Type");
        SalesHeader.Validate("OPCO Customer", Job."OPCO Customer");
        SalesHeader.Validate("COST Reference", Job."COST Reference");
        SalesHeader.Validate("G/L Account", Job."G/L Account");
        SalesHeader.Validate("Incoming PO", Job."Incoming PO");
        SalesHeader.Modify();
    end;


    var
        PostingOnlyReceiveErr: Label 'Posting an invoice for a purchase order is not allowed. Please review the document and try again.';
}