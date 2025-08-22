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
        Case ReportId of
            Report::Order:
                NewReportId := Report::"4HC Purchase Order";
            Report::"Purchase - Credit Memo":
                NewReportId := Report::"4HC Purchase Credit Note";
        End;
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

    var
        PostingOnlyReceiveErr: Label 'Posting an invoice for a purchase order is not allowed. Please review the document and try again.';
}