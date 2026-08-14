tableextension 50120 "Purchase LineExt" extends "Purchase Line"
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