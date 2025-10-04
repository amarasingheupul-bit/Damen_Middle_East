report 50101 "Update GL Entries"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Update General Ledger Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = RIMD;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")

        {
            RequestFilterFields = "Document No.", "G/L Account No.", "Entry No.";
            trigger OnAfterGetRecord()
            begin

                if GetFilter("Entry No.") <> '' then begin

                    if NewAccountx <> '' then "G/L Account No." := NewAccountx;
                    if NewAmountx <> 0 then Amount := NewAmountx;
                    if NewDebitAmountx <> 0 then "Debit Amount" := NewDebitAmountx;
                    if NewCreditAmountx <> 0 then "Credit Amount" := NewCreditAmountx;
                    if NewVatAmountx <> 0 then "VAT Amount" := NewVatAmountx;
                    if AmountZerox = true then Amount := 0;
                    if DebitZerox = true then "Debit Amount" := 0;
                    if CreditZerox = true then "Credit Amount" := 0;
                    if VATZerox = true then "VAT Amount" := 0;
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
                    field(NewAccount; NewAccountx)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Account';
                        Caption = 'New Account';
                    }
                    field(NewAmount; NewAmountx)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New Amount';
                        Caption = 'New Amount';
                    }
                    field(NewCreditAmount; NewCreditAmountx)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New CreditAmount';
                        Caption = 'New CreditAmount';
                    }
                    field(NewDebitAmount; NewDebitAmountx)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New DEbit Amount';
                        Caption = 'New Debit Amount';
                    }
                    field(NewVatAmount; NewVatAmountx)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'New VAT Amount';
                        Caption = 'New VAT Amount';
                    }
                    field(AmountZero; AmountZerox)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'Zero Amount';
                        Caption = 'Zero Amount';
                    }
                    field(DebitZero; DebitZerox)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'Zero Debit';
                        Caption = 'Zero DEbit';
                    }
                    field(CreditZero; CreditZerox)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'Zero Credit';
                        Caption = 'Zero Credit';
                    }
                    field(VATZero; VATZerox)
                    {
                        ApplicationArea = All;
                        MultiLine = true;
                        ToolTip = 'Zero VAT';
                        Caption = 'Zero VAT';
                    }


                }
            }
        }
    }


    var
        NewAccountx: Text[20];
        NewDebitAmountx: Decimal;
        DebitZerox: Boolean;
        NewCreditAmountx: Decimal;
        CreditZerox: Boolean;
        NewVatAmountx: Decimal;
        VATZerox: Boolean;
        NewAmountx: Decimal;
        AmountZerox: Boolean;

}