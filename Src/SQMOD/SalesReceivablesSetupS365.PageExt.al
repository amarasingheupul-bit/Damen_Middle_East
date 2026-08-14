pageextension 50103 SalesReceivablesSetupS365 extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field(ArchiveandDeleteQuoteS365; Rec.ArchiveandDeleteQuoteS365)
            {
                ApplicationArea = all;
                ToolTip = 'Specify Archive and delete quote.';
            }
            field("Apply Field Visibility Rules"; Rec."Apply Field Visibility Rules")
            {
                ApplicationArea = All;
                ToolTip = 'Enable this setting to apply custom field visibility rules based on company-specific preferences. When activated, selected fields will be hidden to simplify the interface or restrict access.';
            }
        }
    }
}
