pageextension 50120 "4HC JobTaskLinesSubform" extends "Job Task Lines Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("4HC Schedule (Total Cost)"; Rec."4HC Schedule (Total Cost)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Budget (Total Cost) field.';
            }
            field("4HC Usage (Total Cost)"; Rec."4HC Usage (Total Cost)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Actual (Total Cost) field.';
            }
            field("4HC Contract (Total Price)"; Rec."4HC Contract (Total Price)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Billable (Total Price) field.';
            }
            field("4HC Contract (Invoiced Price)"; Rec."4HC Contract (Invoiced Price)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoiced (Total Price) field.';
            }
        }
        modify("Schedule (Total Cost)")
        {
            Caption = 'Budget (Total Cost)(LCY)';
        }
        modify("Usage (Total Cost)")
        {
            Caption = 'Actual (Total Cost)(LCY)';
        }
        modify("Contract (Total Price)")
        {
            Caption = 'Billable (Total Price)(LCY)';
        }
        modify("Contract (Invoiced Price)")
        {
            Caption = 'Invoiced (Total Price)(LCY)';
        }
    }
}