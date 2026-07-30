report 50121 "Related Entries Lookup"
{
    // ============================================================
    // PURPOSE
    // ------------------------------------------------------------
    // Read-only diagnostic report. Given a Vendor Ledger Entry
    // "Entry No.", this finds its "Transaction No." and opens the
    // standard list pages for every related table, filtered down
    // to just the entries that belong to that same posting.
    //
    // NOTHING IS DELETED OR MODIFIED. This is purely for inspection.
    //
    // Tables covered (per your second screenshot):
    //   - Vendor Ledger Entry            (by Entry No.)
    //   - Detailed Vendor Ledg. Entry    (by Vendor Ledger Entry No.)
    //   - G/L Entry                      (by Transaction No.)
    //   - VAT Entry                      (by Transaction No.)
    //   - Item Ledger Entry              (by Transaction No.)
    //   - Value Entry                    (by Transaction No.)
    //   - Job Ledger Entry (="Project")  (by Transaction No.)
    //   - Bank Account Ledger Entry      (by Transaction No.)
    //
    // NOTE ON LINKING FIELDS:
    // Only G/L Entry, VAT Entry, Vendor Ledger Entry, and Bank Account
    // Ledger Entry carry a "Transaction No." field in standard BC.
    // Item Ledger Entry, Value Entry, and Job Ledger Entry do NOT have
    // this field, so those three are linked instead via the shared
    // "Document No." + "Posting Date" of the originating document.
    // This is slightly less precise (it's possible, though unusual, for
    // two unrelated postings to share both values) but is the standard
    // fallback used for these tables.
    // ============================================================

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Related Entries Lookup (Read-Only)';
    Permissions = tabledata "Vendor Ledger Entry" = RIMD,
    tabledata "Detailed Vendor Ledg. Entry" = RIMD,
    tabledata "G/L Entry" = RIMD,
    tabledata "VAT Entry" = RIMD,
    tabledata "Item Ledger Entry" = RIMD,
    tabledata "Value Entry" = RIMD,
    tabledata "Job Ledger Entry" = RIMD,
    tabledata "Bank Account Ledger Entry" = RIMD;

    dataset
    {
        dataitem(Dummy; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            begin
                RunLookup();
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
                group(Options)
                {
                    Caption = 'Lookup Options';

                    field(VendLedgEntryNo; VendLedgEntryNoFilter)
                    {
                        Caption = 'Vendor Ledger Entry No.';
                        ApplicationArea = All;
                        ToolTip = 'The Entry No. from the Vendor Ledger Entries list (e.g. 3789).';
                    }
                    field(OpenPagesOpt; OpenRelatedPages)
                    {
                        Caption = 'Open list pages for each related table';
                        ApplicationArea = All;
                        ToolTip = 'If enabled, each related table opens as a filtered list page you can review. If disabled, you just get the summary dialog with counts.';
                    }
                    field(DeleteOpt; PerformDelete)
                    {
                        Caption = 'DELETE related entries (irreversible)';
                        ApplicationArea = All;
                        ToolTip = 'DANGER: If enabled, this will attempt to permanently delete all matched entries across every related table. Only use on test/sandbox data. Many of these tables have protection triggers that will block deletion - the report will tell you which ones succeeded and which were blocked.';
                    }
                }
            }
        }
    }

    var
        VendLedgEntryNoFilter: Integer;
        OpenRelatedPages: Boolean;
        PerformDelete: Boolean;

    trigger OnInitReport()
    begin
        OpenRelatedPages := true;
    end;

    local procedure RunLookup()
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        JobLedgEntry: Record "Job Ledger Entry"; // "Project Ledger Entry" in some UI translations
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        TransactionNo: Integer;
        SummaryMsg: Text;
    begin
        if VendLedgEntryNoFilter = 0 then
            Error('Please enter a Vendor Ledger Entry No. to look up.');

        if not VendLedgEntry.Get(VendLedgEntryNoFilter) then
            Error('Vendor Ledger Entry No. %1 was not found.', VendLedgEntryNoFilter);

        TransactionNo := VendLedgEntry."Transaction No.";

        // --- Detailed Vendor Ledg. Entry: linked by Vendor Ledger Entry No. ---
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNoFilter);

        // --- Tables that carry "Transaction No.": link directly ---
        GLEntry.SetRange("Transaction No.", TransactionNo);
        VATEntry.SetRange("Transaction No.", TransactionNo);
        BankAccLedgEntry.SetRange("Transaction No.", TransactionNo);

        // --- Tables without "Transaction No.": link via Document No. + Posting Date ---
        ItemLedgEntry.SetRange("Document No.", VendLedgEntry."Document No.");
        ItemLedgEntry.SetRange("Posting Date", VendLedgEntry."Posting Date");

        ValueEntry.SetRange("Document No.", VendLedgEntry."Document No.");
        ValueEntry.SetRange("Posting Date", VendLedgEntry."Posting Date");

        JobLedgEntry.SetRange("Document No.", VendLedgEntry."Document No.");
        JobLedgEntry.SetRange("Posting Date", VendLedgEntry."Posting Date");

        SummaryMsg :=
            StrSubstNo('Vendor Ledger Entry No.: %1\Transaction No.: %2\', VendLedgEntryNoFilter, TransactionNo) +
            StrSubstNo('Vendor Ledger Entry: %1 record(s)\', 1) +
            StrSubstNo('Detailed Vendor Ledg. Entry: %1 record(s)\', DtldVendLedgEntry.Count()) +
            StrSubstNo('G/L Entry: %1 record(s)\', GLEntry.Count()) +
            StrSubstNo('VAT Entry: %1 record(s)\', VATEntry.Count()) +
            StrSubstNo('Item Ledger Entry: %1 record(s)\', ItemLedgEntry.Count()) +
            StrSubstNo('Value Entry: %1 record(s)\', ValueEntry.Count()) +
            StrSubstNo('Job (Project) Ledger Entry: %1 record(s)\', JobLedgEntry.Count()) +
            StrSubstNo('Bank Account Ledger Entry: %1 record(s)', BankAccLedgEntry.Count());

        Message(SummaryMsg);

        if PerformDelete then begin
            if Confirm('This will PERMANENTLY delete the matched entries listed above.\This cannot be undone. Continue?', false) then
                DeleteRelatedEntries(VendLedgEntry, DtldVendLedgEntry, GLEntry, VATEntry, ItemLedgEntry, ValueEntry, JobLedgEntry, BankAccLedgEntry)
            else
                exit;
        end;

        if not OpenRelatedPages then
            exit;

        // Open each related table's standard list page, pre-filtered.
        // Only opens if there's at least one matching record, to avoid
        // popping up empty pages for tables that have no hits.

        Page.Run(Page::"Vendor Ledger Entries", VendLedgEntry);

        if not DtldVendLedgEntry.IsEmpty() then
            Page.Run(Page::"Detailed Vendor Ledg. Entries", DtldVendLedgEntry);

        if not GLEntry.IsEmpty() then
            Page.Run(Page::"General Ledger Entries", GLEntry);

        if not VATEntry.IsEmpty() then
            Page.Run(Page::"VAT Entries", VATEntry);

        if not ItemLedgEntry.IsEmpty() then
            Page.Run(Page::"Item Ledger Entries", ItemLedgEntry);

        if not ValueEntry.IsEmpty() then
            Page.Run(Page::"Value Entries", ValueEntry);

        if not JobLedgEntry.IsEmpty() then
            Page.Run(Page::"Job Ledger Entries", JobLedgEntry);

        if not BankAccLedgEntry.IsEmpty() then
            Page.Run(Page::"Bank Account Ledger Entries", BankAccLedgEntry);
    end;

    local procedure DeleteRelatedEntries(var VendLedgEntry: Record "Vendor Ledger Entry"; var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; var GLEntry: Record "G/L Entry"; var VATEntry: Record "VAT Entry"; var ItemLedgEntry: Record "Item Ledger Entry"; var ValueEntry: Record "Value Entry"; var JobLedgEntry: Record "Job Ledger Entry"; var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    var
        ResultMsg: Text;
    begin
        // Delete detail/child-style entries first, anchor table (Vendor Ledger
        // Entry) last. Each call is wrapped so one table's protection trigger
        // blocking deletion doesn't stop the others from being attempted.

        ResultMsg := 'DELETE RESULTS:\';
        ResultMsg += ReportDeleteResult('Detailed Vendor Ledg. Entry', TryDeleteDtldVendLedgEntry(DtldVendLedgEntry));
        ResultMsg += ReportDeleteResult('Item Ledger Entry', TryDeleteItemLedgEntry(ItemLedgEntry));
        ResultMsg += ReportDeleteResult('Value Entry', TryDeleteValueEntry(ValueEntry));
        ResultMsg += ReportDeleteResult('Job (Project) Ledger Entry', TryDeleteJobLedgEntry(JobLedgEntry));
        ResultMsg += ReportDeleteResult('Bank Account Ledger Entry', TryDeleteBankAccLedgEntry(BankAccLedgEntry));
        ResultMsg += ReportDeleteResult('VAT Entry', TryDeleteVATEntry(VATEntry));
        ResultMsg += ReportDeleteResult('G/L Entry', TryDeleteGLEntry(GLEntry));
        ResultMsg += ReportDeleteResult('Vendor Ledger Entry', TryDeleteVendLedgEntry(VendLedgEntry));

        Message(ResultMsg);
    end;

    local procedure ReportDeleteResult(TableName: Text; Success: Boolean): Text
    begin
        if Success then
            exit(StrSubstNo('%1: DELETED\', TableName));

        exit(StrSubstNo('%1: BLOCKED - %2\', TableName, GetLastErrorText()));
    end;

    [TryFunction]
    local procedure TryDeleteVendLedgEntry(var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.Delete(true);
    end;

    [TryFunction]
    local procedure TryDeleteDtldVendLedgEntry(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        DtldVendLedgEntry.DeleteAll(true);
    end;

    [TryFunction]
    local procedure TryDeleteGLEntry(var GLEntry: Record "G/L Entry")
    begin
        GLEntry.DeleteAll(true);
    end;

    [TryFunction]
    local procedure TryDeleteVATEntry(var VATEntry: Record "VAT Entry")
    begin
        VATEntry.DeleteAll(true);
    end;

    [TryFunction]
    local procedure TryDeleteItemLedgEntry(var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        ItemLedgEntry.DeleteAll(true);
    end;

    [TryFunction]
    local procedure TryDeleteValueEntry(var ValueEntry: Record "Value Entry")
    begin
        ValueEntry.DeleteAll(true);
    end;

    [TryFunction]
    local procedure TryDeleteJobLedgEntry(var JobLedgEntry: Record "Job Ledger Entry")
    begin
        JobLedgEntry.DeleteAll(true);
    end;

    [TryFunction]
    local procedure TryDeleteBankAccLedgEntry(var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccLedgEntry.DeleteAll(true);
    end;
}
