table 50108 "GL Bank Match Buffer"
{
    Caption = 'GL Bank Match Buffer';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(2; "GL Document No."; Code[20]) { Caption = 'G/L Document No.'; }
        field(3; "Bank Document No."; Code[20]) { Caption = 'Bank Document No.'; }
        field(4; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(5; "GL Amount"; Decimal) { Caption = 'G/L Amount'; AutoFormatType = 1; }
        field(6; "Bank Amount"; Decimal) { Caption = 'Bank Ledger Amount'; AutoFormatType = 1; }
        field(7; "Difference"; Decimal) { Caption = 'Difference'; AutoFormatType = 1; }
        field(8; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Matched,Mismatched,"Missing in Bank","Missing in GL";
        }
        field(9; "GL Entry No."; Integer) { Caption = 'G/L Entry No.'; }
        field(10; "Bank Ledger Entry No."; Integer) { Caption = 'Bank Ledger Entry No.'; }
        field(11; "Match Method"; Text[20]) { Caption = 'Matched By'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
