report 50104 "4HC Tax Invoice"
{
    Caption = 'Tax Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = SalesOrderLayout;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
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
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyAddress2; CompanyInformation."Address 2")
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyCounty; CompanyInformation.County)
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
            column(CurrencyCode_SalesHeader; "Currency Code")
            {
            }
            column(YardNo_SalesHeader; "Yard No.")
            {
            }
            dataitem(SalesLine; "Sales Line")
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
                column(Currency_Code; "Currency Code")
                {
                }
                trigger OnAfterGetRecord()
                begin
                end;
            }
            trigger OnAfterGetRecord()
            begin
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
        layout(SalesOrderLayout)
        {
            Type = RDLC;
            LayoutFile = 'Src\Report\TaxInvoice.rdl';
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
        ReportTitleLbl: Label 'Tax Invoice';
}