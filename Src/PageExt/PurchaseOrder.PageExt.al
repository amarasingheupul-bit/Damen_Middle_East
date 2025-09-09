pageextension 50115 "4HC Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter(General)
        {
            group(VendDetails)
            {
                ShowCaption = true;
                Caption = 'Additional Order Details';

                field("Commission Amount"; Rec."Commission Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the commission value for this purchase order.';
                }
                field("OPCO Com Project No."; Rec."OPCO Com Project No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates the OPCO commercial project number associated with the order.';
                }
                field("SPA Date"; Rec."SPA Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Defines the date of the signed purchase agreement.';
                }
                field("Amendment Date"; Rec."Amendment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the date of the last amendment to this purchase.';
                }
                field("Yard No."; Rec."Yard No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the yard reference for this order.';
                }
                field("Vessel Type"; Rec."Vessel Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vessel Type field.';
                }
                field("Quote Type"; Rec."Quote Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Type field.';
                }
                field("Cost Reference"; Rec."Cost Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Reference field.';
                }
                field("Milestones Dates and Amounts"; Rec."Milestones Dates and Amounts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Details key milestones, dates, and financial amounts linked to this purchase.';
                }
                field("Group Customer with One Stream"; Rec."Group Customer with One Stream")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer code from One Stream associated with this purchase.';
                }
                field("Group Customr Name"; Rec."Group Customr Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Automatically shows the customer name retrieved from One Stream on validation.';
                }
                field("Sales Derector/ Area Director"; Rec."Sales Director/ Area Director")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Derector/ Area Director field.';
                }
                field("Sales/ Area Director Name"; Rec."Sales/ Area Director Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales/ Area Director Name field.';
                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget field.';
                }
                field("Bank Details"; Rec."Bank Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Details field.';
                }
                field("Change Reason S365"; Rec."Change Reason S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Change Reason field.';
                }
                field("Original Quote No. S365"; Rec."Original Quote No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Quote No. field.';
                }
                field("Quote Status S365"; Rec."Quote Status S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Status field.';
                }
                field("End User/ Main Customer"; Rec."End User/ Main Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End User field.';
                }
                field("Supplier to Services"; Rec."Supplier to Services")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supplier to Services field.';
                }
                field("Sales Secretary No."; Rec."External Approver 2 No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Secretary No. field.';
                }
                field("Sales Secretary Name"; Rec."Sales Secretary Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Secretary Name field.';
                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Area field.';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field("Incoming PO"; Rec."Incoming PO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoming PO field.';
                }
                field("OPCO Customer"; Rec."OPCO Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the OPCO Customer field.';
                }
                field("Sales Manager"; Rec."Sales Manager")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Manager field.';
                }
            }
        }
    }

    actions
    {
        modify(Email)
        {
            Enabled = PrintActionEnable;
        }
        modify(Print)
        {
            Enabled = PrintActionEnable;
        }
        modify(SendCustom)
        {
            Enabled = PrintActionEnable;
        }
        modify(AttachAsPDF)
        {
            Enabled = PrintActionEnable;
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Released then
            PrintActionEnable := true
        else
            PrintActionEnable := false;
    end;

    var
        PrintActionEnable: Boolean;
}
