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
    }
}