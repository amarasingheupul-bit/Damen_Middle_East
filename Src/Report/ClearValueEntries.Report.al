report 50107 "Clear Value Entries"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Clear Posted Value Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Value Entry" = RIMD;

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }
    }
}