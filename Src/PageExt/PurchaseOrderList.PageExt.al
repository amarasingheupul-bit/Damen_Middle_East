pageextension 50130 "purchase order List" extends "Purchase Order List"
{
    layout
    {
        modify("Vendor Authorization No.")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        addafter("Buy-from Vendor No.")
        {
            field("Incoming PO"; rec."Incoming PO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Incoming Sales Order Related to This PO';
                Visible = IsFieldVisible;
            }
            field("Supplier to Services"; rec."Supplier to Services")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Supplier Related to This PO';
                Visible = IsFieldVisible;
            }
            field("Sales Area"; rec."Sales Area")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Sales Area Related to This PO';
                Visible = IsFieldVisible;
            }
            field("Sales/ Area Director Name"; rec."Sales/ Area Director Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Director Related to This PO';
                Visible = IsFieldVisible;
            }
            field("Sales Secretary Name"; rec."Sales Secretary Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Sales Secretary Related to This PO';
                Visible = IsFieldVisible;
            }
            field("Quote Type"; rec."Quote Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Quotation Type Related to This PO';
                Visible = IsFieldVisible;
            }
            field("Sales Order No. 4HC"; rec."Sales Order No. 4HC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the System Sales Order Related to This PO';
            }
            field(Budget; rec.Budget)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Budget Related to This PO';
            }
        }
    }
    var
        IsFieldVisible: Boolean;

    trigger OnOpenPage()
    var
        PurchPayablesSetup: Record "Purchases & Payables Setup";
    begin
        if PurchPayablesSetup.Get() then
            IsFieldVisible := not PurchPayablesSetup."Apply Field Visibility Rules";
    end;
}