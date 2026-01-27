#pragma warning disable AA0215
report 50112 "Update SalInv Fields Report"
#pragma warning restore AA0215
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Update Posted SI Entries';
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

                    if this.NewFieldCode <> '' then "Currency Code" := this.NewFieldCode;
                    if this.NewFieldDec <> 0 then "Amount" := this.NewFieldDec;
                    if this.NewFieldText <> '' then "Bank Details" := this.NewFieldText;

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
                        ToolTip = 'New Currency Code';
                        Caption = 'New Currency Code';
                    }

                    field(NewFieldDec; NewFieldDec)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Amount';
                        Caption = 'New Amount';
                    }

                    field(NewFieldText; NewFieldText)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Text';
                        Caption = 'New Text';
                    }

                }
            }
        }
    }


    var

        NewFieldCode: Code[10];
        NewFieldDec: Decimal;
        NewFieldText: Text[20];
}