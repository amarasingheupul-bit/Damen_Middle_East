tableextension 50118 "Sales & Receivables SetupBase" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50120; "Skip Job Validation on Sales"; Boolean)
        {
            Caption = 'Skip Job Validation on Sales';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}