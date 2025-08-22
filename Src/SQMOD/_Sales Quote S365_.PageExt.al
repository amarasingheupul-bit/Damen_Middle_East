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
                field("Origin S365"; Rec."Origin S365")
                {
                    Caption = 'Origin';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Origin field.';
                    Visible = false;
                }
                field("Destination S365"; Rec."Destination S365")
                {
                    Caption = 'Destination';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination field.';
                    Visible = false;
                }
                field("Place of Receipt S365"; Rec."Place of Receipt S365")
                {
                    Caption = 'Place of Receipt';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Receipt field.';
                    Visible = false;
                }
                field("Place of Delivery S365"; Rec."Place of Delivery S365")
                {
                    Caption = 'Place of Delivery';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Delivery field.';
                    Visible = false;
                }
                field("Change Reason S365"; Rec."Change Reason S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Change Reason field.';
                }
                field("Printed or Email S365"; Rec."Printed or Email S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Printed or Email field.';
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
                field("ETD S365"; Rec."ETD S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETD field.';
                    Visible = false;
                }
                field("ETA S365"; Rec."ETA S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA field.';
                    Visible = false;
                }
                field("Shipment Method Code S365"; Rec."Shipment Method Code")
                {
                    Caption = 'Incoterms';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoterms field.';
                    Visible = false;
                }
                field("MAWB No. S365"; Rec."MAWB No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB No. field.';
                    Visible = false;
                }
                field("MAWB Date S365"; Rec."MAWB Date S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB Date field.';
                    Visible = false;
                }
                field("Cross Trade S365"; Rec."Cross Trade S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cross Trade field.';
                    Visible = false;
                }
                field("Container No. S365"; Rec."Container No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container No. field.';
                    Visible = false;
                }
                field("Remarks S365"; Rec."Remarks S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("End User/ Main Customer"; Rec."End User/ Main Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End User field.', Comment = '%';
                }
                field("Supplier to Services"; Rec."Supplier to Services")
                {
                    ApplicationArea = All;
                }
                field("Sales Derector/ Area Director"; Rec."Sales Derector/ Area Director")
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
