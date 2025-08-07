pageextension 50105 ItemChargeS365 extends "Item Charges"
{
    layout
    {
        addbefore("No.")
        {
            field("QuoteType S365"; Rec."QuoteType S365")
            {
                ApplicationArea = all;
                ToolTip = 'Specify the Quote Type';
                TableRelation = "Quote Type S365"."Code S365";
            }
        }
        addafter("Search Description")
        {
            field("Charge UOM S365"; Rec."Charge UOM S365")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Charge UOM field.';
            }
            field("Charge Amount S365"; Rec."Charge Amount S365")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Charge Amount field.';
            }
            field("Minimum Charge S365"; Rec."Minimum Charge S365")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Minimum Charge field.';
            }
        }
    }
}
