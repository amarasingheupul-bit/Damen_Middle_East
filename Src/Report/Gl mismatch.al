report 50123 "GL Bank Mismatch Check"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'GL vs Bank Ledger Mismatch Check';

    dataset
    {
        dataitem(DummyItem; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                CurrReport.Break();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    Caption = 'Mismatch Check Parameters';

                    field(GLAccountNoReq; GLAccountNo)
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Account No.';
                        TableRelation = "G/L Account";
                        ToolTip = 'Specify the G/L Account to compare against the bank account.';

                        trigger OnValidate()
                        begin
                            UpdateDocCountPreview();
                        end;
                    }
                    field(BankAccountNoReq; BankAccountNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Ledger No.';
                        TableRelation = "Bank Account";
                        ToolTip = 'Specify the Bank Account whose ledger entries should be compared.';

                        trigger OnValidate()
                        begin
                            UpdateDocCountPreview();
                        end;
                    }
                    field(StartDateReq; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        ToolTip = 'Optional. Leave blank to include all entries.';

                        trigger OnValidate()
                        begin
                            UpdateDocCountPreview();
                        end;
                    }
                    field(EndDateReq; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Optional. Leave blank to include all entries.';

                        trigger OnValidate()
                        begin
                            UpdateDocCountPreview();
                        end;
                    }
                    field(DateToleranceReq; DateToleranceDays)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Tolerance (Days)';
                        ToolTip = 'Used only as a fallback when Document No. does not match between G/L and Bank. Entries with the same Amount posted within this many days of each other are treated as matched. 0 = same day only.';
                        MinValue = 0;
                    }
                    field(ShowMatchedTooReq; ShowMatchedToo)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Matched Entries';
                        ToolTip = 'If enabled, entries that matched fine are also shown in the detail list. Summary counts always include them regardless of this setting.';
                    }
                }
                group(DocCountPreview)
                {
                    Caption = 'Document No. Count Preview';

                    field(GLDocNoCountPreviewReq; GLDocNoCountPreview)
                    {
                        ApplicationArea = All;
                        Caption = 'G/L Doc No. Count';
                        Editable = false;
                    }
                    field(BankDocNoCountPreviewReq; BankDocNoCountPreview)
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Ledger Doc No. Count';
                        Editable = false;
                    }
                    field(DocCountDifferenceReq; DocCountDifferencePreview)
                    {
                        ApplicationArea = All;
                        Caption = 'Difference';
                        Editable = false;
                        StyleExpr = DifferenceStyleExpr;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if GLAccountNo = '' then
            Error('Please enter a G/L Account No.');
        if BankAccountNo = '' then
            Error('Please enter a Bank Ledger No.');

        MatchMgt.RunMatch(GLAccountNo, BankAccountNo, StartDate, EndDate, DateToleranceDays, ResultBuffer, GLEntryCount, BankEntryCount, GLDocNoCount, BankDocNoCount);

        // ---- Count each status straight from the buffer BEFORE anything
        //      gets filtered out, so the counts are always accurate ----
        ResultBuffer.Reset();
        ResultBuffer.SetRange(Status, ResultBuffer.Status::Matched);
        MatchedCount := ResultBuffer.Count();

        ResultBuffer.SetRange(Status, ResultBuffer.Status::Mismatched);
        MismatchedCount := ResultBuffer.Count();

        ResultBuffer.SetRange(Status, ResultBuffer.Status::"Missing in Bank");
        MissingInBankCount := ResultBuffer.Count();

        ResultBuffer.SetRange(Status, ResultBuffer.Status::"Missing in GL");
        MissingInGLCount := ResultBuffer.Count();

        ResultBuffer.Reset();

        // ---- Now apply the display filter (detail list only, counts above
        //      already captured the real totals) ----
        if not ShowMatchedToo then begin
            ResultBuffer.SetRange(Status, ResultBuffer.Status::Matched);
            ResultBuffer.DeleteAll();
            ResultBuffer.Reset();
        end;
    end;

    trigger OnPostReport()
    var
        ResultPage: Page "GL Bank Mismatch Result";
        ProblemCount: Integer;
    begin
        ProblemCount := MismatchedCount + MissingInBankCount + MissingInGLCount;

        if ProblemCount = 0 then
            Message('No mismatches found for G/L Account %1 vs Bank Ledger %2.\G/L Entries: %3 (%4 Doc Nos.)\Bank Ledger Entries: %5 (%6 Doc Nos.)\Matched: %7',
                GLAccountNo, BankAccountNo, GLEntryCount, GLDocNoCount, BankEntryCount, BankDocNoCount, MatchedCount)
        else begin
            Message('Mismatch Check Complete for G/L Account %1 vs Bank Ledger %2.\G/L Entries: %3 (%4 Doc Nos.)\Bank Ledger Entries: %5 (%6 Doc Nos.)\Matched: %7\Mismatched: %8\Missing in Bank: %9\Missing in GL: %10',
                GLAccountNo, BankAccountNo, GLEntryCount, GLDocNoCount, BankEntryCount, BankDocNoCount, MatchedCount, MismatchedCount, MissingInBankCount, MissingInGLCount);

            ResultPage.SetRecords(ResultBuffer, GLAccountNo, BankAccountNo, GLEntryCount, BankEntryCount, GLDocNoCount, BankDocNoCount);
            ResultPage.RunModal();
        end;
    end;

    local procedure UpdateDocCountPreview()
    begin
        if (GLAccountNo = '') or (BankAccountNo = '') then begin
            Clear(GLDocNoCountPreview);
            Clear(BankDocNoCountPreview);
            Clear(DocCountDifferencePreview);
            Clear(DifferenceStyleExpr);
            exit;
        end;

        MatchMgt.GetDocNoCounts(GLAccountNo, BankAccountNo, StartDate, EndDate, GLDocNoCountPreview, BankDocNoCountPreview);
        DocCountDifferencePreview := GLDocNoCountPreview - BankDocNoCountPreview;

        if DocCountDifferencePreview <> 0 then
            DifferenceStyleExpr := 'Unfavorable'
        else
            DifferenceStyleExpr := 'Favorable';
    end;

    var
        MatchMgt: Codeunit "GL Bank Match Mgt";
        ResultBuffer: Record "GL Bank Match Buffer" temporary;
        GLAccountNo: Code[20];
        BankAccountNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        DateToleranceDays: Integer;
        ShowMatchedToo: Boolean;
        GLEntryCount: Integer;
        BankEntryCount: Integer;
        GLDocNoCount: Integer;
        BankDocNoCount: Integer;
        MatchedCount: Integer;
        MismatchedCount: Integer;
        MissingInBankCount: Integer;
        MissingInGLCount: Integer;
        GLDocNoCountPreview: Integer;
        BankDocNoCountPreview: Integer;
        DocCountDifferencePreview: Integer;
        DifferenceStyleExpr: Text;
}
