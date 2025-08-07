table 50120 "Charge Item MappingS365"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item; // Link to Item table
        }
        field(2; "Charge Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Item Charge";
        }
    }
    keys
    {
        key(PK; "Item No.", "Charge Item No.")
        {
            Clustered = true;
        }
    }
}
