/* report 50104 "4HC Purchase Invoice"
{
    Caption = 'Purchase Invoice';
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
            column(ReportTitleLbl; ReportTitleLbl)
            {
            }
            column(HeaderLbl; HeaderLbl)
            {
            }
            column(BodyLbl; BodyLbl)
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
            dataitem(PurchaseLine; "Purchase Line")
            {
                column(No_PurchaseLine; "No.")
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
            }
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
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
        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
        CompanyInformation.CalcFields("Report Footer");
    end;

    var
        CompanyInformation: Record "Company Information";
        ReportTitleLbl: Label 'Purchase Order';
        HeaderLbl: Label 'All invoices, transport documents and correspondence must be marked with the Purchase order number';
        BodyLbl: Label 'This purchase order is created for engineering activities as per agreement with reference CONTRACT No.';
} */