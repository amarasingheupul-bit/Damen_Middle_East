codeunit 50100 "EventSubscriber S365"
{
    [EventSubscriber(ObjectType::Report, Report::"Standard Sales - Quote", OnHeaderOnAfterGetRecordOnAfterUpdateNoPrinted, '', false, false)]
    local procedure OnHeaderOnAfterGetRecordOnAfterUpdateNoPrinted(ReportInPreviewMode: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then if SalesHeader."No. Printed" > 0 then begin
                SalesHeader."Printed or Email S365":=true;
                SalesHeader.Modify();
            end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeValidateNo, '', false, false)]
    local procedure ValidateIncompatibleItems(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        SalesLineCheck: Record "Sales Line";
        ItemCombination: Record ServiceItemMatrixS365;
        ItemMatrixErr: Label 'Item %1 is incompatible with item %2.', Comment = '%1=Service Item 1,%2=Service Item 2';
    begin
        SalesLineCheck.Reset();
        SalesLineCheck.SetRange("Document Type", SalesLine."Document Type");
        SalesLineCheck.SetRange("Document No.", SalesLine."Document No.");
        if SalesLineCheck.FindSet()then repeat // Check for incompatible combinations
 if ItemCombination.Get(SalesLine."No.", SalesLineCheck."No.") or ItemCombination.Get(SalesLineCheck."No.", SalesLine."No.")then Error(ItemMatrixErr, SalesLine."No.", SalesLineCheck."No.");
            until SalesLineCheck.Next() = 0;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", OnBeforeConfirmConvertToOrder, '', false, false)]
    local procedure "Sales-Quote to Order (Yes/No)_OnBeforeConfirmConvertToOrder"(SalesHeader: Record "Sales Header"; var Result: Boolean; var IsHandled: Boolean)
    var
        Jobs: Record Job;
    begin
        // Jobs.SetFilter("Use as TemplateS365", '%1', true);
        Jobs.SetRange("Quote Type S365", SalesHeader."Quote Type S365");
        if Page.RunModal(Page::ProjectTemplateS365, Jobs) = Action::LookupOK then begin
            SalesHeader."Job TemplateS365":=Jobs."No.";
            SalesHeader.Modify();
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", OnAfterSalesQuoteToOrderRun, '', false, false)]
    local procedure "Sales-Quote to Order (Yes/No)_OnAfterSalesQuoteToOrderRun"(var SalesHeader2: Record "Sales Header"; var SalesHeader: Record "Sales Header")
    var
        Job: Record Job;
        CopyfromJob: Record Job;
        // JobPlanningLines: Record "Job Planning Line";
        // JobTaskLines: Record "Job Task";
        CopyfromJobTaskLines: Record "Job Task";
        CopyJob: Codeunit "Copy Job";
        // Func: Codeunit "SQmodFunction S365";
        Source: Option "Job Planning Lines", "Job Ledger Entries", "None";
        PlanningLineType: Option "Budget+Billable", Budget, Billable;
        LedgerEntryType: Option "Usage+Sale", Usage, Sale;
    begin
        //Copy from job
        if CopyfromJob.Get(SalesHeader."Job TemplateS365")then begin
            CopyfromJobTaskLines.SetRange("Job No.", CopyfromJob."No.");
            //create job
            Job.Init();
            job.Description:=SalesHeader2."No." + '-' + SalesHeader2."Sell-to Customer Name";
            job.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            Job.Validate("Project Manager", CopyfromJob."Project Manager");
            Job.Insert(true);
            CopyJob.SetCopyOptions(false, false, false, Source::"Job Planning Lines", PlanningLineType, LedgerEntryType::"Usage+Sale");
            CopyJob.CopyJobTasks(CopyfromJob, job);
            SalesHeader2."Job No. S365":=Job."No.";
            SalesHeader2.Modify();
        end;
    //Func.SendNotificationEmail(SalesHeader, Job);
    end;
}
