tableextension 50113 "4HC Job Task" extends "Job Task"
{
    fields
    {
        field(50100; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ObsoleteState = Removed;
        }
    }
}