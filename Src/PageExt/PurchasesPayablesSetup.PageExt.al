pageextension 50131 "4HC Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Block Invoice Posting"; Rec."Block Invoice Posting")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Block Invoice Posting field.';
            }
            field("Enable Email Approval"; Rec."Enable Email Approval")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enable Email Approval field.';
            }
        }
    }
}
