pageextension 50137 "Purch. Invoice SubformExt" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field(Employee; rec.Employee)
            {
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}