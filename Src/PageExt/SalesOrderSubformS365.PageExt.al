pageextension 50110 "EXT Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify("Net Weight")
        {
            Visible = false;
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
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
