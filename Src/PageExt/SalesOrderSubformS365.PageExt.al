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
        addafter(ShortcutDimCode3)
        {
            field("Job No."; "Job No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Job Task No."; "Job Task No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Job Contract Entry No."; "Job Contract Entry No.")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }

    }
}
