report 50122 "Delete Document Entries"
{
    // ============================================================
    // Processing Only report:
    // Deletes all ledger entries related to a given Document No.
    // Covers the tables shown in the "Related Entries" factbox
    // (G/L Entry, VAT Entry) plus the other commonly related tables.
    //
    // WARNING: Posted ledger tables are normally protected from direct
    // deletion for audit/integrity reasons. Prefer "Reverse Transaction"
    // in production. Use this only in a sandbox/test environment, or
    // for correcting genuinely bad test data.
    // ============================================================

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Delete Document Entries (by Document No.)';
    Permissions = tabledata "VAT Entry" = RIMD,
    tabledata "G/L Entry" = RIMD;

    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            RequestFilterFields = "Document No.", "Posting Date";

            trigger OnPreDataItem()
            begin
                if GLEntry.GetFilter("Document No.") = '' then
                    Error('Please enter a Document No. filter before running this report.');

                DocNoFilter := GLEntry.GetFilter("Document No.");
            end;

            trigger OnAfterGetRecord()
            begin
                GLEntryCount += 1;

                // Delete Dimension Set Entries linked to this G/L Entry's Dimension Set ID
                DimSetEntry.SetRange("Dimension Set ID", GLEntry."Dimension Set ID");
                if not DimSetEntry.IsEmpty() then begin
                    DimSetEntry.DeleteAll();
                end;

                GLEntry.Delete();
            end;

            trigger OnPostDataItem()
            begin
                // ---- VAT Entry ----
                VATEntry.SetRange("Document No.", DocNoFilter);
                if VATEntry.FindSet() then
                    repeat
                        VATEntryCount += 1;
                    until VATEntry.Next() = 0;
                VATEntry.SetRange("Document No.", DocNoFilter);
                VATEntry.DeleteAll();



                // // ---- Vendor Ledger Entry ----
                // VendLedgEntry.SetRange("Document No.", DocNoFilter);
                // if VendLedgEntry.FindSet() then
                //     repeat
                //         VendLedgEntryCount += 1;
                //     until VendLedgEntry.Next() = 0;
                // VendLedgEntry.SetRange("Document No.", DocNoFilter);
                // VendLedgEntry.DeleteAll();

                // // ---- Detailed Vendor Ledger Entry ----
                // DtldVendLedgEntry.SetRange("Document No.", DocNoFilter);
                // if DtldVendLedgEntry.FindSet() then
                //     repeat
                //         DtldVendLedgEntryCount += 1;
                //     until DtldVendLedgEntry.Next() = 0;
                // DtldVendLedgEntry.SetRange("Document No.", DocNoFilter);
                // DtldVendLedgEntry.DeleteAll();

                // // ---- Customer Ledger Entry ----
                // CustLedgEntry.SetRange("Document No.", DocNoFilter);
                // if CustLedgEntry.FindSet() then
                //     repeat
                //         CustLedgEntryCount += 1;
                //     until CustLedgEntry.Next() = 0;
                // CustLedgEntry.SetRange("Document No.", DocNoFilter);
                // CustLedgEntry.DeleteAll();

                // // ---- Detailed Customer Ledger Entry ----
                // DtldCustLedgEntry.SetRange("Document No.", DocNoFilter);
                // if DtldCustLedgEntry.FindSet() then
                //     repeat
                //         DtldCustLedgEntryCount += 1;
                //     until DtldCustLedgEntry.Next() = 0;
                // DtldCustLedgEntry.SetRange("Document No.", DocNoFilter);
                // DtldCustLedgEntry.DeleteAll();

                // // ---- Bank Account Ledger Entry ----
                // BankLedgEntry.SetRange("Document No.", DocNoFilter);
                // if BankLedgEntry.FindSet() then
                //     repeat
                //         BankLedgEntryCount += 1;
                //     until BankLedgEntry.Next() = 0;
                // BankLedgEntry.SetRange("Document No.", DocNoFilter);
                // BankLedgEntry.DeleteAll();

                Message(
                    'Deleted entries for Document No. %1:\' +
                    'G/L Entry: %2\' +
                    'VAT Entry: %3\' +
                    'Detailed G/L Entry: %4\' +
                    'Vendor Ledger Entry: %5\' +
                    'Detailed Vendor Ledger Entry: %6\' +
                    'Customer Ledger Entry: %7\' +
                    'Detailed Customer Ledger Entry: %8\' +
                    'Bank Account Ledger Entry: %9',
                    DocNoFilter, GLEntryCount, VATEntryCount, DtldGLEntryCount,
                    VendLedgEntryCount, DtldVendLedgEntryCount,
                    CustLedgEntryCount, DtldCustLedgEntryCount, BankLedgEntryCount);
            end;
        }
    }

    var
        VATEntry: Record "VAT Entry";
        //DtldGLEntry: Record "Detailed G/L Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        BankLedgEntry: Record "Bank Account Ledger Entry";
        DimSetEntry: Record "Dimension Set Entry";
        DocNoFilter: Code[20];
        GLEntryCount: Integer;
        VATEntryCount: Integer;
        DtldGLEntryCount: Integer;
        VendLedgEntryCount: Integer;
        DtldVendLedgEntryCount: Integer;
        CustLedgEntryCount: Integer;
        DtldCustLedgEntryCount: Integer;
        BankLedgEntryCount: Integer;
}
