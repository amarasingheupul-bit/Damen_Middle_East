report 50103 "4HC Purchase Order"
{
    Caption = 'Purchase Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = PurchaseOrderLayout;

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
            column(ReportTitleLbl; this.ReportTitleLbl)
            {
            }
            column(HeaderLbl; this.HeaderLbl)
            {
            }
            column(BodyLbl; this.BodyLbl)
            {
            }
            column(CompanyPicture; this.CompanyInformation.Picture)
            {
            }
            column(CompanyInfReportFooter; this.CompanyInformation."Report Footer")
            {
            }
            column(CompanyName; this.CompanyInformation.Name)
            {
            }
            column(CompanyPhoneNo; this.CompanyInformation."Phone No.")
            {
            }
            column(CompanyFaxNo; this.CompanyInformation."Fax No.")
            {
            }
            column(CompanyEmail; this.CompanyInformation."E-Mail")
            {
            }
            column(CompanyVatRegistration; this.CompanyInformation."VAT Registration No.")
            {
            }
            column(ApplyFiedlVisibilityRules; this.PurchPaybleSetup."Apply Field Visibility Rules")
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
            column(Address; this.Address)
            {
            }
            column(ContactName; this.Contact.Name)
            {
            }
            column(TRNLeft; this.TRNLeft)
            {
            }
            column(Budget_PurchaseHeader; Budget)
            {
            }
            column(BankDetailsS365_PurchaseHeader; "Bank Details")
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
            column(G_L_Account; "G/L Account")
            {
            }
            column(OPCOCustomer_PurchaseHeader; "OPCO Customer")
            {
            }
            column(SwiftCode; this.BankAccount."SWIFT Code")
            {
            }
            column(Currency; this.BankAccount."Currency Code")
            {
            }
            column(BankName; this.BankAccount.Name)
            {
            }
            column(IBAN; this.BankAccount.IBAN)
            {
            }
            column(Sales_Area; "Sales Area")
            {
            }
            column(Sales_Order_No__4HC; "Sales Order No. 4HC")
            {
            }

            column(Incoming_PO; "Incoming PO")
            {
            }
            column(CurrencyCode; this.CurrencyCode)
            {
            }
            column(CurrencyFactor; this.CurrencyFactor)
            {
            }
            column(LocalCurrecy; this.GenLederSetup."LCY Code")
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
                column(UnitPriceLCY_PurchaseLine; "Direct Unit Cost")
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
                column(Type; Type)
                {
                }
                trigger OnAfterGetRecord()
                begin
                end;
            }
            trigger OnAfterGetRecord()
            var
                Country: Record "Country/Region";
                Address2: Text[55];
                City: Text[35];
                CountryName: Text[55];
            begin
                if this.Contact.Get("Buy-from Contact No.") then;

                if "Buy-from Address 2" <> '' then
                    Address2 := ', ' + "Buy-from Address 2"
                else
                    Address2 := '';

                if "Buy-from City" <> '' then
                    City := ', ' + "Buy-from City"
                else
                    City := '';

                if Country.Get("Buy-from Country/Region Code") then
                    CountryName := ', ' + Country.Name
                else
                    CountryName := '.';

                this.Address := "Buy-from Address" + Address2 + City + CountryName;

                if "Gen. Bus. Posting Group" = 'UAE' then
                    this.TRNLeft := "VAT Registration No."
                else
                    this.TRNLeft := '';

                if this.BankAccount.Get("Bank Details") then;

                if "Currency Code" = '' then
                    this.CurrencyCode := this.GenLederSetup."LCY Code"
                else
                    this.CurrencyCode := "Currency Code";

                if "Currency Factor" <> 0 then
                    this.CurrencyFactor := 1 / "Currency Factor"
                else
                    this.CurrencyFactor := 1;
            end;
        }
    }

    requestpage
    {
    }

    rendering
    {
        layout(PurchaseOrderLayout)
        {
            Type = RDLC;
            LayoutFile = 'Src\Report\PurchaseOrderLayout.rdl';
        }
    }

    trigger OnPreReport()
    begin
        this.CompanyInformation.Get();
        this.CompanyInformation.CalcFields(Picture);
        this.CompanyInformation.CalcFields("Report Footer");
        this.PurchPaybleSetup.Get();
        this.GenLederSetup.Get();
    end;

    var
        CompanyInformation: Record "Company Information";
        PurchPaybleSetup: Record "Purchases & Payables Setup";
        Contact: Record Contact;
        BankAccount: Record "Bank Account";
        GenLederSetup: Record "General Ledger Setup";
        CurrencyCode: Code[10];
        CurrencyFactor: Decimal;
        TRNLeft: Text[20];
        ReportTitleLbl: Label 'Purchase Order';
        Address: Text;
        HeaderLbl: Label 'All invoices, transport documents and correspondence must be marked with the Purchase order number';
        BodyLbl: Label 'This purchase order is created for engineering activities as per agreement with reference CONTRACT No.';
}