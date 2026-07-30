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
                field("Incoming PO"; "Incoming PO")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter("Purchaser Code")
        {
            field("Sales Secretary No."; Rec."External Approver 2 No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Secretary No. field.';
            }
        }
        addlast(General)
        {
            field("Email Approval Status"; Rec."Email Approval Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email Approval Status field.';
                Editable = false;
                Style = StrongAccent;
            }
            field("SalesDirecotor Email"; Rec."External Approver 1 Email")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Director Email field.';
            }
            field("Sales Secretary Email"; Rec."External Approver 2 Email")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Secretary Email field.';
            }
            field("Approval Rejection Reason"; Rec."Approval Rejection Reason")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approval Rejection Reason field.';
            }
        }
        modify("Purchaser Code")
        {
            Caption = 'Email Approver 1 No.';
        }
        addafter("Currency Code")
        {
            field("FX Rate"; Rec."FX Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FX Rate field.';
            }
        }
        modify("Vendor Order No.")
        {
            Visible = true;
        }
        moveafter("Incoming PO"; "Vendor Order No.")
        addafter("Vendor Order No.")
        {
            field("Related PO"; "Related PO")
            {
                ApplicationArea = All;
            }
            field("Supplier Invoice NO."; "Supplier Invoice NO.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Approval Rejection Reason")
        {
            field(Description; Description)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(Approval)
        {
            action(ReopenEmailApprovalStatus)
            {
                ApplicationArea = All;
                Caption = 'Reopen Email Approval';
                ToolTip = 'Reopen the email approval process for this purchase invoice.';
                Image = ReopenCancelled;
                trigger OnAction()
                begin
                    Rec."Email Approval Status" := Rec."Email Approval Status"::Open;
                    Rec.Modify();
                    Message('Email approval process has been reopened for this purchase invoice.');
                end;
            }
        }
        addlast(Processing)
        {
            action(ViewApprovalAudit)
            {
                Caption = 'Approval Audit Trail';
                ApplicationArea = All;
                Image = History;

                trigger OnAction()
                var
                    Audit: Record "Purch. Approval Audit";
                begin
                    Audit.SetRange("Document No.", Rec."No.");
                    Page.Run(Page::"Purch Approval Audit List", Audit);
                end;
            }
            group(CustomApproval)
            {
                action(in)
                {
                    ApplicationArea = All;
                    Caption = 'In';
                    Image = Info;
                    ToolTip = 'In';
                    trigger OnAction()
                    // begin
                    //     Rec.Status := Rec.Status::Open;
                    //     Rec.Status := Rec.Status::Open;
                    //     Rec."Email Approval Status" := Rec."Email Approval Status"::Open;
                    //     Rec.Modify();
                    // end;
                    var
                        ApprovalMgt: Codeunit PurchaseApprovalMgt;
                    begin
                        ApprovalMgt.SetStatusIn(Rec);
                    end;
                }
                action(out)
                {
                    ApplicationArea = All;
                    Caption = 'Out';
                    Image = Info;
                    ToolTip = 'Out';
                    trigger OnAction()
                    // begin
                    //     Rec.Status := Rec.Status::Released;
                    //     Rec.Status := Rec.Status::Released;
                    //     Rec."Email Approval Status" := Rec."Email Approval Status"::Approved;
                    //     Rec.Modify();
                    // end;
                    var
                        ApprovalMgt: Codeunit PurchaseApprovalMgt;
                    begin
                        ApprovalMgt.SetStatusOut(Rec);
                    end;
                }
            }
        }


    }
}