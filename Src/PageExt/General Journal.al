pageextension 50136 "General JournalExt" extends "General Journal"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field(Employee; Rec.Employee)
            {
                ApplicationArea = All;
                //ShowMandatory = true;
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