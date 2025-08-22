tableextension 50111 "4HC Customer" extends Customer
{
    fields
    {
        field(50100; "REF SAP ID"; Code[20])
        {
            Caption = 'REF SAP ID';
            DataClassification = CustomerContent;
        }
        field(50101; "REF IFS ID"; Code[20])
        {
            Caption = 'REF IFS ID';
            DataClassification = CustomerContent;
        }
        field(50102; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = SystemMetadata;
        }
        field(50103; "DUNS No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'DUNS No.';
        }
    }
    trigger OnInsert()
    begin
        "Creation Date" := Today();
    end;
}