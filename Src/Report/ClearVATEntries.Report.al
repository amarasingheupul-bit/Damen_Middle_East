report 50108 "Clear VAT Entries"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Clear Posted VAT Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "VAT Entry" = RIMD;

    dataset
    {
        dataitem("VAT Entry"; "VAT Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }
    }
}