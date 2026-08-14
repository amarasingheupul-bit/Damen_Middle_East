report 50115 "Posted Purchase Invoice Report"
{
    Caption = 'Posted Purchase Invoice Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src/Report/Layouts/PurchaseInvoiceReport.rdl';

    dataset
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            column(LineNo; LineNo) { }
            column(CompanyName; CompanyInformation.Name) { }
            column(CompanyLogo; CompanyInformation.Picture) { }
            column(IncomingNLPO; "Incoming PO")
            {
                Caption = 'Incoming NL PO';
            }
            column(Category; "Quote Type")
            {
                Caption = 'Category';
            }
            column(Currency; PurchInvHeader."Currency Code")
            {
                Caption = 'Currency';
            }
            column(ServiceProvider; PurchInvHeader."Buy-from Vendor Name")
            {
                Caption = 'Service Provider';
            }
            column(Customer; CustomerName)
            {
                Caption = 'Customer';
            }
            column(ProjectNo; ProjectNoValue)
            {
                Caption = 'Project No';
            }
            column(DSOLPONumber; "Related PO")
            {
                Caption = 'DSOL - PO Number';
            }
            column(ServiceProviderInvoice; PurchInvHeader."Vendor Invoice No.")
            {
                Caption = 'Service Provider Invoice';
            }
            column(DSOLPurchaseInvoiceNumber; PurchInvHeader."No.")
            {
                Caption = 'DSOL Purchase Invoice Number';
            }
            column(DSOLSalesInvoiceNumber; "Supplier Invoice NO.")
            {
                Caption = 'DSOL Sales Invoice Number';
            }
            column(InvoiceAmount; PurchInvHeader."Amount Including VAT")
            {
                Caption = 'Invoice Amount';
            }
            column(PaymentMadeValue; PaymentMadeValue)
            {
                Caption = 'Payment Made';
            }
            column(PaymentReceivedValue; PaymentReceivedValue)
            {
                Caption = 'Payment Received';
            }
            trigger OnAfterGetRecord()
            var
                PurchOrderHeader: Record "Purchase Header";
                SalesInvHeader: Record "Sales Invoice Header";
                SalesOrderNo: Code[20];
                IncomingDoc: Record "Incoming Document";
                PurchInvLine: Record "Purch. Inv. Line";
                Job: Record Job;
                VendorLedgerEntry: Record "Vendor Ledger Entry";
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                LineNo += 1;

                // IncomingNLPONo := PurchInvHeader."Order No.";
                CategoryValue := '';
                if PurchInvHeader."Shortcut Dimension 1 Code" <> '' then
                    CategoryValue := PurchInvHeader."Shortcut Dimension 1 Code";

                // DSOLPONo := PurchInvHeader."Order No.";

                ProjectNoValue := '';
                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                if PurchInvLine.FindFirst() then
                    ProjectNoValue := PurchInvLine."Job No.";

                // ── Customer & Posted Sales Invoice ───────────────────────────────
                CustomerName := '';
                //PostedSalesInvoiceNo := '';

                SalesOrderNo := PurchInvHeader."Your Reference";

                if SalesOrderNo <> '' then begin
                    // Find posted sales invoice linked to this sales order
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetCurrentKey("Order No.");
                    SalesInvHeader.SetRange("Order No.", SalesOrderNo);
                    if SalesInvHeader.FindFirst() then begin
                        PostedSalesInvoiceNo := SalesInvHeader."No.";
                        CustomerName := SalesInvHeader."Sell-to Customer Name";
                    end;
                end;

                // ── Payment Made (Vendor Ledger Entry) 
                PaymentMadeValue := '';
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
                VendorLedgerEntry.SetRange("Document No.", PurchInvHeader."No.");
                if VendorLedgerEntry.FindFirst() then begin
                    VendorLedgerEntry.CalcFields("Original Amount", "Remaining Amount");
                    if VendorLedgerEntry."Remaining Amount" = 0 then
                        PaymentMadeValue := 'YES'
                    else
                        if VendorLedgerEntry."Original Amount" = VendorLedgerEntry."Remaining Amount" then
                            PaymentMadeValue := 'NO'
                        else
                            PaymentMadeValue := 'Part';
                end;

                // ── Payment Received (Customer Ledger Entry) 
                PaymentReceivedValue := '';
                if PurchInvHeader."Supplier Invoice NO." <> '' then begin
                    CustLedgerEntry.Reset();
                    CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                    CustLedgerEntry.SetRange("Document No.", PurchInvHeader."Supplier Invoice NO.");
                    if CustLedgerEntry.FindFirst() then begin
                        CustLedgerEntry.CalcFields("Original Amount", "Remaining Amount");
                        if CustLedgerEntry."Remaining Amount" = 0 then
                            PaymentReceivedValue := 'YES'
                        else
                            if CustLedgerEntry."Original Amount" = CustLedgerEntry."Remaining Amount" then
                                PaymentReceivedValue := 'NO'
                            else
                                PaymentReceivedValue := 'Part';
                    end;
                end;
            end;
        }
    }

    trigger OnPreReport()
    begin
        if CompanyInformation.Get() then;
        CompanyInformation.CalcFields(Picture);
        if VendorNoFilter <> '' then
            PurchInvHeader.SetRange("Buy-from Vendor No.", VendorNoFilter);
        if PostingDateFilter <> '' then
            PurchInvHeader.SetFilter("Posting Date", PostingDateFilter);
    end;

    var
        IncomingNLPONo: Code[20];
        CategoryValue: Code[20];
        DSOLPONo: Code[20];
        ProjectNoValue: Code[20];
        CustomerName: Text[100];
        PostedSalesInvoiceNo: Code[20];
        VendorNoFilter: Code[20];
        PostingDateFilter: Text[30];
        CompanyInformation: Record "Company Information";
        LineNo: Integer;
        PaymentMadeValue: Text[10];
        PaymentReceivedValue: Text[10];
}
