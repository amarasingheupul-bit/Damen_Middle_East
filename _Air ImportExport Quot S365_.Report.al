report 50102 "Air ImportExport Quot S365"
{
    ApplicationArea = All;
    Caption = 'Air Quotation v1';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Src/Report/Layout/Air ImportExport Quotation.RDL';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            // RequestFilterFields = "No.";
            DataItemTableView = where("Document Type"=const("Sales Document Type"::Quote));

            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(SelltoAddress; "Sell-to Address")
            {
            }
            column(SelltoAddress2; "Sell-to Address 2")
            {
            }
            column(SelltoPhoneNo; "Sell-to Phone No.")
            {
            }
            column(SelltoEMail; "Sell-to E-Mail")
            {
            }
            column(No; "No.")
            {
            }
            column(DocumentDate; "Document Date")
            {
            }
            column(OriginS365; "Origin S365")
            {
            }
            column(QuoteTypeS365; "Quote Type S365")
            {
            }
            column(QuoteValidUntilDate; "Quote Valid Until Date")
            {
            }
            column(ShiptoName; "Ship-to Name")
            {
            }
            column(Currency_Code; "Currency Code")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLinkReference = SalesHeader;
                DataItemLink = "Document No."=field("No.");

                column(Line_Type; Type)
                {
                }
                column(Line_Description; Description)
                {
                }
                column(Line_Quantity; Quantity)
                {
                }
                column(Line_UnitVolume; "Unit Volume")
                {
                }
                column(Line_NetWeight; "Net Weight")
                {
                }
                column(Line_GrossWeight; "Gross Weight")
                {
                }
                column(Line_UnitofMeasureCode; "Unit of Measure Code")
                {
                }
                column(Line_Amount; Amount)
                {
                }
                column(Line_AmountIncludingVAT; "Amount Including VAT")
                {
                }
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address + ',' + CompanyInfo."Address 2" + ',' + CompanyInfo.City + ' ' + CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_Telephone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Fax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Email; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfo_Web; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfo_RegNo; CompanyInfo."Registration No.")
            {
            }
            column(Customer_Fax; Customer."Fax No.")
            {
            }
            column(GeneralLedgerSetup_LCYcode; GeneralLedgerSetup."LCY Code")
            {
            }
            column(AmountInWords; AmountInWords)
            {
            }
            trigger OnPreDataItem()
            begin
            end;
            trigger OnAfterGetRecord()
            begin
                CalcFields("Amount Including VAT");
                FormatNotoText("Amount Including VAT");
                if Customer.Get(SalesHeader."Sell-to Customer No.")then;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        GeneralLedgerSetup.Get();
    end;
    trigger OnPreReport()
    begin
    end;
    var CompanyInfo: Record "Company Information";
    Customer: Record Customer;
    GeneralLedgerSetup: Record "General Ledger Setup";
    RepCheck: Report 1401;
    AmountInWords: Text;
    NoText: array[2]of Text[80];
    local procedure FormatNotoText(Amt: Decimal)
    var
    begin
        RepCheck.InitTextVariable();
        RepCheck.FormatNoText(NoText, Amt, GeneralLedgerSetup."LCY Code");
        AmountInWords:=NoText[1];
    end;
}
