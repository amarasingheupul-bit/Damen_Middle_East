report 50109 "Clear General Ledger Entries"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Clear Posted Gen Ledger Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = RIMD;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }
    }
}