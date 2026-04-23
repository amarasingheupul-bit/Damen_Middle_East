pageextension 50119 "4HC Payment Journal" extends "Payment Journal"
{
    layout
    {
    }
    actions
    {
        addafter(IncomingDoc)
        {
            action(AttachDocument)
            {
                ApplicationArea = All;
                Caption = 'Attach Document';
                Image = Attach;
                Scope = Repeater;
                ToolTip = 'Select or create an incoming document record to attach to this payment journal line.';

                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    Rec.Validate(
                        "Incoming Document Entry No.",
                        IncomingDocument.SelectIncomingDocument(
                            Rec."Incoming Document Entry No.",
                            Rec.RecordId()
                        )
                    );
                    CurrPage.SaveRecord();
                end;
            }
        }
        addlast("Category_Category9")   // promotes into the Line group on the ribbon
        {
            actionref(AttachDocument_Promoted; AttachDocument) { }
        }
    }
}