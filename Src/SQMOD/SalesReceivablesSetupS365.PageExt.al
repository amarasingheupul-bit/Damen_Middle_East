pageextension 50103 SalesReceivablesSetupS365 extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field(ArchiveandDeleteQuoteS365; Rec.ArchiveandDeleteQuoteS365)
            {
                ApplicationArea = all;
                ToolTip = 'Specify Archive and delete quote.';
            }
        }
    }
}
