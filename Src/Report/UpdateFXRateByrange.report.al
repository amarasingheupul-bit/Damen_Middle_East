#pragma warning disable AA0215
report 50113 "Range UPdate FX Rates Report"
#pragma warning restore AA0215
{

    UsageCategory = ReportsAndAnalysis;
    Caption = 'Bulk Update PSI FX Entries';
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

                // Filter Selection
                "Sales Invoice Header".SetFilter("No.", "No.");

                if "Sales Invoice Header".FindSet() then
                    repeat
                        // Update the "Credit Limit (LCY)" for these customers
                        "Sales Invoice Header"."FX Rate" := NewFXRate;
                        "Sales Invoice Header".Modify();
                    until "Sales Invoice Header".Next() = 0;

                Message('FX Rate updated successfully.');


                //    end;
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
                    field(NewAccount; NewFXRate)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Rate';
                        Caption = 'New Rate';
                    }

                }
            }
        }
    }


    var
        NewFXRate: Decimal;

}