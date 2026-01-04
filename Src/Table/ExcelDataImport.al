#pragma warning disable AA0215
table 50104 "Excel Data Import"
#pragma warning restore AA0215
{

    Caption = 'Excel Data Import';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(3; "Value 1"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Exchange Rate';
            DecimalPlaces = 0 : 5;
        }
        field(4; "Value 2"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'LCY Value';
            DecimalPlaces = 0 : 2;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(DocNo; "Document No.")
        {
        }
    }

}