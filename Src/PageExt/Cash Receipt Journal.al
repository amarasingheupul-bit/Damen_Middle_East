pageextension 50135 "Cash Receipt JournalExt" extends "Cash Receipt Journal"
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