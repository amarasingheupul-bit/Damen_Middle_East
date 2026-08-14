tableextension 50112 "4HC Company Information" extends "Company Information"
{
    fields
    {
        field(50100; "Report Footer"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'Report Footer';
            Subtype = Bitmap;
        }
        field(50101; "Report Filed Hide"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Report Filed Hide';
        }
        field(50102; "Department Mandatory"; Boolean)
        {
            Caption = 'Department Mandatory on Journals';
            DataClassification = CustomerContent;
        }
        field(50103; "Employee Mandatory"; Boolean)
        {
            Caption = 'Employee Mandatory on Journals';
            DataClassification = CustomerContent;
        }
    }
}