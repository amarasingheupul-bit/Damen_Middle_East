table 50102 ServiceItemMatrixS365
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Service Item 1 S365"; Code[20])
        {
            Caption = 'Service Item';
            DataClassification = CustomerContent;
            TableRelation = Item where(Type=filter('Service')); // Relates to the Item table
        }
        field(2; "Service Item 2 S365"; Code[20])
        {
            Caption = 'Restricted Service Item';
            DataClassification = CustomerContent;
            TableRelation = Item where(Type=filter('Service')); // Relates to the Item table
        }
    }
    keys
    {
        key(PK; "Service Item 1 S365", "Service Item 2 S365")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        ReverseCombination: Record "ServiceItemMatrixS365";
    begin
        // Validate that "Item Code 1" and "Item Code 2" are not identical
        if "Service Item 1 S365" = "Service Item 2 S365" then Error(ItemIncErr);
        // Validate that reverse combination does not already exist
        if ReverseCombination.Get("Service Item 2 S365", "Service Item 1 S365")then Error(CombExistErr);
    end;
    var ItemIncErr: Label 'An item cannot be incompatible with itself.';
    CombExistErr: Label 'This combination already exists as a reverse combination.';
}
