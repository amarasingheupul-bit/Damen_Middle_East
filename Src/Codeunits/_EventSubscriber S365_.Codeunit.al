codeunit 50100 "EventSubscriber S365"
{
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
        if SalesLineCheck.FindSet() then
            repeat // Check for incompatible combinations
                if ItemCombination.Get(SalesLine."No.", SalesLineCheck."No.") or ItemCombination.Get(SalesLineCheck."No.", SalesLine."No.") then Error(ItemMatrixErr, SalesLine."No.", SalesLineCheck."No.");
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
            SalesHeader."Job TemplateS365" := Jobs."No.";
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
        Func: Codeunit "SQmodFunction S365";
        Source: Option "Job Planning Lines","Job Ledger Entries","None";
        PlanningLineType: Option "Budget+Billable",Budget,Billable;
        LedgerEntryType: Option "Usage+Sale",Usage,Sale;
    begin
        //Copy from job
        if CopyfromJob.Get(SalesHeader."Job TemplateS365") then begin
            CopyfromJobTaskLines.SetRange("Job No.", CopyfromJob."No.");
            //create job
            Job.Init();
            job.Description := SalesHeader2."No." + '-' + SalesHeader2."Sell-to Customer Name";
            job.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            Job.Validate("Project Manager", CopyfromJob."Project Manager");
            // ...Copy SO code...
            Job.Validate("Change Reason S365", SalesHeader."Change Reason S365");
            Job.Validate("Original Quote No. S365", SalesHeader."Quote No.");
            Job.Validate("ConfirmedS365", SalesHeader."ConfirmedS365");
            Job.Validate("Quote Status S365", SalesHeader."Quote Status S365");
            Job.Validate("Job TemplateS365", SalesHeader."Job TemplateS365");
            Job.Validate("Sales Director/ Area Director", SalesHeader."Sales Director/ Area Director");
            Job.Validate("Sales/ Area Director Name", SalesHeader."Sales/ Area Director Name");
            Job.Validate("Sales Secretary No.", SalesHeader."Sales Secretary No.");
            Job.Validate("Sales Secretary Name", SalesHeader."Sales Secretary Name");
            Job.Validate("Sales Contract No.", SalesHeader."Sales Contract No.");
            Job.Validate("Sales Contract Desc", SalesHeader."Sales Contract Desc");
            Job.Validate("Yard No.", SalesHeader."Yard No.");
            Job.Validate("Milestones Dates and Amounts", SalesHeader."Milestones Dates and Amounts");
            Job.Validate("End User/ Main Customer", SalesHeader."End User/ Main Customer");
            Job.Validate("Supplier to Services", SalesHeader."Supplier to Services");
            Job.Validate("Sales Area", SalesHeader."Sales Area");
            Job.Validate("Cost Center", SalesHeader."Cost Center");
            Job.Validate(Budget, SalesHeader.Budget);
            Job.Validate("Service Provider No.", SalesHeader."Service Provider No.");
            Job.Validate("Sales Manager", SalesHeader."Sales Manager");
            Job.Validate("Bank Details", SalesHeader."Bank Details");
            Job.Validate("4HC Type", SalesHeader."4HC Type");
            Job.Validate("OPCO Customer", SalesHeader."OPCO Customer");
            Job.Validate("COST Reference", SalesHeader."COST Reference");
            Job.Validate("G/L Account", SalesHeader."G/L Account");
            Job.Validate("Incoming PO", SalesHeader."Incoming PO");
            Job.Validate("Sales Order No. 4HC", SalesHeader."No.");
            Job.Insert(true);
            Func.CreateDimensionValues(Job."No.");

            CopyJob.SetCopyOptions(false, false, false, Source::"Job Planning Lines", PlanningLineType, LedgerEntryType::"Usage+Sale");
            CopyJob.CopyJobTasks(CopyfromJob, job);
            SalesHeader2."Job No. S365" := Job."No.";
            SalesHeader2.Modify();
        end;
        //Func.SendNotificationEmail(SalesHeader, Job);
    end;
}
