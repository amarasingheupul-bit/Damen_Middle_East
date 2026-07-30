codeunit 50113 "Cust. Currency Adjustment"
{
    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Detailed Cust. Ledg. Entry" = rmi,
                  TableData "G/L Entry" = r;

    procedure AdjustCustLedgerEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; AdjustmentDate: Date)
    var
        Customer: Record Customer;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GenJnlLine: Record "Gen. Journal Line";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        //DimMgt: Codeunit "Dimension Management";
        OldRemainingLCY: Decimal;
        NewRemainingLCY: Decimal;
        GainLossLCY: Decimal;
        GLAccountNo: Code[20];
        NextDtldEntryNo: Integer;
        ExchRateFound: Boolean;
    begin
        // ---- 0. Guards ----
        if CustLedgerEntry."Currency Code" = '' then
            exit; // already LCY, nothing to revalue

        if CustLedgerEntry.Open = false then
            exit; // closed entries are not revalued

        CustLedgerEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
        if CustLedgerEntry."Remaining Amount" = 0 then
            exit;

        if not Currency.Get(CustLedgerEntry."Currency Code") then
            Error('Currency %1 does not exist.', CustLedgerEntry."Currency Code");

        Currency.TestField("Realized Gains Acc.");
        Currency.TestField("Realized Losses Acc.");

        if not Customer.Get(CustLedgerEntry."Customer No.") then
            Error('Customer %1 does not exist.', CustLedgerEntry."Customer No.");

        // ---- 1. Confirm an exchange rate exists for the target date ----
        CurrExchRate.SetRange("Currency Code", CustLedgerEntry."Currency Code");
        CurrExchRate.SetFilter("Starting Date", '<=%1', AdjustmentDate);
        ExchRateFound := CurrExchRate.FindLast();
        if not ExchRateFound then
            Error('No exchange rate exists for currency %1 on or before %2.',
                CustLedgerEntry."Currency Code", AdjustmentDate);

        // ---- 2. Old vs new LCY value of the remaining amount ----
        OldRemainingLCY := CustLedgerEntry."Remaining Amt. (LCY)";

        NewRemainingLCY := Round(
            CurrExchRate.ExchangeAmtFCYToLCY(
                AdjustmentDate,
                CustLedgerEntry."Currency Code",
                CustLedgerEntry."Remaining Amount",
                CurrExchRate.ExchangeRate(AdjustmentDate, CustLedgerEntry."Currency Code")),
            Currency."Amount Rounding Precision");

        GainLossLCY := NewRemainingLCY - OldRemainingLCY;

        if GainLossLCY = 0 then
            exit; // no movement — nothing to post

        // ---- 3. Sign convention for RECEIVABLES ----
        // Remaining Amount on a Cust. Ledger Entry is negative for a normal invoice
        // is actually positive for invoices (customer owes us), negative for payments/credits.
        // If the LCY value of what they owe INCREASES (NewRemainingLCY more positive
        // than OldRemainingLCY for a debit balance), that is a GAIN for us.
        // GainLossLCY > 0 means NewRemainingLCY > OldRemainingLCY -> balance owed to us grew -> Gain.
        if GainLossLCY > 0 then
            GLAccountNo := Currency."Realized Gains Acc."
        else
            GLAccountNo := Currency."Realized Losses Acc.";

        // ---- 4. Post G/L side ----
        GenJnlLine.Init();
        GenJnlLine."Posting Date" := AdjustmentDate;
        GenJnlLine."Document Date" := AdjustmentDate;
        GenJnlLine."Document No." := CustLedgerEntry."Document No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := GLAccountNo;
        GenJnlLine."Posting Group" := Customer."Customer Posting Group";
        GenJnlLine."Currency Code" := '';                  // pure LCY line
        GenJnlLine.Amount := -GainLossLCY;
        GenJnlLine."Amount (LCY)" := -GainLossLCY;
        GenJnlLine."Source Currency Amount" := 0;
        GenJnlLine."Shortcut Dimension 1 Code" := Customer."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := Customer."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := CustLedgerEntry."Dimension Set ID";
        GenJnlLine.Description := StrSubstNo('Currency adjmt. %1 %2', CustLedgerEntry."Customer No.", CustLedgerEntry."Document No.");
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := 'CURRADJMT';
        GenJnlLine."Reason Code" := '';
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        // ---- 5. Detailed Cust. Ledger Entry trace row ----
        DtldCustLedgEntry.LockTable();
        NextDtldEntryNo := GetLastDtldEntryNo() + 1;

        DtldCustLedgEntry.Init();
        DtldCustLedgEntry."Entry No." := NextDtldEntryNo;
        DtldCustLedgEntry."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
        DtldCustLedgEntry."Customer No." := CustLedgerEntry."Customer No.";
        DtldCustLedgEntry."Posting Date" := AdjustmentDate;
        DtldCustLedgEntry."Document No." := CustLedgerEntry."Document No.";
        DtldCustLedgEntry."Document Type" := CustLedgerEntry."Document Type";
        DtldCustLedgEntry."Currency Code" := CustLedgerEntry."Currency Code";
        //DtldCustLedgEntry."Transaction No." := GenJnlLine."Transaction No.";
        if GainLossLCY > 0 then
            DtldCustLedgEntry."Entry Type" := DtldCustLedgEntry."Entry Type"::"Realized Gain"
        else
            DtldCustLedgEntry."Entry Type" := DtldCustLedgEntry."Entry Type"::"Realized Loss";
        DtldCustLedgEntry.Amount := 0;                     // FCY leg untouched
        DtldCustLedgEntry."Amount (LCY)" := -GainLossLCY;
        DtldCustLedgEntry."Ledger Entry Amount" := true;
        DtldCustLedgEntry.Insert(true);

        // ---- 6. Update ONLY the running remaining balance ----
        // CustLedgerEntry."Amount (LCY)" is the frozen, original-posting value.
        // It is intentionally never written to here.
        CustLedgerEntry.Get(CustLedgerEntry."Entry No."); // re-fetch, avoid stale record
        CustLedgerEntry."Remaining Amt. (LCY)" := NewRemainingLCY;
        CustLedgerEntry.Modify();
    end;

    local procedure GetLastDtldEntryNo(): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        if DtldCustLedgEntry.FindLast() then
            exit(DtldCustLedgEntry."Entry No.");
        exit(0);
    end;

    procedure AdjustAllOpenEntriesForCustomer(CustomerNo: Code[20]; AdjustmentDate: Date)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetFilter("Currency Code", '<>%1', '');
        if CustLedgerEntry.FindSet() then
            repeat
                AdjustCustLedgerEntry(CustLedgerEntry, AdjustmentDate);
            until CustLedgerEntry.Next() = 0;
    end;
}