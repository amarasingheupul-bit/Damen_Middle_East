tableextension 50104 SalesReceivableSetupS365 extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; ArchiveandDeleteQuoteS365; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Archive and Delete Quote';
        }
        field(50102; "Apply Field Visibility Rules"; Boolean)
        {
            Caption = 'Apply Field Visibility Rules';
        }
    }
}
