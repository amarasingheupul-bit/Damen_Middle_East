pageextension 50121 "4HC Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
        }
    }
}