codeunit 50107 "Pmt. Jnl.Doc.Link Propagation"
{
    // After the journal batch posts, find every G/L Entry, Vendor Ledger Entry,
    // and Customer Ledger Entry that was created from lines that had an attached
    // Incoming Document, and stamp the document link on those entries.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line",
        'OnAfterInsertGlobalGLEntry', '', false, false)]
    local procedure OnAfterInsertGLEntry(var GLEntry: Record "G/L Entry")
    var
        IncomingDocumentLink: Record "Incoming Document Attachment";
        RecRef: RecordRef;
        GenJournalLine: Record "Gen. Journal Line";

    begin
        if GenJournalLine."Incoming Document Entry No." = 0 then
            exit;

        RecRef.GetTable(GLEntry);
        CopyIncomingDocLinks(GenJournalLine."Incoming Document Entry No.", RecRef);
    end;


    local procedure CopyIncomingDocLinks(
        IncomingDocEntryNo: Integer;
        var TargetRecRef: RecordRef)
    var
        SourceAttachment: Record "Incoming Document Attachment";
        TargetAttachment: Record "Incoming Document Attachment";
        IncomingDoc: Record "Incoming Document";
    begin
        if not IncomingDoc.Get(IncomingDocEntryNo) then
            exit;

        // Link the Incoming Document header to the posted entry
        IncomingDoc."Related Record ID" := TargetRecRef.RecordId();
        IncomingDoc.Modify(false);

        // Copy every physical attachment file to the target record
        SourceAttachment.SetRange("Incoming Document Entry No.", IncomingDocEntryNo);
        if SourceAttachment.FindSet() then
            repeat
                TargetAttachment.Init();
                TargetAttachment.TransferFields(SourceAttachment);
                //TargetAttachment."Related Record ID" := TargetRecRef.RecordId();
                if TargetAttachment.Insert(false) then;
            until SourceAttachment.Next() = 0;
    end;
}