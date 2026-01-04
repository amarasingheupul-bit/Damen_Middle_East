#pragma warning disable AA0215
report 50112 "Update SalInv Fields Report"
#pragma warning restore AA0215
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Update SI Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Header" = RIMD;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")

        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin

                if GetFilter("No.") <> '' then begin

                    if this.NewFieldCode <> '' then "Currency Code" := this.NewFieldCode;
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
                    field(NewFieldCode; NewFieldCode)
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
        //    NewFieldDec: Decimal;
        //   NewFieldText: Text;
        NewFieldCode: Code[10];
}