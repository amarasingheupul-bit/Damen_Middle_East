report 50106 "Clear Vendor Ledger Entries"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Clear Vendor Ledger Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Vendor Ledger Entry" = RIMD,
                    tabledata "Detailed Vendor Ledg. Entry" = RIMD;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }

        dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }
    }
}