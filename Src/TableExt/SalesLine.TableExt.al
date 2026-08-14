tableextension 50102 "4HC Sales Line" extends "Sales Line"
{
    fields
    {
        field(50100; "Employee"; code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('EMPLOYEE'));

        }
    }
}
