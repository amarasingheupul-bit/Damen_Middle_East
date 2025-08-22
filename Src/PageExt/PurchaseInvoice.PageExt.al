pageextension 50125 "4HC Purchase Invoice" extends "Purchase Invoice"
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
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Center field.';
                }
            }
        }
    }
}