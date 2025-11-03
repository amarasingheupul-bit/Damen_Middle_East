pageextension 50131 "4HC Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Block Invoice Posting"; Rec."Block Invoice Posting")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Block Invoice Posting field.';
            }
            field("Enable Email Approval"; Rec."Enable Email Approval")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enable Email Approval field.';
            }
            field("Apply Field Visibility Rules"; Rec."Apply Field Visibility Rules")
            {
                ApplicationArea = All;
                ToolTip = 'Enable this setting to apply custom field visibility rules based on company-specific preferences. When activated, selected fields will be hidden to simplify the interface or restrict access.';
            }
        }
    }
}
