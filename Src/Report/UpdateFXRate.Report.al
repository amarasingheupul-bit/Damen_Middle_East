report 50111 "Update PSI Data FX_BNK_Terms"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Update PSI BnkDtl FX Terms Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Header" = RIMD;

    dataset
    {
        dataitem("Sales Invoice Header";"Sales Invoice Header")

        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin

                if this.NewBankDtl <> '' then
                    "Sales Invoice Header"."Bank Details" := this.NewBankDtl;
                
                if this.NewFXRate <> 0 then "Sales Invoice Header"."FX Rate" := this.NewFXRate;

                if this.NewBankDtl <> '' then "Sales Invoice Header"."Payment Terms Code" := '0D';
       
                Modify();

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
                    field(NewFXRate; NewFXRate)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Rate';
                        Caption = 'New Rate';
                        DecimalPlaces = 0 : 5;
                    }
                    field(NewBankDetails; NewBankDtl)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Bank Account';
                        Caption = 'New Bank Account';
                    }

                }
            }
        }
    }


    var
        NewFXRate: Decimal;
        NewBankDtl: Text;


}