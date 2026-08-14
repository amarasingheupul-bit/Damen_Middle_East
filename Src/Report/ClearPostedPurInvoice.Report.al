report 50102 "Clear Posted Pur Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Clear Posted Purch Invoices';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Purch. Inv. Header" = RIMD,
                    tabledata "Purch. Inv. Line" = RIMD;

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }

        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }
    }
}