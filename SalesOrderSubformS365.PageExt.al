pageextension 50110 SalesOrderSubformS365 extends "Sales Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Package Type S365"; Rec."Package Type S365")
            {
                ApplicationArea = all;
                ToolTip = 'Specify sales qoute package type';
                Visible = false;
            }
            field(WidthS365; Rec.WidthS365)
            {
                ApplicationArea = all;
                ToolTip = 'Specify sales qoute package width';
                Visible = false;
            }
            field(HeightS365; Rec.HeightS365)
            {
                ApplicationArea = all;
                ToolTip = 'Specify sales qoute package height';
                Visible = false;
            }
            field(LengthS365; Rec.LengthS365)
            {
                ApplicationArea = all;
                ToolTip = 'Specify sales qoute package length';
                Visible = false;
            }
            field("Package Net Weight S365"; Rec."Net Weight")
            {
                ApplicationArea = all;
                ToolTip = 'Specify sales qoute package net weight';
                Visible = false;
            }
        }
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
    }
}
