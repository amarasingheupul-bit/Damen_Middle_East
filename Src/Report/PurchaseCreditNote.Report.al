report 50105 "4HC Purchase Credit Note"
{
    Caption = 'Purchase Credit Note';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = PurchaseCreditNoteLayout;

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            column(No_PurchaseHeader; "No.")
            {
            }
            column(OrderDate_PurchaseHeader; "Order Date")
            {
            }
            column(BuyfromVendorNo_PurchaseHeader; "Buy-from Vendor No.")
            {
            }
            column(BuyfromVendorName_PurchaseHeader; "Buy-from Vendor Name")
            {
            }
            column(BuyfromAddress2_PurchaseHeader; "Buy-from Address 2")
            {
            }
            column(BuyfromAddress_PurchaseHeader; "Buy-from Address")
            {
            }
            column(BuyfromCounty_PurchaseHeader; "Buy-from County")
            {
            }
            column(BuyfromCity_PurchaseHeader; "Buy-from City")
            {
            }
            column(YourReference_PurchaseHeader; "Your Reference")
            {
            }
            column(PaymentTermsCode_PurchaseHeader; "Payment Terms Code")
            {
            }
            column(ReportTitleLbl; ReportTitleLbl)
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyInfReportFooter; CompanyInformation."Report Footer")
            {
            }
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyPhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(CompanyFaxNo; CompanyInformation."Fax No.")
            {
            }
            column(CompanyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyVatRegistration; CompanyInformation."VAT Registration No.")
            {
            }
            column(CurrencyCode_PurchaseHeader; "Currency Code")
            {
            }
            column(CommissionAmount_PurchaseHeader; "Commission Amount")
            {
            }
            column(OPCOComProjectNo_PurchaseHeader; "OPCO Com Project No.")
            {
            }
            column(YardNo_PurchaseHeader; "Yard No.")
            {
            }
            column(VesselType_PurchaseHeader; "Vessel Type")
            {
            }
            column(CostReference_PurchaseHeader; "Cost Reference")
            {
            }
            column(Address; Address)
            {
            }
            column(ContactName; Contact.Name)
            {
            }
            column(TRNLeft; TRNLeft)
            {
            }
            column(Budget_PurchaseHeader; Budget)
            {
            }
            column(BankDetailsS365_PurchaseHeader; "Bank Details")
            {
            }
            column(CostCenter_PurchaseHeader; "Cost Center")
            {
            }
            column(SalesManager_PurchaseHeader; "Sales Manager")
            {
            }
            column(SalesProviderNo_PurchaseHeader; "Sales Provider No.")
            {
            }
            column(SalesAreaDirectorName_PurchaseHeader; "Sales/ Area Director Name")
            {
            }
            column(QuoteType_PurchaseHeader; "Quote Type")
            {
            }
            column(SwiftCode; BankAccount."SWIFT Code")
            {
            }
            column(Currency; BankAccount."Currency Code")
            {
            }
            column(BankName; BankAccount.Name)
            {
            }
            column(IBAN; BankAccount.IBAN)
            {
            }
            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(No_PurchaseLine; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity_PurchaseLine; Quantity)
                {
                }
                column(UnitofMeasureCode_PurchaseLine; "Unit of Measure Code")
                {
                }
                column(UnitPriceLCY_PurchaseLine; "Unit Price (LCY)")
                {
                }
                column(Amount; Amount)
                {
                }
                column(AmountIncludingVAT; "Amount Including VAT")
                {
                }
                column(VATAmount; "Amount Including VAT" - "VAT Base Amount")
                {
                }
                column(VAT__; "VAT %")
                {
                }
                column(Currency_Code; "Currency Code")
                {
                }
                trigger OnAfterGetRecord()
                begin
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if Contact.Get("Buy-from Contact No.") then;
                Address := CompanyInformation.Address + ' ' + CompanyInformation."Address 2" + ' ' + CompanyInformation.City + ' ' + CompanyInformation.County;

                if "Gen. Bus. Posting Group" = 'UAE' then
                    TRNLeft := "VAT Registration No."
                else
                    TRNLeft := '';

                if BankAccount.Get("Bank Details") then;
            end;
        }
    }

    requestpage
    {
    }

    rendering
    {
        layout(PurchaseCreditNoteLayout)
        {
            Type = RDLC;
            LayoutFile = 'Src\Report\PurchaseCreditNote.rdl';
        }
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
        CompanyInformation.CalcFields("Report Footer");
    end;

    var
        CompanyInformation: Record "Company Information";
        Contact: Record Contact;
        BankAccount: Record "Bank Account";
        TRNLeft: Text[20];
        ReportTitleLbl: Label 'Purchase Credit Note';
        Address: Text;
}