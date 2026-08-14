report 50124 "Delete Realized Gain-Loss Entr"
{
    Caption = 'Delete Realized Gain/Loss Entries - Processed Only';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;   // <-- runs silently, no layout / no screen output
    Permissions = tabledata "Detailed Cust. Ledg. Entry" = RIMD;

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
        {
            RequestFilterFields = "Entry No.";

            trigger OnPreDataItem()
            var
                FilterText: Text;
            begin
                FilterText := BuildFilterFromList(EntryNoList);
                if FilterText <> '' then
                    SetFilter("Entry No.", FilterText);

                if (EntryNoList = '') and (GetFilter("Entry No.") = '') then
                    Error('Please enter at least one Entry No., either in the filter above or the Entry No. List box.');
            end;

            trigger OnAfterGetRecord()
            begin
                // Safety check: only ever delete Realized Gain / Realized Loss lines -
                // never an Initial Entry or Application entry, even if the wrong
                // Entry No. gets typed in by mistake.
                if not ("Entry Type" in
                        ["Entry Type"::"Realized Loss", "Entry Type"::"Realized Gain", "Entry Type"::"Correction of Remaining Amount"])
                then
                    exit;

                Delete(false);
                DeletedCount += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(EntrySelection)
                {
                    Caption = 'Entry Selection';

                    field(EntryNoListField; EntryNoList)
                    {
                        ApplicationArea = All;
                        Caption = 'Entry No. List (optional)';
                        MultiLine = true;
                        ToolTip = 'Paste one Entry No. per line to delete several at once. If left blank, the "Entry No." filter above is used instead.';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        Message('Deleted %1 Detailed Cust. Ledg. Entry record(s).', DeletedCount);
    end;

    var
        EntryNoList: Text;
        DeletedCount: Integer;

    local procedure BuildFilterFromList(RawList: Text): Text
    var
        Lines: List of [Text];
        Line: Text;
        FilterText: Text;
        CR: Text[1];
        LF: Text[1];
    begin
        if RawList = '' then
            exit('');

        CR[1] := 13;
        LF[1] := 10;

        Lines := RawList.Split(LF, CR);
        foreach Line in Lines do begin
            Line := DelChr(Line, '<>', ' ');   // trim whitespace
            if Line <> '' then begin
                if FilterText <> '' then
                    FilterText += '|';
                FilterText += Line;
            end;
        end;

        exit(FilterText);
    end;
}
