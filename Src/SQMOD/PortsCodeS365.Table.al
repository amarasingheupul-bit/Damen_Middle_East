table 50103 "Ports Code S365"
{
    Caption = 'Ports Code';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Ports Code List S365";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Descritption; Text[50])
        {
            Caption = 'Descritption';
            DataClassification = CustomerContent;
        }
        field(3; Type;Enum "Ports Code Types S365")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Descritption)
        {
        }
        fieldgroup(Brick; Code, Descritption)
        {
        }
    }
}
