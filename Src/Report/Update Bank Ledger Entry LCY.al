report 50126 "Update Bank Ledger Entry LCY"
{
    ProcessingOnly = true;
    Caption = 'Update Bank Ledger Entry Amount (LCY)';
    UsageCategory = Administration;
    ApplicationArea = All;
    Permissions = tabledata "Bank Account Ledger Entry" = RIMD,
    tabledata "G/L Entry" = RIMD;

    dataset
    {
        dataitem(BankAccLedgEntry; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Document No.", "Entry No.";

            trigger OnAfterGetRecord()
            begin
                if NewAmountLCY = 0 then
                    Error('Please enter a new Amount (LCY) value.');

                BankAccLedgEntry.TestField("Entry No.");

                BankAccLedgEntry."Amount (LCY)" := NewAmountLCY;
                BankAccLedgEntry.Amount := NewsourceAmountLCY;
                BankAccLedgEntry.Modify(true);

                Message('Entry No. %1 (Document No. %2) updated. New Amount (LCY) = %3',
                    BankAccLedgEntry."Entry No.",
                    BankAccLedgEntry."Document No.",
                    NewAmountLCY, NewsourceAmountLCY);
            end;
        }
        // dataitem("G/L Entry"; "G/L Entry")
        // {
        //     RequestFilterFields = "Document No.", "Entry No.";
        //     trigger OnAfterGetRecord()
        //     begin
        //         if NewsourceAmountLCY = 0 then
        //             Error('Please enter a new Amount (LCY) value.');

        //         "G/L Entry".TestField("Entry No.");

        //         "G/L Entry"."Source Currency Amount" := NewsourceAmountLCY;
        //         // BankAccLedgEntry."Remaining Amt. (LCY)" := NewAmountLCY;
        //         "G/L Entry".Modify(true);

        //         Message('Entry No. %1 (Document No. %2) updated. New Amount (LCY) = %3',
        //             "G/L Entry"."Entry No.",
        //             "G/L Entry"."Document No.",
        //             NewsourceAmountLCY);
        //     end;

        // }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(NewAmountLCYField; NewAmountLCY)
                    {
                        Caption = 'New Amount (LCY)';
                        ApplicationArea = All;
                    }
                    field(NewsourceLCYField; NewsourceAmountLCY)
                    {
                        Caption = 'NewsourceAmountLCY';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        NewAmountLCY: Decimal;
        NewsourceAmountLCY: Decimal;
}