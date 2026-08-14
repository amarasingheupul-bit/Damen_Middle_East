report 50118 "FixFAAcquiredStatus"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Force Reset FA Acquired Status';

    dataset
    {
        dataitem(FADeprBook; "FA Depreciation Book")
        {
            RequestFilterFields = "FA No.", "Depreciation Book Code";

            trigger OnAfterGetRecord()
            var
                FALedgerEntry: Record "FA Ledger Entry";
            begin
                // Safety Check: Check if there are any non-reversed Acquisition Cost entries
                FALedgerEntry.SetRange("FA No.", "FA No.");
                FALedgerEntry.SetRange("Depreciation Book Code", "Depreciation Book Code");
                FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                FALedgerEntry.SetRange(Reversed, false);

                if NOT FALedgerEntry.IsEmpty() then
                    Error('Asset %1 still has active Acquisition Ledger Entries. Cancel them first.', "FA No.");

                // Resetting the date to 0D (Blank) is what flips the 'Acquired' boolean to False
                Validate("Acquisition Date", 0D);
                Validate("G/L Acquisition Date", 0D);
                Modify(true);
            end;
        }
    }

    trigger OnPostReport()
    begin
        Message('Process complete. The Acquired status has been reset for the selected assets.');
    end;
}
