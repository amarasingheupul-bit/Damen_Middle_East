pageextension 50104 SQS365 extends "Sales Quote"
{
    actions
    {
        addafter("Archive Document")
        {
            action("AmendQuote&Archive S365")
            {
                Caption = 'Amend Quote & Archive_v1';
                ToolTip = 'Copy document lines and header information from another sales document to this document and send the document to the archive';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    S365Functions.SalesQuoteAmendArchive(Rec);
                end;
            }
        }
    }
    var S365Functions: Codeunit S365Functions;
}
