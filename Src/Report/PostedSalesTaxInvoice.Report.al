report 50100 "4HC Posted Sales Tax Invoice"
{
    Caption = 'Tax Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = PostedTaxInvoice;

    dataset
    {
        dataitem(SalesHeader; "Sales Invoice Header")
        {
            column(No_SalesHeader; "No.")
            {
            }
            column(OrderDate_SalesHeader; "Order Date")
            {
            }
            column(YourReference_SalesHeader; "Your Reference")
            {
            }
            column(PaymentTermsCode_SalesHeader; "Payment Terms Code")
            {
            }
            column(ReportTitleLbl; this.ReportTitleLbl)
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
            column(CompanyAddress; this.CompanyInformation.Address)
            {
            }
            column(CompanyAddress2; this.CompanyInformation."Address 2")
            {
            }
            column(CompanyCity; this.CompanyInformation.City)
            {
            }
            column(CompanyCounty; this.CompanyInformation.County)
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
            column(CurrencyCode_SalesHeader; "Currency Code")
            {
            }
            column(YardNo_SalesHeader; "Yard No.")
            {
            }
            column(Cost_Center; "Cost Center")
            {
            }
            column(Sales_Manager; "Sales Manager")
            {
            }
            column(CustomerVATRegNo; this.Customer."VAT Registration No.")
            {
            }
            column(Sell_to_Contact; "Sell-to Contact")
            {
            }
            column(Job_No__S365; "Job No. S365") //Commision project invoice
            {
            }
            column(Quote_Type_S365; "Quote Type S365")
            {
            }
            column(Type_SalesHeader; "4HC Type")
            {
            }
            column(OPCOCustomer_SalesHeader; "OPCO Customer")
            {
            }
            column(COSTReference_SalesHeader; "COST Reference")
            {
            }
            column(GLAccount_SalesHeader; "G/L Account")
            {
            }
            column(Budget_SalesHeader; Budget)
            {
            }
            column(IncomingPO_SalesHeader; "Incoming PO")
            {
            }
            column(ServiceProviderNo_SalesHeader; "Service Provider No.")
            {
            }
            column(SalesAreaDirectorName_SalesHeader; "Sales/ Area Director Name")
            {
            }
            column(SalesDirectorAreaDirector_SalesHeader; "Sales Director/ Area Director")
            {
            }
            column(BankDetails_SalesHeader; "Bank Details")
            {
            }
            column(BankAccontName; this.BankAccont."Name")
            {
            }
            column(IBAN; this.BankAccont.IBAN)
            {
            }
            column(SWIFTCode; this.BankAccont."SWIFT Code")
            {
            }
            column(BankAccountCurrency; this.BankAccont."Currency Code")
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Address; this.Address)
            {
            }

            dataitem(SalesLine; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(No_SalesLine; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity_SalesLine; Quantity)
                {
                }
                column(UnitofMeasureCode_SalesLine; "Unit of Measure Code")
                {
                }
                column(UnitPriceLCY_SalesLine; "Unit Price")
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
                column(Currency_Code; GetCurrencyCode())
                {
                }
                trigger OnAfterGetRecord()
                begin
                end;
            }
            trigger OnAfterGetRecord()
            var
                Country: Record "Country/Region";
            begin
                this.Customer.Get("Sell-to Customer No.");
                if this.BankAccont.Get("Bank Details") then;
                Country.Reset();
                if Country.Get("Sell-to Country/Region Code") then;
                this.Address := "Sell-to Address" + ' ' + "Sell-to Address 2" + ' ' + "Sell-to City" + ' ' + "Sell-to County" + ' ' + "Sell-to Post Code" + ' ' + Country.Name;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
    }

    rendering
    {
        layout(PostedTaxInvoice)
        {
            Type = RDLC;
            LayoutFile = 'Src\Report\PostedSalesTaxInvoice.rdl';
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
        Customer: Record Customer;
        BankAccont: Record "Bank Account";
        ReportTitleLbl: Label 'Tax Invoice';
        Address: Text;
}