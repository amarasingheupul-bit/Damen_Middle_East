tableextension 50106 ResourceS365 extends Resource
{
    fields
    {
        field(50100; "TransportManagerS365"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Transport Manager';
            TableRelation = "User Setup"."User ID";
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
