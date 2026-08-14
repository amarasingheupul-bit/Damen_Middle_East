report 50125 "Cust Ledger LCY Change Report"
{
    Caption = 'Customer Ledger Amount (LCY) Change - Processed Only';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;   // <-- runs silently, no layout / no screen output
    Permissions = tabledata "Cust. Ledger Entry" = RIMD,
                  tabledata "G/L Entry" = RIMD,
                  tabledata "Detailed Cust. Ledg. Entry" = RIMD,
                  tabledata "Bank Account Ledger Entry" = RIMD;

    dataset
    {
        dataitem(Correction; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1 .. 9));

            trigger OnAfterGetRecord()
            begin
                LoadCorrection(Number, CurrentDocNo, CurrentCustNo, CurrentNewAmountLCY);

                if (CurrentDocNo = '') or (CurrentNewAmountLCY = 0) then
                    exit;

                UpdateCustLedgerEntry();
                // UpdateGLEntry();
                // UpdateDetailedCustLedgEntry();
                // UpdateBankAccountLedgerEntry();
            end;
        }
    }

    trigger OnPostReport()
    begin
        Message('Updated Amount (LCY) on %1 record(s) total, across 9 hardcoded corrections.', UpdatedCount);
    end;

    var
        CurrentDocNo: Code[20];
        CurrentCustNo: Code[20];
        CurrentNewAmountLCY: Decimal;
        UpdatedCount: Integer;

    // ---------------------------------------------------------------
    // HARDCODED CORRECTIONS - edit this list to add/change rows.
    // Values taken from your spreadsheet:
    //   Document No. | Customer No. | Correct LCY
    // ---------------------------------------------------------------
    local procedure LoadCorrection(LineNo: Integer; var DocNo: Code[20]; var CustNo: Code[20]; var CorrectLCY: Decimal)
    begin
        case LineNo of
            1:
                begin
                    DocNo := 'CRJ-00012';
                    CustNo := 'C00011';
                    CorrectLCY := -1017403.20;
                end;
            2:
                begin
                    DocNo := 'CRJ-00022';
                    CustNo := 'C00080';
                    CorrectLCY := -9616.98;
                end;
            3:
                begin
                    DocNo := 'CRJ-00008';
                    CustNo := 'C00080';
                    CorrectLCY := -22637.79;
                end;
            4:
                begin
                    DocNo := 'PSI-2025-11-00020';
                    CustNo := 'C00080';
                    CorrectLCY := 106060.00;
                end;
            5:
                begin
                    DocNo := 'PSI-2025-11-00018';
                    CustNo := 'C00011';
                    CorrectLCY := 19090.80;
                end;
            6:
                begin
                    DocNo := 'PSI-2025-11-00012';
                    CustNo := 'C00011';
                    CorrectLCY := 499360.00;
                end;
            7:
                begin
                    DocNo := 'PSI-2025-11-00006';
                    CustNo := 'C00080';
                    CorrectLCY := 8263.13;
                end;
            8:
                begin
                    DocNo := 'PSI-2025-11-00003';
                    CustNo := 'C00080';
                    CorrectLCY := 6242.69;
                end;
            9:
                begin
                    DocNo := 'PSI-2025-11-00001';
                    CustNo := 'C00080';
                    CorrectLCY := 127188.00;
                end;
            else begin
                DocNo := '';
                CustNo := '';
                CorrectLCY := 0;
            end;
        end;
    end;

    local procedure UpdateCustLedgerEntry()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Document No.", CurrentDocNo);

        if not CustLedgerEntry.FindSet() then
            exit;

        repeat
            if CustLedgerEntry."Amount (LCY)" <> CurrentNewAmountLCY then begin
                CustLedgerEntry."Amount (LCY)" := CurrentNewAmountLCY;
                CustLedgerEntry.Modify(true);
                UpdatedCount += 1;
            end;
        until CustLedgerEntry.Next() = 0;
    end;

    local procedure UpdateGLEntry()
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.SetRange("Document No.", CurrentDocNo);
        GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
        GLEntry.SetRange("Source No.", CurrentCustNo);

        if not GLEntry.FindSet() then
            exit;

        repeat
            if GLEntry.Amount <> CurrentNewAmountLCY then begin
                GLEntry.Amount := CurrentNewAmountLCY;
                GLEntry.Modify(true);
                UpdatedCount += 1;
            end;
        until GLEntry.Next() = 0;
    end;

    local procedure UpdateDetailedCustLedgEntry()
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DetailedCustLedgEntry.SetRange("Document No.", CurrentDocNo);
        DetailedCustLedgEntry.SetRange("Customer No.", CurrentCustNo);
        DetailedCustLedgEntry.SetRange("Entry Type", DetailedCustLedgEntry."Entry Type"::"Initial Entry");

        if not DetailedCustLedgEntry.FindSet() then
            exit;

        repeat
            if DetailedCustLedgEntry."Amount (LCY)" <> CurrentNewAmountLCY then begin
                DetailedCustLedgEntry."Amount (LCY)" := CurrentNewAmountLCY;
                DetailedCustLedgEntry.Modify(true);
                UpdatedCount += 1;
            end;
        until DetailedCustLedgEntry.Next() = 0;
    end;

    local procedure UpdateBankAccountLedgerEntry()
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccountLedgerEntry.SetRange("Document No.", CurrentDocNo);

        if not BankAccountLedgerEntry.FindSet() then
            exit;

        repeat
            if BankAccountLedgerEntry."Amount (LCY)" <> CurrentNewAmountLCY then begin
                BankAccountLedgerEntry."Amount (LCY)" := CurrentNewAmountLCY;
                BankAccountLedgerEntry.Modify(true);
                UpdatedCount += 1;
            end;
        until BankAccountLedgerEntry.Next() = 0;
    end;
}
