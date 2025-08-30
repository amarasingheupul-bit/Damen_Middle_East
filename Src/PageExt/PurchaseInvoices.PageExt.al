pageextension 50129 "4HC Purchase Invoices" extends "Purchase Invoices"
{
    layout
    {
        modify(Status)
        {
            Visible = true;
        }
        addafter(Status)
        {
            field("Email Approval Status"; Rec."Email Approval Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email Approval Status field.';
                Style = Strong;
                Editable = false;
            }
        }
    }
}