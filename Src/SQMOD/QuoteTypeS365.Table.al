table 50101 "Quote Type S365"
{
    Caption = 'Quote Type';
    DataClassification = ToBeClassified;
    LookupPageId = "Quote Type S365";

    fields
    {
        field(1; "Code S365"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Discription S365"; Text[50])
        {
            Caption = 'Discription';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code S365")
        {
            Clustered = true;
        }
    }
}
