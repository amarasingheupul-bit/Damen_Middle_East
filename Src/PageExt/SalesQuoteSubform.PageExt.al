pageextension 50122 "Sales Quote Subform EXT" extends "Sales Quote Subform"
{
    layout
    {
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
    }

    actions
    {
        addlast(processing)
        {
            action("Add Charge ItemsS365")
            {
                Caption = 'Add Charge Items';
                ApplicationArea = All;
                ToolTip = 'Add Charge items for selected service item';

                trigger OnAction()
                var
                    SQmodFunction: Codeunit "SQmodFunction S365";
                begin
                    SQmodFunction.AddChargeItem(Rec);
                end;
            }
        }
    }
}
