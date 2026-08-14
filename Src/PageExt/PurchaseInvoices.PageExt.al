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
        addafter("Email Approval Status")
        {

            field("External Approver 2 No."; "External Approver 2 No.")
            {
                ApplicationArea = All;
            }
            field("External Approver 1 Email"; "External Approver 1 Email")
            {
                ApplicationArea = All;
            }
            field("External Approver 2 Email"; "External Approver 2 Email")
            {
                ApplicationArea = All;
            }
            field("Incoming PO"; "Incoming PO")
            {
                ApplicationArea = All;
            }
        }
        modify("Purchaser Code")
        {
            ApplicationArea = All;
            Visible = true;
            Caption = 'Email Approver 1 No.';
        }

    }
}