codeunit 50112 "GL Bank Match Mgt"
{
    procedure RunMatch(GLAccountNo: Code[20]; BankAccountNo: Code[20]; StartDate: Date; EndDate: Date; DateToleranceDays: Integer; var ResultBuffer: Record "GL Bank Match Buffer" temporary; var GLEntryCount: Integer; var BankEntryCount: Integer; var GLDocNoCount: Integer; var BankDocNoCount: Integer)
    var
        GLEntry: Record "G/L Entry";
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        GLLine: Record "GL Match Line" temporary;
        BankLine: Record "Bank Match Line" temporary;
        DistinctGLDocs: Dictionary of [Code[20], Boolean];
        DistinctBankDocs: Dictionary of [Code[20], Boolean];
    begin
        ResultBuffer.Reset();
        ResultBuffer.DeleteAll();
        GLLine.Reset();
        GLLine.DeleteAll();
        BankLine.Reset();
        BankLine.DeleteAll();

        // ---- G/L side: filter, count raw entries, then group into lines ----
        GLEntry.SetRange("G/L Account No.", GLAccountNo);
        if StartDate <> 0D then
            GLEntry.SetRange("Posting Date", StartDate, EndDate);
        GLEntryCount := GLEntry.Count();
        if GLEntry.FindSet() then
            repeat
                AddToGLLine(GLLine, GLEntry."Document No.", GLEntry."Posting Date", GLEntry.Amount, GLEntry."Entry No.");
                if not DistinctGLDocs.ContainsKey(GLEntry."Document No.") then
                    DistinctGLDocs.Add(GLEntry."Document No.", true);
            until GLEntry.Next() = 0;
        GLDocNoCount := DistinctGLDocs.Count();

        // ---- Bank side: filter, count raw entries, then group into lines ----
        BankLedgerEntry.SetRange("Bank Account No.", BankAccountNo);
        if StartDate <> 0D then
            BankLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
        BankEntryCount := BankLedgerEntry.Count();
        if BankLedgerEntry.FindSet() then
            repeat
                AddToBankLine(BankLine, BankLedgerEntry."Document No.", BankLedgerEntry."Posting Date", BankLedgerEntry.Amount, BankLedgerEntry."Entry No.");
                if not DistinctBankDocs.ContainsKey(BankLedgerEntry."Document No.") then
                    DistinctBankDocs.Add(BankLedgerEntry."Document No.", true);
            until BankLedgerEntry.Next() = 0;
        BankDocNoCount := DistinctBankDocs.Count();

        // ---- Stage 1: match by Document No. (Matched if Amount also agrees,
        //      Mismatched if Document No. agrees but Amount does not) ----
        GLLine.Reset();
        if GLLine.FindSet() then
            repeat
                BankLine.Reset();
                BankLine.SetRange(Matched, false);
                BankLine.SetRange("Document No.", GLLine."Document No.");
                if BankLine.FindFirst() then begin
                    InsertResult(ResultBuffer, GLLine."Document No.", BankLine."Document No.", GLLine."Posting Date",
                        GLLine.Amount, BankLine.Amount, GLLine."Entry No.", BankLine."Entry No.", 'Document No.');
                    GLLine.Matched := true;
                    GLLine.Modify();
                    BankLine.Matched := true;
                    BankLine.Modify();
                end;
            until GLLine.Next() = 0;

        // ---- Stage 2: fallback match by Amount + Posting Date (tolerance),
        //      only for lines that had no Document No. counterpart at all ----
        GLLine.Reset();
        GLLine.SetRange(Matched, false);
        if GLLine.FindSet() then
            repeat
                BankLine.Reset();
                BankLine.SetRange(Matched, false);
                BankLine.SetRange(Amount, GLLine.Amount);
                if DateToleranceDays > 0 then
                    BankLine.SetRange("Posting Date", GLLine."Posting Date" - DateToleranceDays, GLLine."Posting Date" + DateToleranceDays)
                else
                    BankLine.SetRange("Posting Date", GLLine."Posting Date");
                if BankLine.FindFirst() then begin
                    InsertResult(ResultBuffer, GLLine."Document No.", BankLine."Document No.", GLLine."Posting Date",
                        GLLine.Amount, BankLine.Amount, GLLine."Entry No.", BankLine."Entry No.", 'Amount & Date');
                    GLLine.Matched := true;
                    GLLine.Modify();
                    BankLine.Matched := true;
                    BankLine.Modify();
                end;
            until GLLine.Next() = 0;

        // ---- Stage 3: still-unmatched G/L lines -> Missing in Bank ----
        GLLine.Reset();
        GLLine.SetRange(Matched, false);
        if GLLine.FindSet() then
            repeat
                InsertResult(ResultBuffer, GLLine."Document No.", '', GLLine."Posting Date", GLLine.Amount, 0, GLLine."Entry No.", 0, '');
            until GLLine.Next() = 0;

        // ---- Stage 3: still-unmatched Bank lines -> Missing in GL ----
        BankLine.Reset();
        BankLine.SetRange(Matched, false);
        if BankLine.FindSet() then
            repeat
                InsertResult(ResultBuffer, '', BankLine."Document No.", BankLine."Posting Date", 0, BankLine.Amount, 0, BankLine."Entry No.", '');
            until BankLine.Next() = 0;
    end;

    // Lightweight preview: just counts distinct Document Nos. on each side,
    // without running the full match. Used to show live counts on the
    // request page as soon as the accounts are entered.
    procedure GetDocNoCounts(GLAccountNo: Code[20]; BankAccountNo: Code[20]; StartDate: Date; EndDate: Date; var GLDocNoCount: Integer; var BankDocNoCount: Integer)
    var
        GLEntry: Record "G/L Entry";
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        DistinctGLDocs: Dictionary of [Code[20], Boolean];
        DistinctBankDocs: Dictionary of [Code[20], Boolean];
    begin
        Clear(GLDocNoCount);
        Clear(BankDocNoCount);

        if GLAccountNo <> '' then begin
            GLEntry.SetRange("G/L Account No.", GLAccountNo);
            if StartDate <> 0D then
                GLEntry.SetRange("Posting Date", StartDate, EndDate);
            if GLEntry.FindSet() then
                repeat
                    if not DistinctGLDocs.ContainsKey(GLEntry."Document No.") then
                        DistinctGLDocs.Add(GLEntry."Document No.", true);
                until GLEntry.Next() = 0;
            GLDocNoCount := DistinctGLDocs.Count();
        end;

        if BankAccountNo <> '' then begin
            BankLedgerEntry.SetRange("Bank Account No.", BankAccountNo);
            if StartDate <> 0D then
                BankLedgerEntry.SetRange("Posting Date", StartDate, EndDate);
            if BankLedgerEntry.FindSet() then
                repeat
                    if not DistinctBankDocs.ContainsKey(BankLedgerEntry."Document No.") then
                        DistinctBankDocs.Add(BankLedgerEntry."Document No.", true);
                until BankLedgerEntry.Next() = 0;
            BankDocNoCount := DistinctBankDocs.Count();
        end;
    end;

    local procedure AddToGLLine(var GLLine: Record "GL Match Line" temporary; DocumentNo: Code[20]; PostingDate: Date; Amount: Decimal; SourceEntryNo: Integer)
    var
        LastLineNo: Integer;
    begin
        GLLine.Reset();
        GLLine.SetRange("Document No.", DocumentNo);
        GLLine.SetRange("Posting Date", PostingDate);
        if GLLine.FindFirst() then begin
            GLLine.Amount += Amount;
            GLLine."Entry No." := SourceEntryNo;
            GLLine.Modify();
            exit;
        end;

        GLLine.Reset();
        if GLLine.FindLast() then
            LastLineNo := GLLine."Line No.";

        GLLine.Init();
        GLLine."Line No." := LastLineNo + 1;
        GLLine."Document No." := DocumentNo;
        GLLine."Posting Date" := PostingDate;
        GLLine.Amount := Amount;
        GLLine."Entry No." := SourceEntryNo;
        GLLine.Insert();
    end;

    local procedure AddToBankLine(var BankLine: Record "Bank Match Line" temporary; DocumentNo: Code[20]; PostingDate: Date; Amount: Decimal; SourceEntryNo: Integer)
    var
        LastLineNo: Integer;
    begin
        BankLine.Reset();
        BankLine.SetRange("Document No.", DocumentNo);
        BankLine.SetRange("Posting Date", PostingDate);
        if BankLine.FindFirst() then begin
            BankLine.Amount += Amount;
            BankLine."Entry No." := SourceEntryNo;
            BankLine.Modify();
            exit;
        end;

        BankLine.Reset();
        if BankLine.FindLast() then
            LastLineNo := BankLine."Line No.";

        BankLine.Init();
        BankLine."Line No." := LastLineNo + 1;
        BankLine."Document No." := DocumentNo;
        BankLine."Posting Date" := PostingDate;
        BankLine.Amount := Amount;
        BankLine."Entry No." := SourceEntryNo;
        BankLine.Insert();
    end;

    local procedure InsertResult(var ResultBuffer: Record "GL Bank Match Buffer" temporary; GLDocNo: Code[20]; BankDocNo: Code[20]; PostingDate: Date; GLAmount: Decimal; BankAmount: Decimal; GLEntryNo: Integer; BankEntryNo: Integer; MatchMethod: Text[20])
    var
        LastEntryNo: Integer;
    begin
        ResultBuffer.Reset();
        if ResultBuffer.FindLast() then
            LastEntryNo := ResultBuffer."Entry No.";

        ResultBuffer.Init();
        ResultBuffer."Entry No." := LastEntryNo + 1;
        ResultBuffer."GL Document No." := GLDocNo;
        ResultBuffer."Bank Document No." := BankDocNo;
        ResultBuffer."Posting Date" := PostingDate;
        ResultBuffer."GL Amount" := GLAmount;
        ResultBuffer."Bank Amount" := BankAmount;
        ResultBuffer.Difference := GLAmount - BankAmount;
        ResultBuffer."GL Entry No." := GLEntryNo;
        ResultBuffer."Bank Ledger Entry No." := BankEntryNo;
        ResultBuffer."Match Method" := MatchMethod;

        case true of
            (GLDocNo <> '') and (BankDocNo = ''):
                ResultBuffer.Status := ResultBuffer.Status::"Missing in Bank";
            (BankDocNo <> '') and (GLDocNo = ''):
                ResultBuffer.Status := ResultBuffer.Status::"Missing in GL";
            ResultBuffer.Difference = 0:
                ResultBuffer.Status := ResultBuffer.Status::Matched;
            else
                ResultBuffer.Status := ResultBuffer.Status::Mismatched;
        end;

        ResultBuffer.Insert();
    end;
}

