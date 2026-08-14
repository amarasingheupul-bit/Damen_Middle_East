tableextension 50119 "Gen. Journal LineExt" extends "Gen. Journal Line"
{
    fields
    {
        field(50100; "Employee"; code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('EMPLOYEE'));

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