tableextension 50115 "4HC Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50125; "Yard No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}