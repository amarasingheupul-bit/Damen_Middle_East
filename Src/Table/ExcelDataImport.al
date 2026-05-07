Table 50104 "Excel Data Import"


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
        field(3; "Entry##"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry##';

        }
        field(4; "Value 2"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'LCY Value';
            DecimalPlaces = 0 : 2;
        }
        field(5; "Value 3"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Text Value';

        }
        field(6; "UpdateField"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Update Field';

        }

        field(7; "Value 4"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code Value';

        }
        field(8; "Value 5"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value Additional';
            DecimalPlaces = 0 : 2;
        }

        field(9; "Legend"; Text[13])
        {
            DataClassification = CustomerContent;
            Caption = 'Legend';

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