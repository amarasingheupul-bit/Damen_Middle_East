pageextension 50133 "GL Entries Attachment FactBox" extends "General Ledger Entries"
{
    layout
    {
        modify(Control1905767507)   // system Notes part - check your page's actual control name
        {
            Visible = false;
        }
    }
    actions
    {
        addlast(navigation)
        {
            action(IncomingDocAction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Incoming Document';
                Image = Document;
                ToolTip = 'View the incoming document attached to this entry.';

                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                begin
                    IncomingDocument.SetRange("Related Record ID", Rec.RecordId());
                    if IncomingDocument.FindFirst() then
                        Page.Run(Page::"Incoming Document", IncomingDocument)
                    else
                        Message('No incoming document is attached to this entry.');
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.IncomingDocAttachFactBox.Page.SetCurrentRecordID(Rec.RecordId());
    end;
}