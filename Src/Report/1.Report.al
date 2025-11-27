report 50110 "Update PSI Details"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Update PSI Details';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Header" = RIMD;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")

        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin
                if GetFilter("No.") <> '' then begin
                    if this.NewValue <> '' then
                        "Bank Details" := this.NewValue;
                    Modify();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Option)
                {
                    field(NewValue; NewValue)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Value';
                        Caption = 'New Value';
                    }
                }
            }
        }
    }

    var
        NewValue: Text[20];

}