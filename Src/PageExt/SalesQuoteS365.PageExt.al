pageextension 50102 "Sales Quote S365" extends "Sales Quote"
{
    layout
    {
        addafter(General)
        {
            group("New Fields S365")
            {
                ShowCaption = true;
                Caption = 'Additional Quote Details';

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
                field("Job No. S365"; Rec."Job No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Job No.';
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
            }
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Sell-to Customer Templ. Code")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
    }
    actions
    {
        addafter("Archive Document")
        {
            action("Amend Quote & Archive S365")
            {
                Caption = 'Amend Quote & Archive';
                ToolTip = 'Copy document lines and header information from another sales document to this document and send the document to the archive';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SQmodFunction.SalesQuoteAmendArchive(Rec);
                end;
            }
            action(ConfirmS365)
            {
                Caption = 'Confirm Qoute';
                ToolTip = 'Confirm this qoute and prepare for make order';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Confirm;

                trigger OnAction()
                begin
                    SQmodFunction.ConfirmQoute(Rec);
                end;
            }
        }
    }
    var
        SQmodFunction: Codeunit "SQmodFunction S365";
}
