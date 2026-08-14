tableextension 50103 "ItemChargeS365" extends "Item Charge"
{
    fields
    {
        field(50100; "QuoteType S365"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Type';
            TableRelation = "Quote Type S365"."Code S365";
        }
        field(50101; "Charge UOM S365"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Charge UOM';
            TableRelation = "Unit of Measure".Code;
        }
        field(50102; "Charge Amount S365"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Amount';
        }
        field(50103; "Minimum Charge S365"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Charge';
        }
    }
    keys
    {
    // Add changes to keys here
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
}
