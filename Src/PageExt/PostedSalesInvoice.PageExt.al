pageextension 50126 "4HC Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addafter(General)
        {
            group("New Fields S365")
            {
                ShowCaption = true;
                Caption = 'Additional Order Details';

                field("Quote Type S365"; Rec."Quote Type S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Type field.';
                    TableRelation = "Quote Type S365"."Code S365";
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
                field(ConfirmedS365; Rec.ConfirmedS365)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value for confirmed qoutes';
                }
                field("Quote Status S365"; Rec."Quote Status S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Status field.';
                }
                field("Shipment Method Code S365"; Rec."Shipment Method Code")
                {
                    Caption = 'Incoterms';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoterms field.';
                    Visible = false;
                }
                field("End User/ Main Customer"; Rec."End User/ Main Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End User field.', Comment = '%';
                }
                field("Supplier to Services"; Rec."Supplier to Services")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supplier to Services field.', Comment = '%';
                }

                field("Sales Derector/ Area Director"; Rec."Sales Director/ Area Director")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Derector/ Area Director field.', Comment = '%';
                }
                field("Sales/ Area Director Name"; Rec."Sales/ Area Director Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales/ Area Director Name field.', Comment = '%';
                    Editable = false;
                }
                field("Sales Secretary No."; Rec."Sales Secretary No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Secretary No. field.', Comment = '%';
                }
                field("Sales Secretary Name"; Rec."Sales Secretary Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Secretary Name field.', Comment = '%';
                }
                field("Yard No."; Rec."Yard No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Yard No. field.', Comment = '%';
                }
                field("Milestones Dates and Amounts"; Rec."Milestones Dates and Amounts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Milestones with Dates and Amounts field.', Comment = '%';
                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Area field.', Comment = '%';
                }
                field("4HC Type"; Rec."4HC Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("COST Reference"; Rec."COST Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the COST Reference field.', Comment = '%';
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost Center field.', Comment = '%';
                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget field.', Comment = '%';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                }
                field("Incoming PO"; Rec."Incoming PO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoming PO field.', Comment = '%';
                }
                field("OPCO Customer"; Rec."OPCO Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the OPCO Customer field.', Comment = '%';
                }
                field("Sales Manager"; Rec."Sales Manager")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Manager field.', Comment = '%';
                }
                field("Bank Details"; Rec."Bank Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Details field.';
                }
            }
        }
    }

    /* actions
    {
        addafter(Print)
        {
            action(TaxInvoice)
            {
                Caption = 'Tax Invoice';
                Image = TaxPayment;
                ToolTip = 'Generates the Tax Invoice for the selected sales order.';
                ApplicationArea = Suite;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"4HC Posted Sales Tax Invoice", true, true, SalesInvHeader);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(TaxInvoice_Promoted; TaxInvoice)
            {
            }
        }
    } */
}