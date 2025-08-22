codeunit 50101 "SQmodFunction S365"
{
    procedure SalesQuoteAmendArchive(var Rec: Record "Sales Header")
    begin
        this.CreateCopyofSalesQuote(Rec);
        this.ArchiveSalesQuote(Rec);
        this.DeleteArchivedSalesQuote(Rec);
        this.ShowMessageAfterSQuoteAmendArchive();
    end;

    local procedure CreateCopyofSalesQuote(var Rec: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
        CopyDocumentMgt: Codeunit "Copy Document Mgt.";
        DocumentNo: Code[20];
        ExactCostReversingMandatory: Boolean;
    begin
        DocumentNo := Rec."No." + Format('-1');
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
        if Rec."Amend & Archived S365" then
            SalesHeader."No." := IncStr(Rec."No.")
        else
            SalesHeader."No." := DocumentNo;
        SalesHeader.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
        SalesHeader.Insert(true);
        GetSalesSetup();
        ExactCostReversingMandatory := SalesSetup."Exact Cost Reversing Mandatory";
        CopyDocumentMgt.SetProperties(true, false, false, false, false, ExactCostReversingMandatory, false);
        CopyDocumentMgt.CopySalesDoc(Rec."Document Type", Rec."No.", SalesHeader);
        SalesHeader."Printed or Email S365" := false;
        if Rec."Original Quote No. S365" <> '' then
            SalesHeader."Original Quote No. S365" := Rec."Original Quote No. S365"
        else
            SalesHeader."Original Quote No. S365" := Rec."No.";
        SalesHeader."Amend & Archived S365" := true;
        SalesHeader.Modify();
        Page.Run(Page::"Sales Quote", SalesHeader);
    end;

    local procedure GetSalesSetup()
    begin
        SalesSetup.Get();
    end;

    local procedure ArchiveSalesQuote(var Rec: Record "Sales Header")
    begin
        ArchiveManagement.StoreSalesDocument(Rec, false);
    end;

    local procedure DeleteArchivedSalesQuote(var Rec: Record "Sales Header")
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup.ArchiveandDeleteQuoteS365 then Rec.Delete(true);
    end;

    procedure ConfirmQoute(var Rec: Record "Sales Header")
    var
        QouteConfirmMsg: Label 'Do you need to confirm this qoute?';
    begin
        if Confirm(QouteConfirmMsg, false) then begin
            Rec.ConfirmedS365 := true;
            Rec.Modify();
        end
        else
            Error('');
    end;

    procedure SendNotificationEmail(var Saleshdr: Record "Sales Header"; var Job: Record Job);
    var
        UserSetup: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        body: Text;
        EmailSubTxt: Label 'Project %1 has been created for Sales Order %2', Comment = '%1=Project No, %2=Order No';
    begin
        UserSetup.Get(Job."Project Manager");
        if UserSetup."E-Mail" <> '' then begin
            EmailMessage.Create(UserSetup."E-Mail", StrSubstNo(EmailSubTxt, Job."No.", Saleshdr."No."), body, true);
            Email.Send(EmailMessage);
        end;
    end;

    local procedure ShowMessageAfterSQuoteAmendArchive()
    var
        Text001Msg: Label 'Document %1 has been archived & Copied document lines and header information from %1 sales document to this document.', Comment = '%1 = Document No.';
        Text002Msg: Label 'Document %1 has been archived & deleted. Document lines and header information copied from %1 sales document to this document.', Comment = '%1 = Document No.';
    begin
        if SalesReceivablesSetup.ArchiveandDeleteQuoteS365 then
            Message(Text002Msg, this.SalesQuoteNo)
        else
            Message(Text001Msg, this.SalesQuoteNo);
    end;

    procedure AddChargeItem(var Rec: Record "Sales Line")
    var
        ItemCharges: Record "Item Charge";
        SalesHdr: Record "Sales Header";
    begin
        SalesHdr.get(SalesHdr."Document Type"::Quote, Rec."Document No.");
        ItemCharges.SetRange("QuoteType S365", SalesHdr."Quote Type S365");
        if ItemCharges.FindSet() then
            repeat
                NewSalesLine.SetHideValidationDialog(true);
                // Insert a new Sales Line for each Charge Item
                NewSalesLine.Init();
                NewSalesLine."Document Type" := Rec."Document Type";
                NewSalesLine."Document No." := Rec."Document No.";
                NewSalesLine."Line No." := GetNextLineNo(Rec);
                NewSalesLine.validate("Type", Rec."Type"::"Charge (Item)");
                NewSalesLine.validate("No.", ItemCharges."No.");
                NewSalesLine.validate("Quantity", 1); // Default quantity, editable
                NewSalesLine.validate("Unit of Measure code", ItemCharges."Charge UOM S365");
                NewSalesLine.validate("Unit Price", ItemCharges."Charge Amount S365");
                NewSalesLine.insert();
            until ItemCharges.Next() = 0;
    end;

    local procedure GetNextLineNo(var Rec: Record "Sales Line"): Integer
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure CreateJobFromTemplate(var Rec: Record "Sales Header")
    var
        Jobs: Record Job;
        Job: Record Job;
        CopyfromJob: Record Job;
        CopyfromJobTaskLines: Record "Job Task";
        CopyJob: Codeunit "Copy Job";
        Source: Option "Job Planning Lines","Job Ledger Entries","None";
        PlanningLineType: Option "Budget+Billable",Budget,Billable;
        LedgerEntryType: Option "Usage+Sale",Usage,Sale;
        JobCreateMsg: Label 'Job has been created';
    begin
        Jobs.SetRange("Use as TemplateS365", true);
        if Page.RunModal(Page::ProjectTemplateS365, Jobs) = Action::LookupOK then
            if CopyfromJob.Get(Jobs."No.") then begin
                CopyfromJobTaskLines.SetRange("Job No.", CopyfromJob."No.");
                //create job
                Job.Init();
                job.Description := Rec."No." + '-' + Rec."Sell-to Customer Name";
                job.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
                Job.Validate("Project Manager", CopyfromJob."Project Manager");
                Job.Insert(true);
                CopyJob.SetCopyOptions(false, false, false, Source::"Job Planning Lines", PlanningLineType, LedgerEntryType::"Usage+Sale");
                CopyJob.CopyJobTasks(CopyfromJob, job);
                Rec."Job No. S365" := Job."No.";
                Rec.Modify();
                Message(JobCreateMsg);
            end;
    end;

    procedure MyProcedure()
    var
        myInt: Integer;
    begin
    end;

    procedure CreateWarehouseReceipt(JobNo: Code[20])
    var
        WhseReceiptHeader: Record "Warehouse Receipt Header";
        WhseReceiptLine: Record "Warehouse Receipt Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        WhseSetup: Record "Warehouse Setup";
        Location: Record Location;
        NoSeries: Codeunit "No. Series";
        WhseSourceDoc: Enum "Warehouse Activity Source Document";
        NextWhseReceiptNo, PurchaseOrderNo : Code[20];
    begin
        SalesHeader.SetRange("Job No. S365", JobNo);
        if not SalesHeader.FindFirst() then Error('Sales Order not found for Job No %1 ', JobNo);
        // Check if Purchase Order exists
        // Get warehouse setup to generate a new Warehouse Receipt No.
        if WhseSetup.Get() then
            NextWhseReceiptNo := NoSeries.GetNextNo(WhseSetup."Whse. Receipt Nos.")
        else
            Error('Warehouse setup not found');
        // Get the location for the purchase order
        if not Location.Get(SalesHeader."Location Code") then Error('Location %1 not found', SalesHeader."Location Code");
        // Create Warehouse Receipt Header
        WhseReceiptHeader.Init();
        WhseReceiptHeader."No." := NextWhseReceiptNo;
        WhseReceiptHeader."Location Code" := PurchHeader."Location Code";
        WhseReceiptHeader."Assigned User ID" := UserId;
        WhseReceiptHeader.Insert(true);
        // Process purchase lines
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat // Create Warehouse Receipt Line
                WhseReceiptLine.Init();
                WhseReceiptLine."No." := WhseReceiptHeader."No.";
                WhseReceiptLine."Source Document" := WhseSourceDoc::"Sales Order";
                WhseReceiptLine."Source Subtype" := 37;
                WhseReceiptLine."Source Subtype" := WhseReceiptLine."Source Subtype"::"1";
                WhseReceiptLine."Source No." := PurchaseOrderNo;
                WhseReceiptLine."Source Line No." := SalesLine."Line No.";
                WhseReceiptLine."Item No." := SalesLine."No.";
                WhseReceiptLine.Description := SalesLine.Description;
                WhseReceiptLine."Location Code" := SalesLine."Location Code";
                WhseReceiptLine.Quantity := SalesLine.Quantity;
                WhseReceiptLine.Insert(true);
            until SalesLine.Next() = 0;
        Message('Warehouse Receipt %1 created successfully', WhseReceiptHeader."No.");
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        NewSalesLine: Record "Sales Line";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesQuoteNo: Code[20];
}
