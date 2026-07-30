table 50110 "Bank Match Line"
{
    Caption = 'Bank Match Line';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Line No."; Integer) { Caption = 'Line No.'; }
        field(2; "Document No."; Code[20]) { Caption = 'Document No.'; }
        field(3; "Posting Date"; Date) { Caption = 'Posting Date'; }
        field(4; "Amount"; Decimal) { Caption = 'Amount'; }
        field(5; "Entry No."; Integer) { Caption = 'Entry No.'; }
        field(6; "Matched"; Boolean) { Caption = 'Matched'; }
    }

    keys
    {
        key(PK; "Line No.") { Clustered = true; }
    }
}